import 'package:drift/drift.dart';
import 'package:toko_online_sederhana/features/order/data/datasources/table/order_table.dart';
import 'package:toko_online_sederhana/features/product/data/datasources/table/product_table.dart';

class OrderItemTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(OrderTable, #id)();
  IntColumn get productId => integer().references(ProductTable, #id)();
  IntColumn get quantity => integer()();
  IntColumn get price => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

