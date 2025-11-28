import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toko_online_sederhana/core/di/providers.dart';
import 'package:toko_online_sederhana/features/cart/data/models/cart_model.dart';
import 'package:toko_online_sederhana/features/cart/presentation/providers/cart_provider.dart';
import 'package:toko_online_sederhana/features/product/data/datasources/product_local_datasource.dart';
import 'package:toko_online_sederhana/features/product/data/models/product_model.dart';
import 'package:toko_online_sederhana/features/product/data/repositories/product_repository.dart';

part 'product_provider.g.dart';

@Riverpod(keepAlive: true)
ProductLocalDataSource productLocalDataSource(Ref ref) {
  final database = ref.read(appDatabaseProvider);
  return ProductLocalDataSourceImpl(database.productDao);
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) {
  final local = ref.read(productLocalDataSourceProvider);
  return ProductRepositoryImpl(local);
}

@riverpod
class ProductNotifier extends _$ProductNotifier {
  ProductRepository get _repo => ref.read(productRepositoryProvider);

  @override
  AsyncValue<List<ProductModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await _repo.getProducts();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _repo.deleteProduct(id);

      state.whenData((products) {
        state = AsyncValue.data(products.where((p) => p.id != id).toList());
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await _repo.createProduct(product);
      await loadProducts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSampleProducts() async {
    try {
      final sampleProducts = [
        ProductModel(
          name: 'Laptop ASUS ROG STRIX i7 Gen 10',
          price: 23865000,
          stock: 1,
          thumbnail:
              'https://id.store.asus.com/media/catalog/product/0/2/02_g_new_16_l_1_1.jpg?width=800&height=800&store=id_ID&image-type=image',
          createdAt: DateTime.now(),
        ),
        ProductModel(
          name: 'Mouse Gaming Logitech G402 Hyperion Fury',
          price: 750000,
          stock: 0,
          thumbnail:
              'https://els.id/wp-content/uploads/2023/09/Logitech-G402-6.png',
          createdAt: DateTime.now(),
        ),
        ProductModel(
          name:
              '5Star GKW200 Keyboard Mechanical Wireless Gaming 2.4G RGB Backlight',
          price: 1200000,
          stock: 15,
          thumbnail:
              'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/100/MTA-181226935/5star_5star_gkw200_keyboard_mechanical_wireless_gaming_2-4g_rgb_backlight_full09_sj7rzkd4.jpg',
          createdAt: DateTime.now(),
        ),
      ];

      for (final p in sampleProducts) {
        await _repo.createProduct(p);
      }

      await loadProducts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
class ProductDetailNotifier extends _$ProductDetailNotifier {
  ProductRepository get _repo => ref.read(productRepositoryProvider);

  @override
  AsyncValue<ProductModel?> build(String productId) {
    return const AsyncValue.loading();
  }

  Future<void> loadProductDetail() async {
    state = const AsyncValue.loading();
    try {
      final item = await _repo.getProduct(int.parse(productId));
      state = AsyncValue.data(item);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> onAddToCartPressed() async {
    final product = state.asData?.value;
    if (product != null) {
      final cartItem = CartModel(
        productId: product.id!,
        quantity: 1,
        createdAt: DateTime.now(),
      );

      await ref.read(cartProvider.notifier).addCartItem(cartItem);
    }
  }
}
