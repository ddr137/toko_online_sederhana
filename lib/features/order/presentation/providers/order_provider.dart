import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toko_online_sederhana/core/di/providers.dart';
import 'package:toko_online_sederhana/features/cart/data/repositories/cart_repository.dart';
import 'package:toko_online_sederhana/features/cart/presentation/providers/cart_provider.dart';
import 'package:toko_online_sederhana/features/order/data/datasources/order_local_datasource.dart';
import 'package:toko_online_sederhana/features/order/data/models/checkout_model.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';
import 'package:toko_online_sederhana/features/order/data/repositories/order_repository.dart';
import 'package:toko_online_sederhana/features/product/data/repositories/product_repository.dart';
import 'package:toko_online_sederhana/features/product/presentation/providers/product_provider.dart';
import 'package:toko_online_sederhana/features/user/data/repositories/user_repository.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';

part 'order_provider.g.dart';

@Riverpod(keepAlive: true)
OrderLocalDataSource orderLocalDataSource(Ref ref) {
  final database = ref.read(appDatabaseProvider);
  return OrderLocalDataSourceImpl(database.orderDao);
}

@Riverpod(keepAlive: true)
OrderRepository orderRepository(Ref ref) {
  final local = ref.read(orderLocalDataSourceProvider);
  return OrderRepositoryImpl(local);
}

@riverpod
class OrderNotifier extends _$OrderNotifier {
  OrderRepository get _repo => ref.read(orderRepositoryProvider);

  @override
  AsyncValue<List<OrderModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadOrders() async {
    state = const AsyncValue.loading();
    try {
      final orders = await _repo.getOrders();
      state = AsyncValue.data(orders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }

  Future<void> deleteOrder(int id) async {
    try {
      await _repo.deleteOrder(id);

      state.whenData((orders) {
        state = AsyncValue.data(orders.where((o) => o.id != id).toList());
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> addOrder(OrderModel order) async {
    try {
      await _repo.createOrder(order);
      final updated = await _repo.getOrders();
      state = AsyncValue.data(updated);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      // Get the current order
      final orders = state.value ?? [];
      final order = orders.firstWhere((o) => o.id == orderId);

      // Update the order status
      final updatedOrder = order.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );

      await _repo.saveOrder(updatedOrder);
      await loadOrders();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSampleOrders() async {
    try {
      final sampleOrders = [
        OrderModel(
          customerName: 'John Doe',
          customerRole: 'customer',
          customerPhone: '+62812345678',
          shippingAddress: 'Jl. Sudirman No. 123, Jakarta',
          totalPrice: 25000000,
          status: 'SEDANG_DIPROSES',
          createdAt: DateTime.now(),
        ),
        OrderModel(
          customerName: 'Jane Smith',
          customerRole: 'customer',
          customerPhone: '+62887654321',
          shippingAddress: 'Jl. Thamrin No. 456, Jakarta',
          totalPrice: 1200000,
          status: 'DIKIRIM',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        OrderModel(
          customerName: 'Bob Johnson',
          customerRole: 'customer',
          customerPhone: '+62811223344',
          shippingAddress: 'Jl. Gatot Subroto No. 789, Jakarta',
          totalPrice: 750000,
          status: 'SELESAI',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

      for (final order in sampleOrders) {
        await _repo.createOrder(order);
      }

      await loadOrders();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
class OrderDetailNotifier extends _$OrderDetailNotifier {
  OrderRepository get _repo => ref.read(orderRepositoryProvider);

  @override
  AsyncValue<OrderModel?> build(String orderId) {
    return const AsyncValue.loading();
  }

  Future<void> loadOrderDetail() async {
    state = const AsyncValue.loading();
    try {
      final item = await _repo.getOrder(int.parse(orderId));
      state = AsyncValue.data(item);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateOrderStatus(String newStatus) async {
    final order = state.asData?.value;
    if (order != null) {
      try {
        await _repo.saveOrder(
          order.copyWith(status: newStatus, updatedAt: DateTime.now()),
        );
        await loadOrderDetail();
      } catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    }
  }
}

@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  CartRepository get _cartRepo => ref.read(cartRepositoryProvider);
  UserRepository get _userRepo => ref.read(userRepositoryProvider);
  ProductRepository get _productRepo => ref.read(productRepositoryProvider);

  @override
  AsyncValue<CheckoutData> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadCheckout() async {
    state = const AsyncValue.loading();

    try {
      final user = await _userRepo.getUser();
      final cartItems = await _cartRepo.getCartItems();
      final products = await _productRepo.getProducts();

      final combined = cartItems.map((cart) {
        final product = products.firstWhere((p) => p.id == cart.productId);

        return CheckoutItem(product: product, cart: cart);
      }).toList();

      state = AsyncValue.data(CheckoutData(user: user, items: combined));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  int getTotal() {
    final data = state.value;
    if (data == null) return 0;

    return data.items.fold(
      0,
      (sum, item) => sum + (item.product.price * item.cart.quantity),
    );
  }
}
