import 'package:drift/drift.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';

import '../table/user_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [UserTable])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<List<UserTableData>> getAll() {
    return select(userTable).get();
  }

  Future<UserTableData?> findById(int id) {
    return (select(userTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insert(UserTableCompanion entry) {
    return into(userTable).insert(entry);
  }
}
