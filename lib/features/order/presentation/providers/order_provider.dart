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
      final stockReducedStatuses = [
        'MENUNGGU_VERIFIKASI_CS2',
        'SEDANG_DIPROSES',
        'DIKIRIM',
      ];

      if (stockReducedStatuses.contains(order.status)) {
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
      }

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

      if (!ref.mounted) return;

      state.whenData((orders) {
        state = AsyncValue.data(orders.where((o) => o.id != id).toList());
      });
    } catch (e, st) {
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<int?> addOrder(OrderModel order, List<CheckoutItem> items) async {
    int? orderId;
    try {
      orderId = await _repo.createOrder(order, items);
      print('Order created with ID: $orderId');

      if (ref.mounted) {
        try {
          final updated = await _repo.getOrders();
          if (ref.mounted) {
            state = AsyncValue.data(updated);
          }
        } catch (e) {
          print('Error updating order list after order creation: $e');
        }
      }

      return orderId;
    } catch (e, st) {
      print('Error creating order: $e');
      print('Stack trace: $st');
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
      return orderId;
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final orders = state.value ?? [];
      final order = orders.firstWhere((o) => o.id == orderId);

      if (newStatus == 'DIBATALKAN' && order.status != 'DIBATALKAN') {
        await _cancelOrder(order);
      } else {
        final updatedOrder = order.copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );

        await _repo.saveOrder(updatedOrder);
      }

      if (!ref.mounted) return;

      await loadOrders();
    } catch (e, st) {
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

      if (!ref.mounted) return;

      await loadOrders();
    } catch (e, st) {
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

      if (!ref.mounted) return;

      state = AsyncValue.data(item);
    } catch (e, st) {
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> updateOrderStatus(String newStatus) async {
    final order = state.asData?.value;
    if (order != null) {
      try {
        if (newStatus == 'MENUNGGU_VERIFIKASI_CS2' &&
            order.items != null &&
            order.items!.isNotEmpty) {
          final productRepo = ref.read(productRepositoryProvider);
          for (final item in order.items!) {
            final product = await productRepo.getProduct(item.productId);
            if (product != null) {
              await productRepo.saveProduct(
                product.copyWith(
                  stock: product.stock - item.quantity,
                  updatedAt: DateTime.now(),
                ),
              );
            }
          }
        }

        await _repo.saveOrder(
          order.copyWith(status: newStatus, updatedAt: DateTime.now()),
        );

        if (!ref.mounted) return;

        await loadOrderDetail();
        await ref.read(orderProvider.notifier).loadOrders();
      } catch (e, st) {
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

      if (!ref.mounted) return true;

      await loadOrderDetail();
      await ref.read(orderProvider.notifier).loadOrders();
      return true;
    } catch (e, st) {
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

      if (!ref.mounted) return;

      state = AsyncValue.data(CheckoutData(user: user, items: combined));
    } catch (e, st) {
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

