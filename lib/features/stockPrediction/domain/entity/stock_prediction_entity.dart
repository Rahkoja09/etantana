import 'package:equatable/equatable.dart';

class StockPredictionEntity extends Equatable {
  final String productId;
  final double salesPerWeek;
  final int currentStock;
  final int daysRemaining;
  final double stockPressure;

  StockPredictionEntity({
    required this.productId,
    required this.salesPerWeek,
    required this.currentStock,
    required this.daysRemaining,
    required this.stockPressure,
  });

  StockPredictionEntity copyWith({
    String? productId,
    double? salesPerWeek,
    int? currentStock,
    int? daysRemaining,
    double? stockPressure,
  }) {
    return StockPredictionEntity(
      productId: productId ?? this.productId,
      salesPerWeek: salesPerWeek ?? this.salesPerWeek,
      currentStock: currentStock ?? this.currentStock,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      stockPressure: stockPressure ?? this.stockPressure,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    salesPerWeek,
    currentStock,
    daysRemaining,
    stockPressure,
  ];
}
