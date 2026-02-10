import 'package:e_tantana/core/error/failures.dart';

class SuccesErrorManager {
  static String getFriendlySuccessMessage(dynamic action) {
    final actionStr = action.toString().toLowerCase();

    if (actionStr.contains('insert')) return "Element ajouté avec succès !";
    if (actionStr.contains('delete')) return "Element supprimé avec succès.";
    if (actionStr.contains('search') || actionStr.contains('get'))
      return "Element récuperer avec succès";
    if (actionStr.contains('update'))
      return "Modification(s) de l'element enregistrée.";

    return "Tout est ok";
  }

  static String getFriendlyErrorMessage(Failure failure, dynamic action) {
    if (failure is NetworkFailure || failure.code == 'Network_01') {
      return "Problème de connexion. Vérifiez votre accès internet avant de réessayer.";
    }

    if (failure is ServerFailure || (failure.code.startsWith('5'))) {
      return "Le serveur de l'application rencontre un problème temporaire. Veuillez réessayer dans quelques instants.";
    }

    switch (failure.code) {
      case '23505':
        return "Cet élément existe déjà dans la base de données.";
      case '23503':
        return "Action impossible : cet élément est lié à d'autres données.";
      case 'PGRST116':
        return "Désolé, cet élément n'a pas été trouvé ou a été supprimé.";
      case '42P01':
        return "Erreur de configuration serveur.";
      case 'Cache_01':
        return "Erreur de cache, réessayer plus tard";
      case 'Auth_01':
        return "Erreur d'authentification, la tâche ne peut être accompli sans.";
    }

    final actionStr = action.toString().toLowerCase();

    if (actionStr.contains('get') ||
        actionStr.contains('search') ||
        actionStr.contains('load')) {
      return "Erreur lors de la récupération des données : ${failure.message}";
    }

    if (actionStr.contains('insert') || actionStr.contains('add')) {
      return "Impossible d'enregistrer ces informations : ${failure.message}";
    }

    if (actionStr.contains('delete')) {
      return "La suppression a échoué : ${failure.message}";
    }

    if (actionStr.contains('update') || actionStr.contains('edit')) {
      return "La modification n'a pas pu être enregistrée : ${failure.message}";
    }

    return failure.message.isNotEmpty
        ? failure.message
        : "Oops, une erreur inattendue est survenue. Veuillez réessayer plus tard.";
  }
}
