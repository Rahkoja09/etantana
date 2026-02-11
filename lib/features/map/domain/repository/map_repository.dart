import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';

abstract class MapRepository {
  ResultFuture<MapEntity?> getCoordinatesFromAddress(String address);
}
