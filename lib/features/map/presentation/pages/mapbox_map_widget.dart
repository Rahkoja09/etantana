import 'dart:math' as Math;

import 'package:e_tantana/config/constants/mapBox_const.dart';
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';
import 'package:e_tantana/features/map/presentation/controller/map_controller.dart';
import 'package:e_tantana/features/map/presentation/services/mapbox_geoservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class DeliveryMapConfig {
  final Position center;
  final double zoom;
  final String styleUri;
  final double bearing;
  final double pitch;
  final List<MapEntity> deliveries;
  final double perimeterRadius;
  final VoidCallback? onMapCreated;
  final Function(MapEntity)? onDeliveryTap;

  const DeliveryMapConfig({
    required this.center,
    this.zoom = 15.0,
    this.styleUri = 'mapbox://styles/rahkoja/cmlhrowbi000401rzgywt3afg',
    this.bearing = 0.0,
    this.pitch = 45.0,
    required this.deliveries,
    this.perimeterRadius = 200,
    this.onMapCreated,
    this.onDeliveryTap,
  });
}

class DeliveryMapWidget extends ConsumerStatefulWidget {
  final DeliveryMapConfig config;

  const DeliveryMapWidget({Key? key, required this.config}) : super(key: key);

  @override
  ConsumerState<DeliveryMapWidget> createState() => DeliveryMapWidgetState();
}

class DeliveryMapWidgetState extends ConsumerState<DeliveryMapWidget> {
  MapboxMap? mapboxMap;

  final Map<String, CircleAnnotation> _circleAnnotations = {};
  CircleAnnotationManager? _circleAnnotationManager;
  PointAnnotationManager? _pointAnnotationManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey("deliveryMapWidget"),
      styleUri: widget.config.styleUri,
      cameraOptions: CameraOptions(
        center: Point(coordinates: widget.config.center),
        zoom: widget.config.zoom,
        bearing: widget.config.bearing,
        pitch: widget.config.pitch,
      ),
      onMapCreated: (mapboxMap) {
        this.mapboxMap = mapboxMap;
        _initializeDeliveryMap();
        widget.config.onMapCreated?.call();
      },
    );
  }

  Future<void> _initializeDeliveryMap() async {
    if (mapboxMap == null) return;

    _circleAnnotationManager =
        await mapboxMap!.annotations.createCircleAnnotationManager();
    _pointAnnotationManager =
        await mapboxMap!.annotations.createPointAnnotationManager();

    for (var delivery in widget.config.deliveries) {
      await _addDeliveryCircle(delivery);
    }
  }

  Future<void> _addDeliveryCircle(MapEntity delivery) async {
    final mapState = ref.watch(mapControllerProvider);
    if (_circleAnnotationManager == null || _pointAnnotationManager == null)
      return;

    try {
      late double lat, lng;

      if (delivery.latitude == null || delivery.longitude == null) {
        await ref
            .read(mapControllerProvider.notifier)
            .getCoordinatesFromAddress(delivery.location);

        if (mapState.locations == null) {
          return;
        }

        lat = mapState.locations!.latitude!;
        lng = mapState.locations!.longitude!;
      } else {
        lat = delivery.latitude!;
        lng = delivery.longitude!;
      }

      final circleColor = _getStatusColor(delivery.status);

      final circle = await _circleAnnotationManager!.create(
        CircleAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
          circleRadius: _metersToPixels(
            widget.config.perimeterRadius,
            lat,
            widget.config.zoom,
          ),
          circleColor: circleColor.value,
          circleOpacity: 0.3,
          circleStrokeColor: circleColor.value,
          circleStrokeWidth: 2.0,
          circleStrokeOpacity: 0.8,
          circleSortKey: 1.0,
        ),
      );

      await _pointAnnotationManager!.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
          iconImage: "blue-dot",
          iconSize: 1.0,
        ),
      );

      _circleAnnotations[delivery.id] = circle;

      await _addCenterPoint(lat, lng, delivery);
    } catch (e) {
      print('Erreur ajout cercle: $e');
    }
  }

  Future<void> _addCenterPoint(
    double lat,
    double lng,
    MapEntity delivery,
  ) async {
    try {
      final pointAnnotationManager =
          await mapboxMap!.annotations.createPointAnnotationManager();

      await pointAnnotationManager.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
        ),
      );
    } catch (e) {
      print('Erreur ajout point: $e');
    }
  }

  double _metersToPixels(double meters, double latitude, double zoom) {
    final metersPerPixel =
        156543.03 * Math.cos(latitude * Math.pi / 180) / Math.pow(2, zoom);
    return meters / metersPerPixel;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> navigateToDelivery(MapEntity delivery) async {
    final mapState = ref.watch(mapControllerProvider);
    if (mapboxMap == null) return;

    try {
      late double lat, lng;

      if (delivery.latitude == null || delivery.longitude == null) {
        await ref
            .read(mapControllerProvider.notifier)
            .getCoordinatesFromAddress(delivery.location);
        if (mapState.locations == null) return;
        lat = mapState.locations!.latitude!;
        lng = mapState.locations!.longitude!;
      } else {
        lat = delivery.latitude!;
        lng = delivery.longitude!;
      }

      await mapboxMap!.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(lng, lat)),
          zoom: 16.0,
          pitch: widget.config.pitch,
        ),
        MapAnimationOptions(duration: 1500),
      );

      widget.config.onDeliveryTap?.call(delivery);
    } catch (e) {
      print('Erreur navigation: $e');
    }
  }

  Future<void> addDelivery(MapEntity delivery) async {
    await _addDeliveryCircle(delivery);
  }

  Future<void> removeDelivery(String deliveryId) async {
    if (_circleAnnotationManager == null) return;

    final circle = _circleAnnotations[deliveryId];
    if (circle != null) {
      await _circleAnnotationManager!.delete(circle);
      _circleAnnotations.remove(deliveryId);
    }
  }

  Future<void> updateDeliveryStatus(String deliveryId, String newStatus) async {
    // À implémenter: supprime l'ancien cercle et en ajoute un nouveau --------
  }

  @override
  void dispose() {
    mapboxMap = null;
    super.dispose();
  }
}
