import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/cart/data/models/cart_model.dart';
import 'package:toko_online_sederhana/features/cart/presentation/providers/cart_provider.dart';
import 'package:toko_online_sederhana/features/product/data/models/product_model.dart';
import 'package:toko_online_sederhana/features/product/presentation/providers/product_provider.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/currency_ext.dart';

class CartItemWidget extends ConsumerStatefulWidget {
  final CartModel cartItem;

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  ConsumerState<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends ConsumerState<CartItemWidget> {
  late Future<ProductModel?> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = ref.read(productRepositoryProvider).getProduct(widget.cartItem.productId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductModel?>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final product = snapshot.data;
        if (product == null) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                        ),
                        child: product.thumbnail != null
                            ? Image.network(
                                product.thumbnail!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(
                                  Icons.image,
                                  size: 32,
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              )
                            : Icon(
                                Icons.image,
                                size: 32,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                      ),
                    ),
                    AppSpacing.md,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSpacing.xs,
                          Text(
                            product.price.currencyFormatRp,
                            style: context.textTheme.titleSmall?.copyWith(
                              color: context.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.md,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${(product.price * widget.cartItem.quantity).currencyFormatRp}',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.cartItem.quantity > 1) {
                              ref
                                  .read(cartProvider.notifier)
                                  .updateCartItemQuantity(widget.cartItem.id!, widget.cartItem.quantity - 1);
                            }
                          },
                          icon: Icon(
                            Icons.remove,
                            size: 18,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${widget.cartItem.quantity}',
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .updateCartItemQuantity(widget.cartItem.id!, widget.cartItem.quantity + 1);
                          },
                          icon: Icon(
                            Icons.add,
                            size: 18,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).removeCartItem(widget.cartItem.id!);
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 18,
                            color: context.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
