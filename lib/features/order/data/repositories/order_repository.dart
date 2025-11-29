import 'package:toko_online_sederhana/features/order/data/datasources/order_local_datasource.dart';
import 'package:toko_online_sederhana/features/order/data/models/checkout_model.dart';

import '../models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel?> getOrder(int id);
  Future<int> createOrder(OrderModel order, List<CheckoutItem> items);
  Future<void> saveOrder(OrderModel order);
  Future<void> deleteOrder(int id);
  Future<List<OrderModel>> checkAndCancelExpiredOrders({
    Duration threshold = const Duration(hours: 24),
  });
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource _local;

  OrderRepositoryImpl(this._local);

  @override
  Future<List<OrderModel>> getOrders() {
    return _local.getAllOrders();
  }

  @override
  Future<OrderModel?> getOrder(int id) {
    return _local.getOrderById(id);
  }

  @override
  Future<int> createOrder(OrderModel order, List<CheckoutItem> items) async {
    final orderId = await _local.insertOrder(
      order.copyWith(createdAt: DateTime.now()),
    );
    await _local.insertOrderItems(orderId, items);
    return orderId;
  }

  @override
  Future<void> saveOrder(OrderModel order) {
    return _local.upsertOrder(order.copyWith(updatedAt: DateTime.now()));
  }

  @override
  Future<void> deleteOrder(int id) {
    return _local.deleteOrder(id);
  }

  @override
  Future<List<OrderModel>> checkAndCancelExpiredOrders({
    Duration threshold = const Duration(hours: 24),
  }) async {
    final orders = await _local.getAllOrders();
    final now = DateTime.now();
    final cancelledOrders = <OrderModel>[];

    for (final order in orders) {
      final status = order.status.toUpperCase();
      if (status == 'MENUNGGU_UPLOAD_BUKTI' ||
          status == 'MENUNGGU_VERIFIKASI_CS1') {
        final diff = now.difference(order.createdAt);
        if (diff >= threshold) {
          final updatedOrder = order.copyWith(
            status: 'DIBATALKAN',
            updatedAt: now,
          );
          await _local.upsertOrder(updatedOrder);
          cancelledOrders.add(updatedOrder);
        }
      }
    }

    return cancelledOrders;
  }
}
