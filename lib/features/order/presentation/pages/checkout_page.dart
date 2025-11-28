import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

      final orderId = await ref.read(orderProvider.notifier).addOrder(order);

      if (orderId != null && mounted) {
        context.pushReplacement('/order-detail/$orderId');
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
                      // User Info Section
                      UserInfoSection(user: checkout.user),
                      const SizedBox(height: 16),

                      // Product Details Section
                      Card(
                        elevation: 0,
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.outlineVariant.withOpacity(0.5),
                          ),
                        ),
                        child: DetailProductSection(items: checkout.items),
                      ),
                      const SizedBox(height: 16),

                      // Summary Section
                      SummarySection(
                        total: ref.read(checkoutProvider.notifier).getTotal(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
