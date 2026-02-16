import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';

double calculateTotal(List<ProductEntities> products, List<MapData> orderList) {
  double total = 0;
  for (var item in orderList) {
    final String currentId = item["id"];
    final int quantity = item["quantity"];
    for (var product in products) {
      if (product.id == currentId) {
        if (!products.contains(product)) {
          products.add(product);
        }
        final price = (product.sellingPrice ?? 0).toDouble();
        total += price * quantity;
        break;
      }
    }
  }

  return total;
}

Map<String, dynamic> calculateTotalIncomeAndPercentage({
  required List<Map<String, dynamic>> products,
  int margin = 0, // Marge sur le prix d'ACHAT
  double? userDefinedPrice, // Prix manuel pour UN pack
}) {
  double unitPurchaseCost = 0.0;
  double unitSellingPriceNormal = 0.0;
  int maxPacksPossible = 999999;

  // 1. Calcul des bases et du maillon faible du stock
  for (var product in products) {
    final int stock = (product['quantity'] ?? 0) as int;
    if (stock < maxPacksPossible) maxPacksPossible = stock;

    unitPurchaseCost += (product['purchase_price'] ?? 0).toDouble();
    unitSellingPriceNormal += (product['selling_price'] ?? 0).toDouble();
  }

  if (products.isEmpty) maxPacksPossible = 0;

  // 2. Déterminer le PRIX UNITAIRE FINAL du pack
  // La marge s'applique sur le Coût d'Achat (unitPurchaseCost)
  double priceBasedOnMargin = unitPurchaseCost * (1 + (margin / 100));

  // Si l'utilisateur a entré un prix, il est prioritaire.
  // Sinon, on utilise le prix calculé avec la marge sur achat.
  double finalUnitPricePack = userDefinedPrice ?? priceBasedOnMargin;

  // 3. RENTABILITÉ (Basée sur l'achat)
  double profitPercentNormal =
      unitPurchaseCost > 0
          ? ((unitSellingPriceNormal - unitPurchaseCost) / unitPurchaseCost) *
              100
          : 0.0;

  double profitPercentPack =
      unitPurchaseCost > 0
          ? ((finalUnitPricePack - unitPurchaseCost) / unitPurchaseCost) * 100
          : 0.0;

  // 4. ANALYSE GLOBALE
  double totalIncomeAvecPack = finalUnitPricePack * maxPacksPossible;
  double totalIncomeSansPack = unitSellingPriceNormal * maxPacksPossible;

  return {
    "unit_price_pack": finalUnitPricePack,
    "unit_purchase_cost": unitPurchaseCost,
    "max_packs_completable": maxPacksPossible,
    "income_sans_pack": totalIncomeSansPack,
    "income_avec_pack": totalIncomeAvecPack,
    "percent_profit_sans_pack": profitPercentNormal.toStringAsFixed(2),
    "percent_profit_avec_pack": profitPercentPack.toStringAsFixed(2),
    "is_loss": finalUnitPricePack < unitPurchaseCost,
  };
}
