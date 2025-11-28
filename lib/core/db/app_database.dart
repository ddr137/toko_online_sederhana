import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:toko_online_sederhana/core/constants/app_constants.dart';

import '../../features/cart/data/datasources/dao/cart_dao.dart';
import '../../features/cart/data/datasources/table/cart_table.dart';
import '../../features/order/data/datasources/dao/order_dao.dart';
import '../../features/order/data/datasources/dao/order_item_dao.dart';
import '../../features/order/data/datasources/table/order_item_table.dart';
import '../../features/order/data/datasources/table/order_table.dart';
import '../../features/product/data/datasources/dao/product_dao.dart';
import '../../features/product/data/datasources/table/product_table.dart';
import '../../features/user/data/datasources/dao/user_dao.dart';
import '../../features/user/data/datasources/table/user_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [ProductTable, UserTable, CartTable, OrderTable, OrderItemTable],
  daos: [ProductDao, UserDao, CartDao, OrderDao, OrderItemDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}

