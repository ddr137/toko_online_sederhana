import 'package:toko_online_sederhana/features/user/data/datasources/dao/user_dao.dart';
import 'package:toko_online_sederhana/features/user/data/models/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel?> getUserById(int id);
  Future<List<UserModel>> getAllUsers();
  Future<int> insertUser(UserModel user);
  Future<bool> deleteUser(int id);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final UserDao _dao;

  UserLocalDataSourceImpl(this._dao);

  @override
  Future<UserModel?> getUserById(int id) async {
    final row = await _dao.findById(id);
    return row == null ? null : UserModel.fromDrift(row);
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final rows = await _dao.getAll();
    return rows.map((row) => UserModel.fromDrift(row)).toList();
  }

  @override
  Future<int> insertUser(UserModel user) {
    return _dao.insert(user.toCompanion());
  }

  @override
  Future<bool> deleteUser(int id) async {
    return await _dao.deleteUser(id) > 0;
  }
}
