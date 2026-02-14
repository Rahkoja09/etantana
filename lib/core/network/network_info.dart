import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get hasConnection;
  Stream<InternetStatus> get onStatusChanged;
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection connectionChecker;
  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get hasConnection async {
    return await connectionChecker.hasInternetAccess;
  }

  @override
  Future<bool> get isConnected async {
    final stopwatch = Stopwatch()..start();
    try {
      final hasAccess = await connectionChecker.hasInternetAccess;
      stopwatch.stop();

      return hasAccess && stopwatch.elapsedMilliseconds < 1500;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<InternetStatus> get onStatusChanged {
    return connectionChecker.onStatusChange;
  }
}
