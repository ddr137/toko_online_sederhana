import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/cart/data/models/cart_model.dart';
import 'package:toko_online_sederhana/features/cart/presentation/providers/cart_provider.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/currency_ext.dart';
import 'package:toko_online_sederhana/shared/widgets/base_button.dart';

class CheckoutSummary extends ConsumerWidget {
  final List<CartModel> items;

  const CheckoutSummary({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            text: 'Bayar Sekarang',
            width: double.infinity,
            onPressed: () {
              // TODO: Implement payment logic
            },
          ),
        ],
      ),
    );
  }
}
