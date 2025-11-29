import 'package:drift/drift.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';
import 'package:toko_online_sederhana/features/order/data/datasources/dao/order_dao.dart';
import 'package:toko_online_sederhana/features/order/data/datasources/dao/order_item_dao.dart';
import 'package:toko_online_sederhana/features/order/data/models/checkout_model.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getAllOrders();
  Future<OrderModel?> getOrderById(int id);
  Future<int> insertOrder(OrderModel order);
  Future<void> insertOrderItems(int orderId, List<CheckoutItem> items);
  Future<void> upsertOrder(OrderModel order);
  Future<void> deleteOrder(int id);
  Future<void> clearAll();
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final OrderDao _dao;
  final OrderItemDao _itemDao;

  OrderLocalDataSourceImpl(this._dao, this._itemDao);

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final rows = await _dao.getAll();
    return rows.map(OrderModel.fromDrift).toList();
  }

  @override
  Future<OrderModel?> getOrderById(int id) async {
    final row = await _dao.findById(id);
    if (row == null) return null;

    final items = await _itemDao.getOrderItems(id);
    return OrderModel.fromDrift(row, items: items);
  }

  @override
  Future<int> insertOrder(OrderModel order) {
    return _dao.insert(order.toCompanion());
  }

  @override
  Future<void> insertOrderItems(int orderId, List<CheckoutItem> items) async {
    final companions = items.map((item) {
      return OrderItemTableCompanion(
        orderId: Value(orderId),
        productId: Value(item.product.id!),
        quantity: Value(item.cart.quantity),
        price: Value(item.product.price),
      );
    }).toList();
    await _itemDao.insertOrderItems(companions);
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
