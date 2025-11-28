import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(checkoutProvider.notifier).loadCheckout();
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserInfoSection(user: checkout.user),
              const Divider(),
              DetailProductSection(items: checkout.items),
              SummarySection(
                total: ref.read(checkoutProvider.notifier).getTotal(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: BaseButton(
                  width: double.infinity,
                  onPressed: () {},
                  text: 'Bayar Sekarang',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
