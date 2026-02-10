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
