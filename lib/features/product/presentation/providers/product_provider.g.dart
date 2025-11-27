// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductNotifier)
const productProvider = ProductNotifierProvider._();

final class ProductNotifierProvider
    extends $NotifierProvider<ProductNotifier, AsyncValue<List<ProductModel>>> {
  const ProductNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productNotifierHash();

  @$internal
  @override
  ProductNotifier create() => ProductNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ProductModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<ProductModel>>>(
        value,
      ),
    );
  }
}

String _$productNotifierHash() => r'b12172960cd522314d038ea6d7dd4862507c67c5';

abstract class _$ProductNotifier
    extends $Notifier<AsyncValue<List<ProductModel>>> {
  AsyncValue<List<ProductModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ProductModel>>,
              AsyncValue<List<ProductModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ProductModel>>,
                AsyncValue<List<ProductModel>>
              >,
              AsyncValue<List<ProductModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(productLocalDataSource)
const productLocalDataSourceProvider = ProductLocalDataSourceProvider._();

final class ProductLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ProductLocalDataSource,
          ProductLocalDataSource,
          ProductLocalDataSource
        >
    with $Provider<ProductLocalDataSource> {
  const ProductLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProductLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductLocalDataSource create(Ref ref) {
    return productLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductLocalDataSource>(value),
    );
  }
}

String _$productLocalDataSourceHash() =>
    r'2e629270fcb3f40e97126a8b70811a9ea1f4e485';

@ProviderFor(productRepository)
const productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepository,
          ProductRepository,
          ProductRepository
        >
    with $Provider<ProductRepository> {
  const ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'8001919b778d2353320eeab6418c8f44e7691e06';
