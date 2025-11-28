
import 'package:toko_online_sederhana/features/user/data/datasources/user_local_datasource.dart';

import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser();
  Future<List<UserModel>> getUsers();
  Future<int> createUser(UserModel user);

  Future<bool> isLoggedIn();
  Future<bool> login(UserModel user);
  Future<bool> logout();
}

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _local;

  UserRepositoryImpl(this._local);

  @override
  Future<UserModel> getUser() {
    return _local.getUserById();
  }

  @override
  Future<List<UserModel>> getUsers() {
    return _local.getAllUsers();
  }

  @override
  Future<int> createUser(UserModel user) {
    return _local.insertUser(user);
  }

  @override
  Future<bool> isLoggedIn() {
    return _local.isLoggedIn();
  }

  @override
  Future<bool> login(UserModel user) {
    return _local.login(user);
  }

  @override
  Future<bool> logout() {
    return _local.logout();
  }
}

