import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toko_online_sederhana/core/di/providers.dart';
import 'package:toko_online_sederhana/features/order/data/datasources/order_local_datasource.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';
import 'package:toko_online_sederhana/features/order/data/repositories/order_repository.dart';

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

  Future<void> addOrder(OrderModel order) async {
    try {
      await _repo.createOrder(order);
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
          customerEmail: 'john@example.com',
          customerPhone: '+62812345678',
          shippingAddress: 'Jl. Sudirman No. 123, Jakarta',
          totalPrice: 25000000,
          status: 'pending',
          createdAt: DateTime.now(),
        ),
        OrderModel(
          customerName: 'Jane Smith',
          customerEmail: 'jane@example.com',
          customerPhone: '+62887654321',
          shippingAddress: 'Jl. Thamrin No. 456, Jakarta',
          totalPrice: 1200000,
          status: 'completed',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        OrderModel(
          customerName: 'Bob Johnson',
          customerEmail: 'bob@example.com',
          customerPhone: '+62811223344',
          shippingAddress: 'Jl. Gatot Subroto No. 789, Jakarta',
          totalPrice: 750000,
          status: 'processing',
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
          order.copyWith(
            status: newStatus,
            updatedAt: DateTime.now(),
          ),
        );
        await loadOrderDetail();
      } catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    }
  }
}