import 'package:drift/drift.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';
import 'package:toko_online_sederhana/features/order/data/datasources/table/order_item_table.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_item_model.dart';
import 'package:toko_online_sederhana/features/product/data/datasources/table/product_table.dart';

part 'order_item_dao.g.dart';

@DriftAccessor(tables: [OrderItemTable, ProductTable])
class OrderItemDao extends DatabaseAccessor<AppDatabase>
    with _$OrderItemDaoMixin {
  OrderItemDao(super.db);

  Future<void> insertOrderItems(List<OrderItemTableCompanion> items) async {
    await batch((batch) {
      batch.insertAll(orderItemTable, items);
    });
  }

  Future<List<OrderItemModel>> getOrderItems(int orderId) async {
    final query = select(orderItemTable).join([
      innerJoin(
        productTable,
        productTable.id.equalsExp(orderItemTable.productId),
      ),
    ])..where(orderItemTable.orderId.equals(orderId));

    final rows = await query.get();

    return rows.map((row) {
      final item = row.readTable(orderItemTable);
      final product = row.readTable(productTable);

      return OrderItemModel(
        id: item.id,
        orderId: item.orderId,
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
        productName: product.name,
        productImage: product.thumbnail,
      );
    }).toList();
  }
}

