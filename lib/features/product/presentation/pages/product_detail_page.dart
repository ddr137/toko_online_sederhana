import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_online_sederhana/core/theme/app_colors.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/product/data/models/product_model.dart';
import 'package:toko_online_sederhana/features/product/presentation/providers/product_provider.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/currency_ext.dart';
import 'package:toko_online_sederhana/shared/widgets/base_button.dart';
import 'package:toko_online_sederhana/shared/widgets/error_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/loading_widget.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productDetailProvider(widget.productId).notifier)
          .loadProductDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productDetailState = ref.watch(
      productDetailProvider(widget.productId),
    );
    final productDetailNotifier = ref.read(
      productDetailProvider(widget.productId).notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: productDetailState.when(
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => ErrorStateWidget(
          title: 'Gagal Mengambil Data Produk',
          message: error.toString(),
          onRetry: () => productDetailNotifier.loadProductDetail(),
        ),
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Produk tidak ditemukan'));
          }
          return _ProductDetailContent(
            product: product,
            onBuyPressed: productDetailNotifier.onBuyPressed,
            onAddToCartPressed: productDetailNotifier.onAddToCartPressed,
          );
        },
      ),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent({
    required this.product,
    required this.onBuyPressed,
    required this.onAddToCartPressed,
  });

  final ProductModel product;
  final VoidCallback onBuyPressed;
  final VoidCallback onAddToCartPressed;

  @override
  Widget build(BuildContext context) {
    const bottomBarHeight = 80.0;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomBarHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.thumbnail != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.thumbnail!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              AppSpacing.md,

              Text(
                product.name,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.sm,

              Text(
                product.price.currencyFormatRp,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.sm,

              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: product.stock > 0
                        ? AppColors.success(context)
                        : AppColors.error(context),
                  ),
                  AppSpacing.xs,
                  Text(
                    product.stock > 0
                        ? 'Stok: ${product.stock}'
                        : 'Stok Habis',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: product.stock > 0
                          ? AppColors.success(context)
                          : AppColors.error(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              AppSpacing.lg,

              Text(
                'Deskripsi Produk',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              AppSpacing.sm,
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: BaseButton(
                      text: 'Tambah ke Keranjang',
                      onPressed:
                          product.stock > 0 ? onAddToCartPressed : null,
                      isOutlined: true,
                    ),
                  ),
                  AppSpacing.md,
                  Expanded(
                    child: BaseButton(
                      text: 'Beli Langsung',
                      onPressed: product.stock > 0 ? onBuyPressed : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
