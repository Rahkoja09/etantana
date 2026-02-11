import 'package:e_tantana/core/di/injection_container.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/map/domain/usecases/map_usecases.dart';
import 'package:e_tantana/features/map/presentation/states/map_states.dart';
import 'package:riverpod/riverpod.dart';

class MapController extends StateNotifier<MapStates> {
  final MapUsecases _mapUsecases;
  MapController(this._mapUsecases) : super(MapStates());

  Future<void> getCoordinatesFromAddress(String address) async {
    final action = mapAction.searchGeolocation;
    _setLoadingState(action: action);
    final res = await _mapUsecases.getCoordinatesFromAddress(address);
    res.fold(
      (error) {
        _setError(action: action, error: error);
      },
      (succes) {
        state = state.copyWith(
          isLoading: false,
          isClearError: true,
          failure: null,
          locations: succes,
        );
      },
    );
  }

  // set loading state ----------
  void _setLoadingState({required mapAction action}) {
    state = state.copyWith(isLoading: true, action: action);
  }

  void _setError({required Failure error, required mapAction action}) {
    state = state.copyWith(
      isLoading: false,
      isClearError: false,
      failure: error,
      action: action,
      errorCode: error.code,
    );
  }
}

final mapControllerProvider = StateNotifierProvider<MapController, MapStates>((
  _,
) {
  return MapController(sl<MapUsecases>());
});
