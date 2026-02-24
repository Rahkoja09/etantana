import 'package:e_tantana/core/actions/app_action.dart';

sealed class ProductActions implements AppAction {}

class InsertProductAction extends ProductActions {
  final String productName;
  InsertProductAction(this.productName);

  @override
  String get errorMessage => "Impossible d'ajouter le produit $productName";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "$productName ajouté avec succès";
}

class UpdatedProductAction extends ProductActions {
  final String productName;
  UpdatedProductAction(this.productName);

  @override
  String get errorMessage => "Impossible de modifier le produit $productName";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "$productName modifier avec succès";
}

class deleteProductAction extends ProductActions {
  final String productName;
  deleteProductAction(this.productName);

  @override
  String get errorMessage => "Impossible de supprimer le produit $productName";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "$productName supprimer avec succès";
}

class cancelAndRestoreProductAction extends ProductActions {
  final String clientName;
  cancelAndRestoreProductAction(this.clientName);

  @override
  String get errorMessage =>
      "Impossible d'annuler la commande de M/Me $clientName";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage =>
      "Commande de M/Me $clientName annulé avec succès";
}

class getProductAction extends ProductActions {
  final String productId;
  getProductAction(this.productId);

  @override
  String get errorMessage => "Impossible de recuperer le produit $productId";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "$productId recuperer avec succès";
}

class searchProductAction extends ProductActions {
  final String productName;
  searchProductAction(this.productName);

  @override
  String get errorMessage => "Impossible de rechercher le produit $productName";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage =>
      "Les produits portant le nom $productName sont recuperées avec succès";
}
