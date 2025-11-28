import 'package:toko_online_sederhana/features/order/data/datasources/dao/order_dao.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getAllOrders();
  Future<OrderModel?> getOrderById(int id);
  Future<int> insertOrder(OrderModel order);
  Future<void> upsertOrder(OrderModel order);
  Future<void> deleteOrder(int id);
  Future<void> clearAll();
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final OrderDao _dao;

  OrderLocalDataSourceImpl(this._dao);

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final rows = await _dao.getAll();
    return rows.map(OrderModel.fromDrift).toList();
  }

  @override
  Future<OrderModel?> getOrderById(int id) async {
    final row = await _dao.findById(id);
    return row == null ? null : OrderModel.fromDrift(row);
  }

  @override
  Future<int> insertOrder(OrderModel order) {
    return _dao.insert(order.toCompanion());
  }

  @override
  Future<void> upsertOrder(OrderModel order) async {
    await _dao.upsert(order.toCompanion());
  }

  @override
  Future<void> deleteOrder(int id) {
    return _dao.deleteById(id);
  }

  @override
  Future<void> clearAll() async {
    await _dao.deleteAll();
  }
}