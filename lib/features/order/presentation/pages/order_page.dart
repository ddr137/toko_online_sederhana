import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';
import 'package:toko_online_sederhana/features/order/presentation/providers/order_provider.dart';
import 'package:toko_online_sederhana/features/order/presentation/widgets/order_item.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/widgets/empty_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/error_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/loading_widget.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(orderProvider);

    final userState = ref.watch(userDetailProvider);
    final isCustomer = userState.value?.role == 'customer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.onSurface,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(orderProvider.notifier).refreshOrders();
        },
        child: ordersState.when(
          loading: () => const LoadingWidget(message: 'Memuat pesanan...'),
          error: (error, stackTrace) => ErrorStateWidget(
            title: 'Terjadi kesalahan',
            message: error.toString(),
            onRetry: () {
              ref.read(orderProvider.notifier).loadOrders();
            },
          ),
          data: (orders) {
            if (orders.isEmpty) {
              return EmptyStateWidget(
                title: 'Belum ada pesanan',
                subtitle: 'Pesanan pertama akan muncul di sini',
                icon: Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderItem(
                  order: order,
                  onTap: () {
                    context.push('/order-detail/${order.id}');
                  },
                  onDelete: () {
                    _showDeleteConfirmation(context, order);
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: isCustomer
          ? FloatingActionButton(
              onPressed: () async {
                await ref.read(orderProvider.notifier).addSampleOrders();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showDeleteConfirmation(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pesanan'),
        content: Text(
          'Apakah Anda yakin ingin menghapus pesanan "${order.customerName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              ref.read(orderProvider.notifier).deleteOrder(order.id!);
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
