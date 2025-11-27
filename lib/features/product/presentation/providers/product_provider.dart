import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toko_online_sederhana/di.dart';
import 'package:toko_online_sederhana/features/product/data/datasources/product_local_datasource.dart';
import 'package:toko_online_sederhana/features/product/data/models/product_model.dart';
import 'package:toko_online_sederhana/features/product/data/repositories/product_repository.dart';

part 'product_provider.g.dart';

@riverpod
class ProductNotifier extends _$ProductNotifier {
  @override
  AsyncValue<List<ProductModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(productRepositoryProvider);
      final products = await repository.getProducts();
      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.deleteProduct(id);

      // Update the local state by removing the deleted product
      state.whenData((products) {
        state = AsyncValue.data(products.where((p) => p.id != id).toList());
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.createProduct(product);

      // Refresh the products list to include the new product
      await loadProducts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSampleProducts() async {
    try {
      final repository = ref.read(productRepositoryProvider);

      // Add sample products
      final sampleProducts = [
        ProductModel(
          name: 'Laptop ASUS ROG STRIX i7 Gen 10',
          price: 23865000,
          stock: 1,
          thumbnail:
              'https://parto.id/asset/foto_produk/510b05ac019b623a8b989f4a9a491c8a.jpeg',
          createdAt: DateTime.now(),
        ),
        ProductModel(
          name: 'Mouse Gaming Logitech G402 Hyperion Fury',
          price: 750000,
          stock: 2,
          thumbnail:
              'https://els.id/wp-content/uploads/2023/09/Logitech-G402.png',
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

      for (final product in sampleProducts) {
        await repository.createProduct(product);
      }

      // Refresh the products list
      await loadProducts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

@riverpod
ProductLocalDataSource productLocalDataSource(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return ProductLocalDataSourceImpl(database.productDao);
}

@riverpod
ProductRepository productRepository(Ref ref) {
  final localDataSource = ref.watch(productLocalDataSourceProvider);
  return ProductRepositoryImpl(localDataSource);
}
