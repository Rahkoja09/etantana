import 'package:e_tantana/features/map/domain/entity/map_entity.dart';

class CountDelivery {
  static int countDeliveryWithStatus(
    List<MapEntity> deliveries,
    String status,
  ) {
    int count = 0;
    for (int i = 0; i < deliveries.length; i++) {
      if (deliveries[i].status.name == status) {
        count++;
      }
    }
    return count;
  }
}
