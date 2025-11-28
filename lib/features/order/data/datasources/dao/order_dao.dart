import 'package:drift/drift.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';
import 'package:toko_online_sederhana/features/order/data/datasources/table/order_table.dart';

part 'order_dao.g.dart';

@DriftAccessor(tables: [OrderTable])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  OrderDao(super.db);

  Future<List<OrderTableData>> getAll() =>
      (select(orderTable)..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
          .get();

  Future<OrderTableData?> findById(int id) =>
      (select(orderTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insert(OrderTableCompanion entry) =>
      into(orderTable).insert(entry);

  Future<void> upsert(OrderTableCompanion entry) =>
      into(orderTable).insertOnConflictUpdate(entry);

  Future<void> deleteById(int id) =>
      (delete(orderTable)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> deleteAll() => delete(orderTable).go();
}

