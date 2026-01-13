import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = Future<Either<Failure, void>>;
typedef MapData = Map<String, dynamic>;
