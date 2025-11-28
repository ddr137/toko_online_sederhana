import 'package:toko_online_sederhana/features/product/data/datasources/dao/product_dao.dart';
import 'package:toko_online_sederhana/features/product/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductById(int id);
  Future<int> insertProduct(ProductModel product);
  Future<void> upsertProduct(ProductModel product);
  Future<void> deleteProduct(int id);
  Future<void> clearAll();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final ProductDao _dao;

  ProductLocalDataSourceImpl(this._dao);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final rows = await _dao.getAll();
    return rows.map(ProductModel.fromDrift).toList();
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    final row = await _dao.findById(id);
    return row == null ? null : ProductModel.fromDrift(row);
  }

  @override
  Future<int> insertProduct(ProductModel product) {
    return _dao.insert(product.toCompanion());
  }

  @override
  Future<void> upsertProduct(ProductModel product) async {
    await _dao.upsert(product.toCompanion());
  }

  @override
  Future<void> deleteProduct(int id) {
    return _dao.deleteById(id);
  }

  @override
  Future<void> clearAll() async {
    await _dao.deleteAll();
  }
}

