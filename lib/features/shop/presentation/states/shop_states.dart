import 'package:equatable/equatable.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:e_tantana/features/shop/domain/actions/shop_actions.dart';

class ShopStates extends Equatable {
  final bool isLoading;
  final Failure? error;
  final List<ShopEntity>? shops;
  final ShopEntity? currentCriteria;
  final ShopActions? action;
  final String? errorCode;
  final ShopEntity? selectedShop;

  const ShopStates({
    this.isLoading = false,
    this.error,
    this.shops,
    this.currentCriteria,
    this.action,
    this.errorCode,
    this.selectedShop,
  });

  ShopStates copyWith({
    bool? isLoading,
    List<ShopEntity>? shops,
    ShopEntity? currentCriteria,
    ShopActions? action,
    String? errorCode,
    Failure? error,
    bool isClearError = false,
    ShopEntity? selectedShop,
  }) {
    return ShopStates(
      isLoading: isLoading ?? this.isLoading,
      error: isClearError == true ? null : (error ?? this.error),
      shops: shops ?? this.shops,
      currentCriteria: currentCriteria ?? this.currentCriteria,
      action: action ?? this.action,
      errorCode: errorCode ?? this.errorCode,
      selectedShop: selectedShop ?? this.selectedShop,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    shops,
    currentCriteria,
    action,
    errorCode,
    selectedShop,
  ];
}
