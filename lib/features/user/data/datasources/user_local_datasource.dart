import 'package:toko_online_sederhana/features/user/data/datasources/dao/user_dao.dart';
import 'package:toko_online_sederhana/features/user/data/models/user_model.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(int id);
  Future<int> insertUser(UserModel user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final UserDao _dao;

  UserLocalDataSourceImpl(this._dao);

  @override
  Future<List<UserModel>> getAllUsers() async {
    final rows = await _dao.getAll();
    return rows.map(UserModel.fromDrift).toList();
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    final row = await _dao.findById(id);
    return row == null ? null : UserModel.fromDrift(row);
  }

  @override
  Future<int> insertUser(UserModel user) {
    return _dao.insert(user.toCompanion());
  }
}
