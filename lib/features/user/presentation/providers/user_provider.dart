import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toko_online_sederhana/core/di/providers.dart';
import 'package:toko_online_sederhana/features/user/data/datasources/user_local_datasource.dart';
import 'package:toko_online_sederhana/features/user/data/models/user_model.dart';
import 'package:toko_online_sederhana/features/user/data/repositories/user_repository.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
UserLocalDataSource userLocalDataSource(Ref ref) {
  final database = ref.read(appDatabaseProvider);
  final sharedPref = ref.read(sharedPreferencesClientProvider);

  return UserLocalDataSourceImpl(
    dao: database.userDao,
    sharedPreferencesClient: sharedPref,
  );
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  final local = ref.read(userLocalDataSourceProvider);
  return UserRepositoryImpl(local);
}

@riverpod
class UserListNotifier extends _$UserListNotifier {
  UserRepository get _repo => ref.read(userRepositoryProvider);

  @override
  AsyncValue<List<UserModel>> build() {
    return const AsyncValue.loading();
  }

  Future<bool> login(UserModel user) async {
    final ok = await _repo.login(user);
    // if (ok) await loadUsers(); // Removed to prevent UI rebuild which unmounts context in AuthPage
    return ok;
  }

  Future<void> loadUsers() async {
    state = const AsyncValue.loading();
    try {
      final users = await _repo.getUsers();
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSampleUsers() async {
    try {
      final existing = await _repo.getUsers();
      if (existing.isNotEmpty) return;
      final sampleUsers = [
        UserModel(
          name: 'Alice Smith',
          phone: '08123456789',
          address: '123 Main St',
          role: 'customer',
        ),
        UserModel(
          name: 'CS Layer 1',
          phone: '08987654321',
          address: '456 Elm St',
          role: 'cs1',
        ),
        UserModel(
          name: 'CS Layer 2',
          phone: '08765432198',
          address: '789 Oak St',
          role: 'cs2',
        ),
      ];
      for (final user in sampleUsers) {
        await _repo.createUser(user);
      }
      await loadUsers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
class UserDetailNotifier extends _$UserDetailNotifier {
  UserRepository get _repo => ref.read(userRepositoryProvider);

  @override
  AsyncValue<UserModel?> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadUserDetail() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.getUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> isLoggedIn() async {
    return _repo.isLoggedIn();
  }

  Future<bool> logout() async {
    final ok = await _repo.logout();
    if (ok) {
      state = const AsyncValue.data(null);
    }
    return ok;
  }
}
