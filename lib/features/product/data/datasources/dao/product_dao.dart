import 'package:drift/drift.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';

import '../table/product_table.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [ProductTable])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(super.db);

  Future<List<ProductTableData>> getAll() {
    return select(productTable).get();
  }

  Future<ProductTableData?> findById(int id) {
    return (select(
      productTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insert(ProductTableCompanion entry) {
    return into(productTable).insert(entry);
  }

  Future<int> upsert(ProductTableCompanion entry) {
    return into(productTable).insertOnConflictUpdate(entry);
  }

  Future<int> deleteById(int id) {
    return (delete(productTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> deleteAll() {
    return delete(productTable).go();
  }
}

