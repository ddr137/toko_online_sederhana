import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toko_online_sederhana/di.dart';
import 'package:toko_online_sederhana/features/user/data/datasources/user_local_datasource.dart';
import 'package:toko_online_sederhana/features/user/data/models/user_model.dart';
import 'package:toko_online_sederhana/features/user/data/repositories/user_repository.dart';

part 'user_provider.g.dart';

@riverpod
UserLocalDataSource userLocalDataSource(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return UserLocalDataSourceImpl(database.userDao);
}

@riverpod
UserRepository userRepository(Ref ref) {
  final localDataSource = ref.watch(userLocalDataSourceProvider);
  return UserRepositoryImpl(localDataSource);
}

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  AsyncValue<List<UserModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadUsers() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(userRepositoryProvider);
      final users = await repository.getUsers(); // This method might need to be added to the repository
      state = AsyncValue.data(users);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshUsers() async {
    await loadUsers();
  }

  Future<void> addUser(UserModel user) async {
    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.createUser(user);

      // Refresh the users list to include the new user
      await loadUsers();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

}

@riverpod
class UserDetailNotifier extends _$UserDetailNotifier {
  @override
  AsyncValue<UserModel?> build(String userId) {
    return const AsyncValue.loading();
  }

  Future<void> loadUserDetail() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(userRepositoryProvider);
      final user = await repository.getUser(int.parse(userId));
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
