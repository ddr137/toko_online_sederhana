import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/cart/data/models/cart_model.dart';
import 'package:toko_online_sederhana/features/cart/presentation/providers/cart_provider.dart';
import 'package:toko_online_sederhana/features/cart/presentation/widgets/cart_item.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/currency_ext.dart';
import 'package:toko_online_sederhana/shared/widgets/base_button.dart';
import 'package:toko_online_sederhana/shared/widgets/empty_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/error_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/loading_widget.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).loadCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.onSurface,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(cartProvider.notifier).refreshCart();
        },
        child: cartState.when(
          loading: () => const LoadingWidget(message: 'Memuat keranjang...'),
          error: (error, stackTrace) => ErrorStateWidget(
            title: 'Terjadi kesalahan',
            message: error.toString(),
            onRetry: () {
              ref.read(cartProvider.notifier).loadCartItems();
            },
          ),
          data: (cartItems) {
            if (cartItems.isEmpty) {
              return EmptyStateWidget(
                title: 'Keranjang kosong',
                subtitle: 'Tambahkan produk ke keranjang untuk melanjutkan',
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return CartItemWidget(cartItem: cartItem);
                    },
                  ),
                ),
                _CartSummary(cartItems: cartItems),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CartSummary extends ConsumerWidget {
  final List<CartModel> cartItems;

  const _CartSummary({required this.cartItems});

  @override
  Widget build(BuildContext context, ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final totalItems = cartNotifier.getTotalItems();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total ($totalItems item${totalItems > 1 ? 's' : ''})',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              FutureBuilder<int>(
                future: cartNotifier.getTotalPrice(),
                builder: (context, snapshot) {
                  final total = snapshot.data ?? 0;
                  return Text(
                    total.currencyFormatRp,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.primary,
                    ),
                  );
                },
              ),
            ],
          ),
          AppSpacing.lg,
          BaseButton(
            text: 'Checkout',
            width: double.infinity,
            onPressed: () {
              context.push('/checkout');
            },
          ),
        ],
      ),
    );
  }
}
