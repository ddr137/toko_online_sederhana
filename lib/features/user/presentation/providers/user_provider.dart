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
      final users = await repository.getUsers();
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

      await loadUsers();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSampleUsers() async {
    try {
      final repository = ref.read(userRepositoryProvider);

      final existing = await repository.getUsers();
      if (existing.isNotEmpty) {
        return;
      }

      final sampleUsers = [
        UserModel(
          name: 'Alice Smith',
          phone: '08123456789',
          address: '123 Main St',
          role: 'customer',
        ),
        UserModel(
          name: 'CS 1',
          phone: '08987654321',
          address: '456 Elm St',
          role: 'cs1',
        ),
        UserModel(
          name: 'CS 2',
          phone: '08765432198',
          address: '789 Oak St',
          role: 'cs2',
        ),
      ];

      for (final user in sampleUsers) {
        await repository.createUser(user);
      }

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
