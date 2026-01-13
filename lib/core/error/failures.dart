import 'package:e_tantana/core/error/exceptions.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromException(ServerException exception) {
    return ServerFailure(exception.message);
  }
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);

  factory AuthFailure.fromException(AuthUserException exception) {
    return AuthFailure(exception.message);
  }
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(exception.message);
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);

  factory NetworkFailure.fromException(NetworkException exception) {
    return NetworkFailure(exception.message);
  }
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class ApiFailure extends Failure {
  const ApiFailure(super.message);

  factory ApiFailure.fromException(ApiException exception) {
    return ApiFailure(exception.message);
  }
}

class UnexceptedFailure extends Failure {
  const UnexceptedFailure(super.message);

  factory UnexceptedFailure.fromException(UnexceptedException exception) {
    return UnexceptedFailure(exception.message);
  }
}
