import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';
import 'package:e_tantana/features/user/domain/repository/user_repository.dart';

class UserUsecases {
  final UserRepository _repo;

  UserUsecases(this._repo);

  /// Exécute l'insertion d'un nouveau User
  ResultFuture<UserEntity> insertUser(UserEntity entity) async {
    return await _repo.insertUser(entity);
  }

  /// Exécute la mise à jour d'un User
  ResultFuture<UserEntity> updateUser(UserEntity entity) async {
    return await _repo.updateUser(entity);
  }

  /// Exécute la suppression d'un User par son identifiant
  ResultVoid deleteUserById(String id) async {
    return await _repo.deleteUserById(id);
  }

  /// Récupère un User spécifique
  ResultFuture<UserEntity> getUserById(String id) async {
    return await _repo.getUserById(id);
  }

  /// Effectue une recherche de User avec pagination
  ResultFuture<List<UserEntity>> searchUser({
    UserEntity? criteria,
    int start = 0,
    int end = 9,
  }) async {
    return await _repo.searchUser(
      criteria: criteria,
      start: start,
      end: end,
    );
  }
}