
import 'package:toko_online_sederhana/features/user/data/datasources/user_local_datasource.dart';

import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getUser(int id);
  Future<int> createUser(UserModel user);
  Future<bool> deleteUser(int id);
}

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _local;

  UserRepositoryImpl(this._local);

  @override
  Future<UserModel?> getUser(int id) {
    return _local.getUserById(id);
  }

  @override
  Future<int> createUser(UserModel user) {
    return _local.insertUser(user);
  }

  @override
  Future<bool> deleteUser(int id) {
    return _local.deleteUser(id);
  }
}
