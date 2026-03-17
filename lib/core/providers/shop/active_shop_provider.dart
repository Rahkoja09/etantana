import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeShopIdProvider = StateProvider<({String? id, bool isSwitching})>(
  (ref) => (id: null, isSwitching: false),
);
