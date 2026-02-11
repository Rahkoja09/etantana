import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';
import 'package:e_tantana/features/map/domain/repository/map_repository.dart';

class MapUsecases {
  final MapRepository _mapRepository;
  MapUsecases(this._mapRepository);

  ResultFuture<MapEntity?> getCoordinatesFromAddress(String address) async {
    return await _mapRepository.getCoordinatesFromAddress(address);
  }
}
