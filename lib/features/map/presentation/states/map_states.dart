import 'package:equatable/equatable.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';

enum mapAction { searchGeolocation }

class MapStates extends Equatable {
  final bool isLoading;
  final MapEntity? locations;
  final mapAction? action;
  final String? errorCode;
  final String? currentCriterial;
  final Failure? failure;

  MapStates({
    this.isLoading = false,
    this.locations,
    this.action,
    this.currentCriterial,
    this.errorCode,
    this.failure,
  });

  MapStates copyWith({
    bool? isLoading,
    MapEntity? locations,
    mapAction? action,
    String? errorCode,
    String? currentCriterial,
    Failure? failure,
    bool? isClearError = false,
  }) {
    return MapStates(
      action: action ?? this.action,
      currentCriterial: currentCriterial ?? this.currentCriterial,
      errorCode: errorCode ?? this.errorCode,
      failure: isClearError == true ? null : (failure ?? this.failure),
      isLoading: isLoading ?? this.isLoading,
      locations: locations ?? this.locations,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    locations,
    action,
    errorCode,
    currentCriterial,
    failure,
  ];
}
