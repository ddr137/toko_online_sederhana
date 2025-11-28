import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/features/product/data/models/product_model.dart';
import 'package:toko_online_sederhana/features/product/presentation/providers/product_provider.dart';
import 'package:toko_online_sederhana/features/product/presentation/widgets/product_item.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/widgets/empty_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/error_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/loading_widget.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productProvider);

    final userState = ref.watch(userDetailProvider);
    final isCustomer = userState.value?.role == 'customer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.onSurface,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(productProvider.notifier).refreshProducts();
        },
        child: productsState.when(
          loading: () => const LoadingWidget(message: 'Memuat produk...'),
          error: (error, stackTrace) => ErrorStateWidget(
            title: 'Terjadi kesalahan',
            message: error.toString(),
            onRetry: () {
              ref.read(productProvider.notifier).loadProducts();
            },
          ),
          data: (products) {
            if (products.isEmpty) {
              return EmptyStateWidget(
                title: 'Belum ada produk',
                subtitle: 'Tambahkan produk pertama Anda untuk memulai',
                icon: Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItem(
                  product: product,
                  onTap: () {
                    context.push('/product-detail/${product.id}');
                  },
                  onDelete: () {
                    _showDeleteConfirmation(context, product);
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
                await ref.read(productProvider.notifier).addSampleProducts();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Apakah Anda yakin ingin menghapus "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              ref.read(productProvider.notifier).deleteProduct(product.id!);
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
