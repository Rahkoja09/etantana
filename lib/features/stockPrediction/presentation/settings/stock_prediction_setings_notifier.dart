import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stock_prediction_settings.dart';

// import 'package:e_tantana/core/services/storage_service.dart';

const _kSettingsKey = 'stock_prediction_settings';

class StockPredictionSettingsNotifier
    extends StateNotifier<StockPredictionSettings> {
  StockPredictionSettingsNotifier() : super(const StockPredictionSettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSettingsKey);
    if (raw != null) {
      try {
        state = StockPredictionSettings.fromMap(jsonDecode(raw));
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSettingsKey, jsonEncode(state.toMap()));
  }

  Future<void> setWindow(StockPredictionWindow window) async {
    state = state.copyWith(window: window);
    await _save();
  }

  Future<void> setPreviewCount(int count) async {
    state = state.copyWith(previewCount: count.clamp(1, 10));
    await _save();
  }
}

final stockPredictionSettingsProvider = StateNotifierProvider<
  StockPredictionSettingsNotifier,
  StockPredictionSettings
>((ref) => StockPredictionSettingsNotifier());
