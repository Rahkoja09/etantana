import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/features/delivring/domain/mapper/order_to_delivering_mapper.dart';
import 'package:e_tantana/features/delivring/presentation/controller/delivering_controller.dart';
import 'package:e_tantana/features/delivring/presentation/widgets/minimal_delivery_view.dart';
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';
import 'package:e_tantana/features/map/presentation/controller/map_controller.dart';
import 'package:e_tantana/features/map/presentation/states/map_states.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:e_tantana/features/map/presentation/pages/mapbox_map_widget.dart';
import 'package:e_tantana/shared/widget/loading/loading_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Delivery extends ConsumerStatefulWidget {
  const Delivery({Key? key}) : super(key: key);

  @override
  ConsumerState<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends ConsumerState<Delivery> {
  late GlobalKey<DeliveryMapWidgetState> _mapKey;
  bool isFetching = false;
  TextEditingController searchDelivering = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<MapEntity> deliveringList = [];

  @override
  void initState() {
    super.initState();
    _mapKey = GlobalKey<DeliveryMapWidgetState>();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getDelivering();
    });
  }

  Future<void> _getDelivering() async {
    await ref
        .read(deliveringControllerProvider.notifier)
        .searchDelivering(null);
  }

  Future<void> _onScroll() async {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (!ref.read(deliveringControllerProvider).isLoading) {
        setState(() {
          isFetching = true;
        });
        await ref.read(deliveringControllerProvider.notifier).loadNextPage();
        setState(() {
          isFetching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(flex: 4, child: _buildMap()),
          Expanded(flex: 6, child: _buildDeliveryList()),
        ],
      ),
    );
  }

  Widget _buildDeliveryList() {
    final deliveringState = ref.watch(deliveringControllerProvider);
    final mapState = ref.watch(mapControllerProvider);
    final actualDeliverings = deliveringState.deliverings ?? [];
    final mapEntities = actualDeliverings.map((d) => d.toMapEntity()).toList();
    final skeletonData = List.generate(
      5,
      (index) => MapEntity(
        id: "default",
        date: DateTime.now(),
        status: "default",
        price: 0.0,
        location: "default",
      ),
    );

    final isInitialLoading = deliveringState.isLoading && mapEntities.isEmpty;
    final displayData = isInitialLoading ? skeletonData : mapEntities;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: StylesConstants.spacerContent),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 60,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: FloatingSearchBar(
              controller: searchDelivering,
              onSortTap: () {},
            ),
          ),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: () async {
                await _getDelivering();
              },
              child:
                  (displayData.isEmpty && !deliveringState.isLoading)
                      ? _buildEmptyState()
                      : Skeletonizer(
                        effect: LoadingEffect.getCommonEffect(context),
                        enabled:
                            deliveringState.isLoading && mapEntities.isEmpty,
                        ignoreContainers: true,
                        justifyMultiLineText: true,
                        child: ListView.builder(
                          controller:
                              isInitialLoading ? null : _scrollController,
                          shrinkWrap: false,
                          itemCount:
                              displayData.length +
                              (deliveringState.isLoading &&
                                      mapEntities.isNotEmpty
                                  ? 1
                                  : 0),
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index == displayData.length - 1 && isFetching) {
                              return Skeletonizer(
                                enabled: true,
                                effect: LoadingEffect.getCommonEffect(context),
                                child: MinimalDeliverieView(
                                  isLoading: mapState.isLoading,
                                  delivery: displayData[0],
                                  onTap: () {},
                                ),
                              );
                            }

                            final delivery = displayData[index];
                            return MinimalDeliverieView(
                              delivery: delivery,
                              isLoading: mapState.isLoading,
                              onTap: () {
                                final mapState = _mapKey.currentState;
                                mapState?.navigateToDelivery(delivery);
                              },
                            );
                          },
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining, size: 60.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            const Text("Aucune livraison trouver"),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    final deliveringState = ref.watch(deliveringControllerProvider);
    final actualDeliverings = deliveringState.deliverings ?? [];
    final mapEntities = actualDeliverings.map((d) => d.toMapEntity()).toList();
    return DeliveryMapWidget(
      key: _mapKey,
      config: DeliveryMapConfig(
        center: Position(47.5, -19.0),
        zoom: 13.0,
        styleUri: 'mapbox://styles/rahkoja/cmlhvlh1e002l01r88yao1l2s',
        deliveries: mapEntities,
        pitch: 50,
        perimeterRadius: 2000.0,
        onMapCreated: () {},
        onDeliveryTap: (delivery) {
          print('Livraison sélectionnée: ${delivery.location}');
        },
      ),
    );
  }
}
