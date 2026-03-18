import 'package:e_tantana/core/app/actions/app_action.dart';

/// Base action class for User feature using Sealed Class for Type Safety
sealed class UserActions implements AppAction {}

/// Action to Create a new User
class CreateUserAction extends UserActions {
  final String identifier;
  CreateUserAction(this.identifier);

  @override
  String get errorMessage => "Impossible d'enregistrer : $identifier";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Enregistrement de $identifier réussi";
}

/// Action to Update an existing User
class UpdateUserAction extends UserActions {
  final String id;
  UpdateUserAction(this.id);

  @override
  String get errorMessage => "Échec de la modification de #$id";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Mise à jour de #$id effectuée";
}

/// switch shop account ------
class SwitchShopUserAction extends UserActions {
  final String shopName;
  SwitchShopUserAction(this.shopName);

  @override
  String get errorMessage => "Échec du chargement vers #$shopName";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage =>
      "Changement de boutique effectuée: actullemment dans #$shopName";
}

/// Action to Delete a User
class DeleteUserAction extends UserActions {
  final String id;
  DeleteUserAction(this.id);

  @override
  String get errorMessage => "Impossible de supprimer #$id";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Suppression de #$id confirmée";
}

/// Action to fetch the list of User
class GetUserAction extends UserActions {
  @override
  String get errorMessage => "Erreur lors du chargement de la liste";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Liste récupérée avec succès";
}

/// Action to search within User
class SearchUserAction extends UserActions {
  final String query;
  SearchUserAction(this.query);

  @override
  String get errorMessage => "Aucun résultat pour '$query'";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Résultats pour '$query' trouvés";
}
