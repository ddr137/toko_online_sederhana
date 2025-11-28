import 'package:drift/drift.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';

import '../table/cart_table.dart';

part 'cart_dao.g.dart';

@DriftAccessor(tables: [CartTable])
class CartDao extends DatabaseAccessor<AppDatabase> with _$CartDaoMixin {
  CartDao(super.db);

  Future<List<CartTableData>> getAll() {
    return select(cartTable).get();
  }

  Future<CartTableData?> findById(int id) {
    return (select(
      cartTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insert(CartTableCompanion entry) {
    return into(cartTable).insert(entry);
  }

  Future<int> upsert(CartTableCompanion entry) {
    return into(cartTable).insertOnConflictUpdate(entry);
  }

  Future<int> updateQuantity(int id, int quantity) {
    return (update(cartTable)..where((t) => t.id.equals(id))).write(
      CartTableCompanion(
        quantity: Value(quantity),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteById(int id) {
    return (delete(cartTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> deleteByProductId(int productId) {
    return (delete(cartTable)..where((t) => t.productId.equals(productId))).go();
  }

  Future<int> deleteAll() {
    return delete(cartTable).go();
  }
}