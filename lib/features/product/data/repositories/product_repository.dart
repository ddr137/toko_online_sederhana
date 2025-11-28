import 'package:toko_online_sederhana/features/product/data/datasources/product_local_datasource.dart';

import '../models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel?> getProduct(int id);
  Future<int> createProduct(ProductModel product);
  Future<void> saveProduct(ProductModel product);
  Future<void> deleteProduct(int id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource _local;

  ProductRepositoryImpl(this._local);

  @override
  Future<List<ProductModel>> getProducts() {
    return _local.getAllProducts();
  }

  @override
  Future<ProductModel?> getProduct(int id) {
    return _local.getProductById(id);
  }

  @override
  Future<int> createProduct(ProductModel product) {
    return _local.insertProduct(
      product.copyWith(createdAt: DateTime.now()),
    );
  }

  @override
  Future<void> saveProduct(ProductModel product) {
    return _local.upsertProduct(
      product.copyWith(updatedAt: DateTime.now()),
    );
  }

  @override
  Future<void> deleteProduct(int id) {
    return _local.deleteProduct(id);
  }
}

