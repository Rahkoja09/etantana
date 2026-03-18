import 'package:e_tantana/features/shop/domain/entity/shop_entity.dart';
import 'package:e_tantana/features/shop/presentation/controller/shop_controller.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';
import 'package:e_tantana/features/user/presentation/controller/user_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionState extends Equatable {
  final UserEntity? user;
  final ShopEntity? activeShop;
  final bool isInitializing;
  final bool isSwitching;

  const SessionState({
    this.user,
    this.activeShop,
    this.isInitializing = true,
    this.isSwitching = false,
  });

  SessionState copyWith({
    UserEntity? user,
    ShopEntity? activeShop,
    bool? isInitializing,
    bool? isSwitching,
  }) {
    return SessionState(
      user: user ?? this.user,
      activeShop: activeShop ?? this.activeShop,
      isInitializing: isInitializing ?? this.isInitializing,
      isSwitching: isSwitching ?? this.isSwitching,
    );
  }

  String? get activeShopId => activeShop?.id;
  bool get hasShop => activeShop != null;
  bool get hasUser => user != null;
  bool get isPremium => user?.userPlan?.toLowerCase() == 'premium';

  @override
  List<Object?> get props => [user, activeShop, isInitializing, isSwitching];
}

class SessionController extends StateNotifier<SessionState> {
  final Ref ref;

  SessionController(this.ref) : super(const SessionState());

  Future<void> init() async => await _init();

  Future<void> refresh() async {
    await _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isInitializing: true);
    try {
      await ref.read(userControllerProvider.notifier).searchUser(null);
      final users = ref.read(userControllerProvider).users;
      print("opalala, user est là : ${users?[0]}");
      final user = (users != null && users.isNotEmpty) ? users[0] : null;

      await ref.read(shopControllerProvider.notifier).searchShop(null);
      final List<ShopEntity> shops =
          ref.read(shopControllerProvider).shops ?? [];
      print("opalala, shop est là aussi : ${shops[0]}");
      final savedShopId = user?.selectedShop;
      ShopEntity? activeShop;

      if (shops.isNotEmpty) {
        if (savedShopId != null && savedShopId.isNotEmpty) {
          activeShop = shops.cast<ShopEntity>().firstWhere(
            (s) => s.id == savedShopId,
            orElse: () => shops.first,
          );
        } else {
          activeShop = shops.first;
        }
      }

      state = state.copyWith(user: user, activeShop: activeShop);
    } catch (e) {
      debugPrint("SessionController _init error: $e");
    } finally {
      state = state.copyWith(isInitializing: false);
    }
  }

  Future<void> switchShop(ShopEntity shop) async {
    if (shop.id == state.activeShop?.id) return;

    state = state.copyWith(isSwitching: true, activeShop: shop);
    await Future.wait([
      ref.read(shopControllerProvider.notifier).searchShop(null),
    ]);

    state = state.copyWith(isSwitching: false);
  }

  void updateUser(UserEntity updatedUser) {
    state = state.copyWith(user: updatedUser);
  }

  void updateActiveShop(ShopEntity updatedShop) {
    if (state.activeShop?.id == updatedShop.id) {
      state = state.copyWith(activeShop: updatedShop);
    }
  }

  void reset() {
    state = const SessionState(isInitializing: false);
  }
}

final sessionProvider = StateNotifierProvider<SessionController, SessionState>((
  ref,
) {
  return SessionController(ref);
});
