import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';
import 'package:equatable/equatable.dart';

class MapEntity extends Equatable {
  final String id;
  final String location;
  final double? latitude;
  final double? longitude;
  final String status;
  final DateTime date;
  final double price;

  MapEntity({
    required this.id,
    required this.location,
    this.latitude,
    this.longitude,
    required this.status,
    required this.date,
    required this.price,
  });

  MapEntity copyWith({
    String? id,
    String? location,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? date,
    double? price,
  }) {
    return MapEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      location: location ?? this.location,
      price: price ?? this.price,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory MapEntity.fromDeliveringEntity(DeliveringEntity delivering) {
    return MapEntity(
      id: delivering.id!,
      location: delivering.deliveringAdresse!,
      status: delivering.status!,
      date: delivering.dateOfDelivering!,
      price: delivering.deliveringPrice!,
    );
  }

  @override
  List<Object?> get props => [
    id,
    date,
    location,
    price,
    status,
    latitude,
    longitude,
  ];
}
