import 'package:toko_online_sederhana/core/clients/storage/local_storage_helper.dart';
import 'package:toko_online_sederhana/core/clients/storage/shared_preferences_client.dart';
import 'package:toko_online_sederhana/features/user/data/datasources/dao/user_dao.dart';
import 'package:toko_online_sederhana/features/user/data/models/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel?> getUserById(int id);
  Future<List<UserModel>> getAllUsers();
  Future<int> insertUser(UserModel user);

  Future<bool> isLoggedIn();
  Future<bool> login(UserModel user);
  Future<bool> logout();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final UserDao _dao;
  final SharedPreferencesClient _sharedPreferencesClient;

  UserLocalDataSourceImpl({
    required UserDao dao,
    required SharedPreferencesClient sharedPreferencesClient,
  }) : _dao = dao,
       _sharedPreferencesClient = sharedPreferencesClient;

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
  Future<bool> login(UserModel user) {
    return LocalStorageHelper.safeStorage<bool>(() async {
      await _sharedPreferencesClient.setInt('user_id', user.id!);
      return true;
    });
  }

  @override
  Future<bool> logout() {
    return LocalStorageHelper.safeStorage<bool>(() async {
      await _sharedPreferencesClient.clear();
      return true;
    });
  }

  @override
  Future<bool> isLoggedIn() {
    return LocalStorageHelper.safeStorage<bool>(() async {
      "masuk sini cojk";
      final id = await _sharedPreferencesClient.getInt('user_id');
      return id != null;
    });
  }
}
