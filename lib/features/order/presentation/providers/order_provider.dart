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
  return OrderLocalDataSourceImpl(database.orderDao, database.orderItemDao);
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

      // Auto-cancel logic
      final now = DateTime.now();
      bool hasChanges = false;

      for (final order in orders) {
        if ((order.status == 'MENUNGGU_UPLOAD_BUKTI' ||
                order.status == 'MENUNGGU_VERIFIKASI_CS1') &&
            now.difference(order.createdAt).inHours >= 24) {
          await _cancelOrder(order);
          hasChanges = true;
        }
      }

      if (hasChanges) {
        final updatedOrders = await _repo.getOrders();
        if (!ref.mounted) return;
        state = AsyncValue.data(updatedOrders);
      } else {
        if (!ref.mounted) return;
        state = AsyncValue.data(orders);
      }
    } catch (e, st) {
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> _cancelOrder(OrderModel order) async {
    try {
      // 1. Restore stock
      // Need to fetch full order details including items
      final fullOrder = await _repo.getOrder(order.id!);
      if (fullOrder != null &&
          fullOrder.items != null &&
          fullOrder.items!.isNotEmpty) {
        final productRepo = ref.read(productRepositoryProvider);
        for (final item in fullOrder.items!) {
          final product = await productRepo.getProduct(item.productId);
          if (product != null) {
            await productRepo.saveProduct(
              product.copyWith(
                stock: product.stock + item.quantity,
                updatedAt: DateTime.now(),
              ),
            );
          }
        }
      }

      // 2. Update status to DIBATALKAN
      await _repo.saveOrder(
        order.copyWith(status: 'DIBATALKAN', updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error auto-cancelling order ${order.id}: $e');
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }

  Future<void> deleteOrder(int id) async {
    try {
      await _repo.deleteOrder(id);

      // Check if ref is still mounted before updating state
      if (!ref.mounted) return;

      state.whenData((orders) {
        state = AsyncValue.data(orders.where((o) => o.id != id).toList());
      });
    } catch (e, st) {
      // Only update state if still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<int?> addOrder(OrderModel order, List<CheckoutItem> items) async {
    int? orderId;
    try {
      orderId = await _repo.createOrder(order, items);

      // Try to clear cart and update state, but don't fail the operation if these fail
      try {
        final cartRepo = ref.read(cartRepositoryProvider);
        await cartRepo.clearCart();
        // Explicitly reload cart to reflect empty state
        await ref.read(cartProvider.notifier).loadCartItems(showLoading: false);

        if (ref.mounted) {
          final updated = await _repo.getOrders();
          if (ref.mounted) {
            state = AsyncValue.data(updated);
          }
        }
      } catch (e) {
        // Log error but don't rethrow, as order is already created
        print('Error updating state after order creation: $e');
      }

      return orderId;
    } catch (e, st) {
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
      return orderId; // Return orderId if it was created before error
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      // Get the current order
      final orders = state.value ?? [];
      final order = orders.firstWhere((o) => o.id == orderId);

      // If cancelling manually, also restore stock
      if (newStatus == 'DIBATALKAN' && order.status != 'DIBATALKAN') {
        await _cancelOrder(order);
      } else {
        // Update the order status
        final updatedOrder = order.copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );

        await _repo.saveOrder(updatedOrder);
      }

      // Check if ref is still mounted before updating state
      if (!ref.mounted) return;

      await loadOrders();
    } catch (e, st) {
      // Only update state if still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
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
        await _repo.createOrder(order, []);
      }

      // Check if ref is still mounted before updating state
      if (!ref.mounted) return;

      await loadOrders();
    } catch (e, st) {
      // Only update state if still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
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

      // Check if ref is still mounted before updating state
      if (!ref.mounted) return;

      state = AsyncValue.data(item);
    } catch (e, st) {
      // Only update state if still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> updateOrderStatus(String newStatus) async {
    final order = state.asData?.value;
    if (order != null) {
      try {
        await _repo.saveOrder(
          order.copyWith(status: newStatus, updatedAt: DateTime.now()),
        );

        // Check if ref is still mounted before updating state
        if (!ref.mounted) return;

        await loadOrderDetail();
        // Refresh the order list to reflect changes
        await ref.read(orderProvider.notifier).loadOrders();
      } catch (e, st) {
        // Only update state if still mounted
        if (ref.mounted) {
          state = AsyncValue.error(e, st);
        }
      }
    }
  }

  Future<bool> uploadPaymentProof(String imagePath) async {
    final order = state.asData?.value;
    if (order == null) return false;

    try {
      // Determine next verification status based on current customer role
      String nextStatus = order.customerRole == 'customer'
          ? 'MENUNGGU_VERIFIKASI_CS1'
          : 'MENUNGGU_VERIFIKASI_CS2';

      await _repo.saveOrder(
        order.copyWith(
          paymentProofPath: imagePath,
          status: nextStatus,
          updatedAt: DateTime.now(),
        ),
      );

      // Check if ref is still mounted before updating state
      if (!ref.mounted) return true;

      await loadOrderDetail();
      // Refresh the order list to reflect changes
      await ref.read(orderProvider.notifier).loadOrders();
      return true;
    } catch (e, st) {
      // Only update state if still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
      return false;
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

      // Check if ref is still mounted before updating state
      if (!ref.mounted) return;

      state = AsyncValue.data(CheckoutData(user: user, items: combined));
    } catch (e, st) {
      // Only update state if still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
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
