import 'package:drift/drift.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';

import '../table/user_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [UserTable])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<UserTableData?> findById(int id) {
    return (select(userTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<UserTableData>> getAll() {
    return select(userTable).get();
  }

  Future<int> insert(UserTableCompanion entry) {
    return into(userTable).insert(entry);
  }

  Future<int> deleteUser(int id) {
    return (delete(userTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}

