// core/services/storage_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError();
});

class StorageService {
  final SharedPreferences _prefs;
  StorageService(this._prefs);

  static const String _onboardingKey = 'has_seen_onboarding';
  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  bool hasSeenOnboarding() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }
}
