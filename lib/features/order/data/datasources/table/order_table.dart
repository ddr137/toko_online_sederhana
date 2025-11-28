import 'package:drift/drift.dart';

class OrderTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerName => text()();
  TextColumn get customerRole => text()();
  TextColumn get customerPhone => text()();
  TextColumn get shippingAddress => text()();
  IntColumn get totalPrice => integer()();
  TextColumn get status => text()();
  TextColumn get paymentProofPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

