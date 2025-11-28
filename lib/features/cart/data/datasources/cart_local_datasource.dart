import 'package:toko_online_sederhana/features/cart/data/datasources/dao/cart_dao.dart';
import 'package:toko_online_sederhana/features/cart/data/models/cart_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartModel>> getAllCartItems();
  Future<CartModel?> getCartById(int id);
  Future<int> insertCartItem(CartModel cartItem);
  Future<void> upsertCartItem(CartModel cartItem);
  Future<void> updateCartItemQuantity(int id, int quantity);
  Future<void> deleteCartItem(int id);
  Future<void> deleteCartItemByProductId(int productId);
  Future<void> clearAll();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final CartDao _dao;

  CartLocalDataSourceImpl(this._dao);

  @override
  Future<List<CartModel>> getAllCartItems() async {
    final rows = await _dao.getAll();
    return rows.map(CartModel.fromDrift).toList();
  }

  @override
  Future<CartModel?> getCartById(int id) async {
    final row = await _dao.findById(id);
    return row == null ? null : CartModel.fromDrift(row);
  }

  @override
  Future<int> insertCartItem(CartModel cartItem) {
    return _dao.insert(cartItem.toCompanion());
  }

  @override
  Future<void> upsertCartItem(CartModel cartItem) async {
    await _dao.upsert(cartItem.toCompanion());
  }

  @override
  Future<void> updateCartItemQuantity(int id, int quantity) async {
    await _dao.updateQuantity(id, quantity);
  }

  @override
  Future<void> deleteCartItem(int id) {
    return _dao.deleteById(id);
  }

  @override
  Future<void> deleteCartItemByProductId(int productId) {
    return _dao.deleteByProductId(productId);
  }

  @override
  Future<void> clearAll() async {
    await _dao.deleteAll();
  }
}
