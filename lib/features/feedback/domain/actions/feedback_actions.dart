import 'package:e_tantana/core/actions/app_action.dart';

/// Base action class for Feedback feature using Sealed Class for Type Safety
sealed class FeedbackActions implements AppAction {}

/// Action to Create a new Feedback
class CreateFeedbackAction extends FeedbackActions {
  final String identifier;
  CreateFeedbackAction(this.identifier);

  @override
  String get errorMessage => "Impossible d'envoyer : $identifier";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Enregistrement de $identifier réussi";
}

/// Action to Update an existing Feedback
class UpdateFeedbackAction extends FeedbackActions {
  final String id;
  UpdateFeedbackAction(this.id);

  @override
  String get errorMessage => "Échec de la modification de #$id";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Mise à jour de #$id effectuée";
}

/// Action to Delete a Feedback
class DeleteFeedbackAction extends FeedbackActions {
  final String id;
  DeleteFeedbackAction(this.id);

  @override
  String get errorMessage => "Impossible de supprimer #$id";

  @override
  bool get isWriteAction => true;

  @override
  String get successMessage => "Suppression de #$id confirmée";
}

/// Action to fetch the list of Feedback
class GetFeedbackAction extends FeedbackActions {
  @override
  String get errorMessage => "Erreur lors du chargement de la liste";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Liste récupérée avec succès";
}

/// Action to search within Feedback
class SearchFeedbackAction extends FeedbackActions {
  final String query;
  SearchFeedbackAction(this.query);

  @override
  String get errorMessage => "Aucun résultat pour '$query'";

  @override
  bool get isWriteAction => false;

  @override
  String get successMessage => "Résultats pour '$query' trouvés";
}
