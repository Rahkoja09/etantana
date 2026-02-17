import 'package:dartz/dartz.dart';
import 'package:e_tantana/core/error/failures.dart';
import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/delivring/domain/mapper/order_to_delivering_mapper.dart';
import 'package:e_tantana/features/delivring/domain/repository/delivering_repository.dart';
import 'package:e_tantana/features/order/domain/entities/order_entities.dart';
import 'package:e_tantana/features/order/domain/repository/order_repository.dart';
import 'package:e_tantana/features/product/domain/entities/product_entities.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';

class OrderUsecases {
  final OrderRepository _orderRepository;
  final DeliveringRepository _deliveringRepository;
  final ProductRepository _productRepository;
  OrderUsecases(
    this._orderRepository,
    this._deliveringRepository,
    this._productRepository,
  );

  ResultFuture<OrderEntities> getOrderById(String orderId) =>
      _orderRepository.getOrderById(orderId);

  // xxxxx piramide de la mort, à refaire avec un rpc postgress xxxx --------------
  ResultFuture<OrderEntities> processOrderFlow(OrderEntities entity) async {
    try {
      final orderRes = await _orderRepository.insertOrder(entity);

      return await orderRes.fold((failure) async => Left(failure), (
        order,
      ) async {
        final deliveringData = order.toDelivering();
        final deliveryRes = await _deliveringRepository.insertDelivering(
          deliveringData,
        );

        return await deliveryRes.fold((failure) async => Left(failure), (
          delivering,
        ) async {
          for (var item in entity.productsAndQuantities!) {
            final String productId = item["id"];
            final int qtyOrdered =
                int.tryParse(item["quantity"].toString()) ?? 0;

            final productRes = await _productRepository.getProductById(
              productId,
            );

            await productRes.fold((error) async => Left(error), (
              product,
            ) async {
              await _updateStock(product, qtyOrdered);

              if (product.isPack == true && product.packComposition != null) {
                final List<dynamic> components =
                    product.packComposition as List<dynamic>;

                for (var component in components) {
                  final String compId = component["id"];

                  const int qtyRequiredPerPack = 1;
                  final int totalToSubtractFromComponent =
                      qtyRequiredPerPack * qtyOrdered;

                  final compRes = await _productRepository.getProductById(
                    compId,
                  );

                  await compRes.fold((error) => null, (compProduct) async {
                    await _updateStock(
                      compProduct,
                      totalToSubtractFromComponent,
                    );
                  });
                }
              }
            });
          }
          return Right(order);
        });
      });
    } catch (e) {
      return Left(UnexceptedFailure(e.toString(), "500"));
    }
  }

  Future<void> _updateStock(
    ProductEntities product,
    int quantityToSubtract,
  ) async {
    final newQuantity = (product.quantity ?? 0) - quantityToSubtract;
    final update = product.copyWith(quantity: newQuantity);
    await _productRepository.updateProduct(update);
  }

  ResultVoid deleteOrderById(String orderId) async {
    try {
      final deliveringRes = await _deliveringRepository.deleteDeliveringById(
        orderId,
      );

      return await deliveringRes.fold((failure) async => Left(failure), (
        _,
      ) async {
        final orderRes = await _orderRepository.deleteOrderById(orderId);

        return orderRes.fold((failure) => Left(failure), (_) => Right(null));
      });
    } catch (e) {
      return Left(UnexceptedFailure(e.toString(), "500"));
    }
  }

  ResultFuture<OrderEntities> updateOrderFlow(OrderEntities entity) async {
    try {
      final orderRes = await _orderRepository.updateOrder(entity);

      return await orderRes.fold((failure) async => Left(failure), (
        order,
      ) async {
        final deliveringRes = await _deliveringRepository.selectDeliveringById(
          order.id!,
        );

        return await deliveringRes.fold((failure) async => Left(failure), (
          delivery,
        ) async {
          final updates = delivery.copyWith(status: order.status);
          final deliveryUpdateRes = await _deliveringRepository
              .updateDeliveringByI(updates);

          return deliveryUpdateRes.fold(
            (failure) => Left(failure),
            (_) => Right(order),
          );
        });
      });
    } catch (e) {
      return Left(UnexceptedFailure(e.toString(), "500"));
    }
  }

  ResultFuture<List<OrderEntities>> researchOrder(
    OrderEntities? criterial, {
    int start = 0,
    int end = 9,
  }) => _orderRepository.researchOrder(criterial, start: start, end: end);
}
