import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/user/domain/entity/user_entity.dart';

abstract class UserRepository {
  /// Insère un nouveau User
  ResultFuture<UserEntity> insertUser(UserEntity entity);

  /// Met à jour un User existant
  ResultFuture<UserEntity> updateUser(UserEntity entity);

  /// Recherche des Users selon des critères avec pagination
  ResultFuture<List<UserEntity>> searchUser({
    UserEntity? criteria,
    int start = 0,
    int end = 9,
  });

  /// Récupère un User spécifique par son ID
  ResultFuture<UserEntity> getUserById(String id);

  /// Supprime un User définitivement
  ResultVoid deleteUserById(String id);
}
