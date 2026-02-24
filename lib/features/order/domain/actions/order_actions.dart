import 'package:e_tantana/core/actions/app_action.dart';

sealed class OrderActions implements AppAction {}

class CreateOrderAction extends OrderActions {
  final String orderReference;
  CreateOrderAction(this.orderReference);

  @override
  String get errorMessage =>
      "Impossible d'enregistrer la commande $orderReference";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage =>
      "Commande $orderReference enregistrée avec succès";
}

class UpdateOrderAction extends OrderActions {
  final String orderId;
  UpdateOrderAction(this.orderId);

  @override
  String get errorMessage => "Impossible de modifier la commande #$orderId";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Commande #$orderId mise à jour avec succès";
}

class DeleteOrderAction extends OrderActions {
  final String orderId;
  DeleteOrderAction(this.orderId);

  @override
  String get errorMessage => "Impossible de supprimer la commande #$orderId";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Commande #$orderId supprimée définitivement";
}

class ValidateOrderAction extends OrderActions {
  final String orderId;
  ValidateOrderAction(this.orderId);

  @override
  String get errorMessage => "Échec de la validation de la commande #$orderId";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Commande #$orderId validée avec succès";
}

class GetOrdersAction extends OrderActions {
  @override
  String get errorMessage => "Impossible de charger les commandes";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Liste des commandes récupérée";
}

class SearchOrderAction extends OrderActions {
  final String query;
  SearchOrderAction(this.query);

  @override
  String get errorMessage => "Erreur lors de la recherche pour '$query'";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Résultats trouvés pour '$query'";
}

class GenerateInvoiceAction extends OrderActions {
  final String orderId;
  GenerateInvoiceAction(this.orderId);

  @override
  String get errorMessage =>
      "Erreur lors de la génération de la facture (#$orderId)";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Facture générée avec succès";
}
