class Timer {
  static Future<void> setLimitedTime({int durationInSecode = 3}) async {
    await Future.delayed(Duration(seconds: durationInSecode));
  }
}
