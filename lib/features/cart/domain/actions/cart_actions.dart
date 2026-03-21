import 'package:e_tantana/core/actions/app_action.dart';

/// Base action class for Cart feature using Sealed Class for Type Safety
sealed class CartActions implements AppAction {}

/// Action to Create a new Cart
class CreateCartAction extends CartActions {
  final String identifier;
  CreateCartAction(this.identifier);

  @override
  String get errorMessage => "Impossible d'enregistrer : $identifier";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Enregistrement de $identifier réussi";
}

/// Action to Update an existing Cart
class UpdateCartAction extends CartActions {
  final String id;
  UpdateCartAction(this.id);

  @override
  String get errorMessage => "Échec de la modification de #$id";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Mise à jour de #$id effectuée";
}

/// Action to Delete a Cart
class DeleteCartAction extends CartActions {
  final String id;
  DeleteCartAction(this.id);

  @override
  String get errorMessage => "Impossible de supprimer #$id";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Suppression de #$id confirmée";
}

/// Action to fetch the list of Cart
class GetCartAction extends CartActions {
  @override
  String get errorMessage => "Erreur lors du chargement de la liste";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Liste récupérée avec succès";
}

/// Action to search within Cart
class SearchCartAction extends CartActions {
  final String query;
  SearchCartAction(this.query);

  @override
  String get errorMessage => "Aucun résultat pour '$query'";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Résultats pour '$query' trouvés";
}