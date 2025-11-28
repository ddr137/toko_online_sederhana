import 'package:drift/drift.dart';

class CartTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer()();
  IntColumn get quantity => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
