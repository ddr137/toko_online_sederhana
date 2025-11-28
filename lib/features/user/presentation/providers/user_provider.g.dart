// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userLocalDataSource)
const userLocalDataSourceProvider = UserLocalDataSourceProvider._();

final class UserLocalDataSourceProvider
    extends
        $FunctionalProvider<
          UserLocalDataSource,
          UserLocalDataSource,
          UserLocalDataSource
        >
    with $Provider<UserLocalDataSource> {
  const UserLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<UserLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserLocalDataSource create(Ref ref) {
    return userLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserLocalDataSource>(value),
    );
  }
}

String _$userLocalDataSourceHash() =>
    r'1b1a71c17773ecf507e039e4214475c29e1195ae';

@ProviderFor(userRepository)
const userRepositoryProvider = UserRepositoryProvider._();

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  const UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'9b2d38158b6a3163ae1fafab6cdc10d13c96bec7';

@ProviderFor(UserListNotifier)
const userListProvider = UserListNotifierProvider._();

final class UserListNotifierProvider
    extends $NotifierProvider<UserListNotifier, AsyncValue<List<UserModel>>> {
  const UserListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userListNotifierHash();

  @$internal
  @override
  UserListNotifier create() => UserListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<UserModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<UserModel>>>(value),
    );
  }
}

String _$userListNotifierHash() => r'ca86e1752fa6c76fe48476c472d9c29c05bf5765';

abstract class _$UserListNotifier
    extends $Notifier<AsyncValue<List<UserModel>>> {
  AsyncValue<List<UserModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<UserModel>>, AsyncValue<List<UserModel>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UserModel>>,
                AsyncValue<List<UserModel>>
              >,
              AsyncValue<List<UserModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UserDetailNotifier)
const userDetailProvider = UserDetailNotifierProvider._();

final class UserDetailNotifierProvider
    extends $NotifierProvider<UserDetailNotifier, AsyncValue<UserModel?>> {
  const UserDetailNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDetailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDetailNotifierHash();

  @$internal
  @override
  UserDetailNotifier create() => UserDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<UserModel?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<UserModel?>>(value),
    );
  }
}

String _$userDetailNotifierHash() =>
    r'b9ff981b65496ee3db680bd953f645a91f962f6e';

abstract class _$UserDetailNotifier extends $Notifier<AsyncValue<UserModel?>> {
  AsyncValue<UserModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<UserModel?>, AsyncValue<UserModel?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserModel?>, AsyncValue<UserModel?>>,
              AsyncValue<UserModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
