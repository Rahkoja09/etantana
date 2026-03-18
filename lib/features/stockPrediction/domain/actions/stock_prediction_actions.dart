import 'package:e_tantana/core/app/actions/app_action.dart';

sealed class StockPredictionActions extends AppAction {}

class getStockPredictionAction extends StockPredictionActions {
  @override
  String get errorMessage => "Erreur de récuperation des données de prediction";
  @override
  bool get isWriteAction => false;
  @override
  String get successMessage => "Prédiction de stock récupérer";
}
