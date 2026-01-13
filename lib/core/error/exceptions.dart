class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});
}

class ApiException implements Exception {
  final String message;
  ApiException({required this.message});
}

class AuthUserException implements Exception {
  final String message;
  AuthUserException({required this.message});
}

class UnexceptedException implements Exception {
  final String message;
  UnexceptedException({required this.message});
}
