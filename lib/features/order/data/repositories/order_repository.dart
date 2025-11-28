import 'package:toko_online_sederhana/features/order/data/datasources/order_local_datasource.dart';

import '../models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel?> getOrder(int id);
  Future<int> createOrder(OrderModel order);
  Future<void> saveOrder(OrderModel order);
  Future<void> deleteOrder(int id);
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
  Future<int> createOrder(OrderModel order) {
    return _local.insertOrder(
      order.copyWith(createdAt: DateTime.now()),
    );
  }

  @override
  Future<void> saveOrder(OrderModel order) {
    return _local.upsertOrder(
      order.copyWith(updatedAt: DateTime.now()),
    );
  }

  @override
  Future<void> deleteOrder(int id) {
    return _local.deleteOrder(id);
  }
}