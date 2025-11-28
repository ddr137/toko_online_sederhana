import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toko_online_sederhana/core/di/providers.dart';
import 'package:toko_online_sederhana/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:toko_online_sederhana/features/cart/data/models/cart_model.dart';
import 'package:toko_online_sederhana/features/cart/data/repositories/cart_repository.dart';
import 'package:toko_online_sederhana/features/product/presentation/providers/product_provider.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
CartLocalDataSource cartLocalDataSource(Ref ref) {
  final database = ref.read(appDatabaseProvider);
  return CartLocalDataSourceImpl(database.cartDao);
}

@Riverpod(keepAlive: true)
CartRepository cartRepository(Ref ref) {
  final local = ref.read(cartLocalDataSourceProvider);
  return CartRepositoryImpl(local);
}

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  CartRepository get _repo => ref.read(cartRepositoryProvider);

  @override
  AsyncValue<List<CartModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadCartItems({bool showLoading = true}) async {
    if (showLoading) state = const AsyncValue.loading();
    try {
      final cartItems = await _repo.getCartItems();
      state = AsyncValue.data(cartItems);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshCart() async {
    await loadCartItems();
  }

  Future<void> addCartItem(CartModel cartItem) async {
    try {
      // Ensure items are loaded so we can check for duplicates
      if (!state.hasValue) {
        final items = await _repo.getCartItems();
        state = AsyncValue.data(items);
      }

      final existingItem = state.asData?.value.firstWhere(
        (item) => item.productId == cartItem.productId,
        orElse: () => CartModel(
          id: null,
          productId: -1,
          quantity: 0,
          createdAt: DateTime.now(),
        ),
      );

      if (existingItem != null && existingItem.id != null) {
        // Update quantity if item already exists
        final newQuantity = existingItem.quantity + cartItem.quantity;
        await _repo.updateCartItemQuantity(existingItem.id!, newQuantity);
        await loadCartItems(showLoading: false);
      } else {
        // Add new item to cart
        await _repo.addCartItem(cartItem);
        await loadCartItems();
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeCartItem(int id) async {
    try {
      await _repo.removeCartItem(id);
      await loadCartItems();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeCartItemByProductId(int productId) async {
    try {
      await _repo.removeCartItemByProductId(productId);
      await loadCartItems();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateCartItemQuantity(int id, int quantity) async {
    try {
      if (quantity <= 0) {
        await _repo.removeCartItem(id);
        await loadCartItems(); // Show loading when deleting
      } else {
        await _repo.updateCartItemQuantity(id, quantity);
        await loadCartItems(
          showLoading: false,
        ); // No loading when updating quantity
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearCart() async {
    try {
      print('CartProvider: Clearing cart...');
      await _repo.clearCart();
      print('CartProvider: Cart cleared from database');
      await loadCartItems(showLoading: false);
      print(
        'CartProvider: Cart items reloaded, count: ${state.value?.length ?? 0}',
      );
    } catch (e, st) {
      print('CartProvider: Error clearing cart: $e');
      print('Stack trace: $st');
      state = AsyncValue.error(e, st);
    }
  }

  int getTotalItems() {
    final cartItems = state.asData?.value;
    if (cartItems == null) return 0;
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  Future<int> getTotalPrice() async {
    final cartItems = state.asData?.value;
    if (cartItems == null || cartItems.isEmpty) return 0;

    int totalPrice = 0;
    for (final cartItem in cartItems) {
      final product = await ref
          .read(productRepositoryProvider)
          .getProduct(cartItem.productId);
      if (product != null) {
        totalPrice += product.price * cartItem.quantity;
      }
    }

    return totalPrice;
  }
}
