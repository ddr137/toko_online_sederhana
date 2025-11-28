import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/order/data/models/checkout_model.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/currency_ext.dart';

class DetailProductSection extends StatelessWidget {
  const DetailProductSection({super.key, required this.items});

  final List<CheckoutItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppGaps.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Produk yang Dibeli",
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.onSurface,
            ),
          ),
          AppSpacing.md,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              final subtotal = item.product.price * item.cart.quantity;

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppGaps.sm + 2,
                  horizontal: AppGaps.xs,
                ),
                child: Row(
                  children: [
                    // Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.product.thumbnail ?? "",
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 55,
                          height: 55,
                          color: context.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image,
                            size: 22,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppGaps.md - 4),

                    // INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          AppSpacing.xs,

                          // qty + harga satuan
                          Text(
                            "${item.product.price.currencyFormatRp} × ${item.cart.quantity}",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // TOTAL PER ITEM
                    Text(
                      subtotal.currencyFormatRp,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
