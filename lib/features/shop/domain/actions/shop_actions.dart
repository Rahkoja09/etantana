import 'package:e_tantana/core/actions/app_action.dart';

/// Base action class for Shop feature using Sealed Class for Type Safety
sealed class ShopActions implements AppAction {}

/// Action to Create a new Shop
class CreateShopAction extends ShopActions {
  final String identifier;
  CreateShopAction(this.identifier);

  @override
  String get errorMessage => "Impossible d'enregistrer : $identifier";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Enregistrement de $identifier réussi";
}

/// Action to Update an existing Shop
class UpdateShopAction extends ShopActions {
  final String id;
  UpdateShopAction(this.id);

  @override
  String get errorMessage => "Échec de la modification de #$id";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Mise à jour de #$id effectuée";
}

/// Action to Delete a Shop
class DeleteShopAction extends ShopActions {
  final String id;
  DeleteShopAction(this.id);

  @override
  String get errorMessage => "Impossible de supprimer #$id";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Suppression de #$id confirmée";
}

/// Action to fetch the list of Shop
class GetShopAction extends ShopActions {
  @override
  String get errorMessage => "Erreur lors du chargement de la liste";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Liste récupérée avec succès";
}

/// Action to search within Shop
class SearchShopAction extends ShopActions {
  final String query;
  SearchShopAction(this.query);

  @override
  String get errorMessage => "Aucun résultat pour '$query'";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Résultats pour '$query' trouvés";
}