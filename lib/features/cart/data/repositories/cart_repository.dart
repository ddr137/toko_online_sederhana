import 'package:toko_online_sederhana/features/cart/data/datasources/cart_local_datasource.dart';

import '../models/cart_model.dart';

abstract class CartRepository {
  Future<List<CartModel>> getCartItems();
  Future<CartModel?> getCartItem(int id);
  Future<int> addCartItem(CartModel cartItem);
  Future<void> updateCartItem(CartModel cartItem);
  Future<void> updateCartItemQuantity(int id, int quantity);
  Future<void> removeCartItem(int id);
  Future<void> removeCartItemByProductId(int productId);
  Future<void> clearCart();
}

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _local;

  CartRepositoryImpl(this._local);

  @override
  Future<List<CartModel>> getCartItems() {
    return _local.getAllCartItems();
  }

  @override
  Future<CartModel?> getCartItem(int id) {
    return _local.getCartById(id);
  }

  @override
  Future<int> addCartItem(CartModel cartItem) {
    return _local.insertCartItem(
      cartItem.copyWith(createdAt: DateTime.now()),
    );
  }

  @override
  Future<void> updateCartItem(CartModel cartItem) {
    return _local.upsertCartItem(
      cartItem.copyWith(updatedAt: DateTime.now()),
    );
  }

  @override
  Future<void> updateCartItemQuantity(int id, int quantity) {
    return _local.updateCartItemQuantity(id, quantity);
  }

  @override
  Future<void> removeCartItem(int id) {
    return _local.deleteCartItem(id);
  }

  @override
  Future<void> removeCartItemByProductId(int productId) {
    return _local.deleteCartItemByProductId(productId);
  }

  @override
  Future<void> clearCart() {
    return _local.clearAll();
  }
}
