import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:equatable/equatable.dart';

class DeliveringEntity extends Equatable {
  final String? id;
  final String? orderId;
  final List<MapData>? orderProductDetails;
  final DateTime? dateOfDelivering;
  final DateTime? createdAt;
  final MapData? userDetails;
  final List<MapData>? deliveringState;
  final MapData? deliveringServiceDetails;
  final double? deliveringPrice;
  final String? description;
  final String? status;
  final String? deliveringAdresse;

  DeliveringEntity({
    this.id,
    this.createdAt,
    this.dateOfDelivering,
    this.deliveringPrice,
    this.deliveringServiceDetails,
    this.deliveringState,
    this.description,
    this.orderId,
    this.orderProductDetails,
    this.userDetails,
    this.status,
    this.deliveringAdresse,
  });

  DeliveringEntity copyWith({
    String? id,
    String? orderId,
    List<MapData>? orderProductDetails,
    DateTime? dateOfDelivering,
    DateTime? createdAt,
    MapData? userDetails,
    List<MapData>? deliveringState,
    MapData? deliveringServiceDetails,
    double? deliveringPrice,
    String? description,
    String? status,
    String? deliveringAdresse,
  }) {
    return DeliveringEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderProductDetails: orderProductDetails ?? this.orderProductDetails,
      dateOfDelivering: dateOfDelivering ?? this.dateOfDelivering,
      createdAt: createdAt ?? this.createdAt,
      userDetails: userDetails ?? this.userDetails,
      deliveringState: deliveringState ?? this.deliveringState,
      deliveringServiceDetails:
          deliveringServiceDetails ?? this.deliveringServiceDetails,
      deliveringPrice: deliveringPrice ?? this.deliveringPrice,
      description: description ?? this.description,
      status: status ?? this.status,
      deliveringAdresse: deliveringAdresse ?? this.deliveringAdresse,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    orderProductDetails,
    dateOfDelivering,
    createdAt,
    userDetails,
    deliveringServiceDetails,
    deliveringPrice,
    description,
    status,
    deliveringAdresse,
  ];
}
