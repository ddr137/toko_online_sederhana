// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cartLocalDataSource)
const cartLocalDataSourceProvider = CartLocalDataSourceProvider._();

final class CartLocalDataSourceProvider
    extends
        $FunctionalProvider<
          CartLocalDataSource,
          CartLocalDataSource,
          CartLocalDataSource
        >
    with $Provider<CartLocalDataSource> {
  const CartLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<CartLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CartLocalDataSource create(Ref ref) {
    return cartLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartLocalDataSource>(value),
    );
  }
}

String _$cartLocalDataSourceHash() =>
    r'591bbd4a986e359d9f936c475bbc582e6aab2216';

@ProviderFor(cartRepository)
const cartRepositoryProvider = CartRepositoryProvider._();

final class CartRepositoryProvider
    extends $FunctionalProvider<CartRepository, CartRepository, CartRepository>
    with $Provider<CartRepository> {
  const CartRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartRepositoryHash();

  @$internal
  @override
  $ProviderElement<CartRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartRepository create(Ref ref) {
    return cartRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartRepository>(value),
    );
  }
}

String _$cartRepositoryHash() => r'b0290e72ca3e6750f5d9452c182b22ed67f1ac4e';

@ProviderFor(CartNotifier)
const cartProvider = CartNotifierProvider._();

final class CartNotifierProvider
    extends $NotifierProvider<CartNotifier, AsyncValue<List<CartModel>>> {
  const CartNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartNotifierHash();

  @$internal
  @override
  CartNotifier create() => CartNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<CartModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<CartModel>>>(value),
    );
  }
}

String _$cartNotifierHash() => r'a14ac9a2f8042df5f2d05d2cea8027a67dadee6a';

abstract class _$CartNotifier extends $Notifier<AsyncValue<List<CartModel>>> {
  AsyncValue<List<CartModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<CartModel>>, AsyncValue<List<CartModel>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CartModel>>,
                AsyncValue<List<CartModel>>
              >,
              AsyncValue<List<CartModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
