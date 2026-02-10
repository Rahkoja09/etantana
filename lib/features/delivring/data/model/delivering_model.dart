import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/delivring/domain/entity/delivering_entity.dart';

class DeliveringModel extends DeliveringEntity {
  DeliveringModel({
    super.id,
    super.createdAt,
    super.dateOfDelivering,
    super.deliveringPrice,
    super.deliveringServiceDetails,
    super.deliveringState,
    super.description,
    super.orderId,
    super.orderProductDetails,
    super.status,
    super.userDetails,
    super.deliveringAdresse,
  });

  factory DeliveringModel.fromMap(MapData data) {
    return DeliveringModel(
      id: data['id'] as String?,
      orderId: data['order_id'] as String?,
      orderProductDetails:
          (data['order_product_details'] as List?)
              ?.map((e) => e as MapData)
              .toList(),
      dateOfDelivering:
          data['date_of_delivering'] != null
              ? DateTime.parse(data['date_of_delivering'])
              : null,
      createdAt:
          data['created_at'] != null
              ? DateTime.parse(data['created_at'])
              : null,
      userDetails: data['user_details'] as MapData?,
      deliveringState:
          (data['delivering_state'] as List?)
              ?.map((e) => e as MapData)
              .toList(),
      deliveringServiceDetails: data['delivering_service_details'] as MapData?,
      deliveringPrice: (data['delivering_price'] as num?)?.toDouble(),
      description: data['description'] as String?,
      status: data['status'] as String?,
      deliveringAdresse: data['delivering_adresse'] as String,
    );
  }

  MapData toMap() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'order_product_details': orderProductDetails,
      'date_of_delivering': dateOfDelivering?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'user_details': userDetails,
      'delivering_state': deliveringState,
      'delivering_service_details': deliveringServiceDetails,
      'delivering_price': deliveringPrice,
      'description': description,
      'status': status,
      'delivering_adresse': deliveringAdresse,
    };
  }

  factory DeliveringModel.fromEntity(DeliveringEntity entity) {
    return DeliveringModel(
      id: entity.id,
      orderId: entity.orderId,
      orderProductDetails: entity.orderProductDetails,
      dateOfDelivering: entity.dateOfDelivering,
      createdAt: entity.createdAt,
      userDetails: entity.userDetails,
      deliveringState: entity.deliveringState,
      deliveringServiceDetails: entity.deliveringServiceDetails,
      deliveringPrice: entity.deliveringPrice,
      description: entity.description,
      status: entity.status,
      deliveringAdresse: entity.deliveringAdresse,
    );
  }
}
