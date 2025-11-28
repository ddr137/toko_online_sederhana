import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/cart/presentation/providers/cart_provider.dart';
import 'package:toko_online_sederhana/features/order/data/models/checkout_model.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';
import 'package:toko_online_sederhana/features/order/presentation/providers/order_provider.dart';
import 'package:toko_online_sederhana/features/order/presentation/widgets/detail_product_section.dart';
import 'package:toko_online_sederhana/features/order/presentation/widgets/summary_section.dart';
import 'package:toko_online_sederhana/features/order/presentation/widgets/user_info_section.dart';
import 'package:toko_online_sederhana/shared/widgets/base_button.dart';
import 'package:toko_online_sederhana/shared/widgets/error_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/loading_widget.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  bool _isProcessingOrder = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(checkoutProvider.notifier).loadCheckout();
    });
  }

  Future<void> _handlePayment(CheckoutData checkout) async {
    if (_isProcessingOrder) return;

    setState(() {
      _isProcessingOrder = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final order = OrderModel(
        customerName: checkout.user.name,
        customerRole: checkout.user.role,
        customerPhone: checkout.user.phone,
        shippingAddress: checkout.user.address,
        totalPrice: ref.read(checkoutProvider.notifier).getTotal(),
        status: 'MENUNGGU_UPLOAD_BUKTI',
        createdAt: DateTime.now(),
      );

      final orderId = await ref
          .read(orderProvider.notifier)
          .addOrder(order, checkout.items);

      if (mounted) {
        try {
          print('CheckoutPage: Clearing cart before navigation...');
          await ref.read(cartProvider.notifier).clearCart();
          print('CheckoutPage: Cart cleared successfully');
        } catch (e) {
          print('CheckoutPage: Error clearing cart: $e');
        }

        Navigator.of(context).pop();

        if (orderId != null) {
          context.pushReplacement('/order-detail/$orderId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Gagal membuat pesanan: ID pesanan tidak ditemukan',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal membuat pesanan: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: checkoutState.when(
        loading: () => const LoadingWidget(message: 'Memuat checkout...'),
        error: (error, stackTrace) => ErrorStateWidget(
          title: 'Terjadi kesalahan',
          message: error.toString(),
          onRetry: () {
            ref.read(checkoutProvider.notifier).loadCheckout();
          },
        ),
        data: (checkout) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      UserInfoSection(user: checkout.user),
                      AppSpacing.vertical(AppGaps.md),

                      Card(
                        elevation: 0,
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withAlpha(76),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.outlineVariant.withAlpha(128),
                          ),
                        ),
                        child: DetailProductSection(items: checkout.items),
                      ),
                      AppSpacing.vertical(AppGaps.md),

                      SummarySection(
                        total: ref.read(checkoutProvider.notifier).getTotal(),
                      ),
                      AppSpacing.vertical(AppGaps.lg),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: BaseButton(
                    width: double.infinity,
                    isLoading: _isProcessingOrder,
                    onPressed: () => _handlePayment(checkout),
                    text: 'Bayar Sekarang',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}



