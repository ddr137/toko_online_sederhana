// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
        isAutoDispose: false,
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
    r'4d330a8df61ce0f30402cef89b56a42f5725e537';

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
        isAutoDispose: false,
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

String _$productRepositoryHash() => r'67f583c29bc1400b9982b39510ed11c99c4583d2';

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

String _$productNotifierHash() => r'becfe309acd7f3c069fbf0839d6e28b1dd032c37';

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

@ProviderFor(ProductDetailNotifier)
const productDetailProvider = ProductDetailNotifierFamily._();

final class ProductDetailNotifierProvider
    extends
        $NotifierProvider<ProductDetailNotifier, AsyncValue<ProductModel?>> {
  const ProductDetailNotifierProvider._({
    required ProductDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailNotifierHash();

  @override
  String toString() {
    return r'productDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProductDetailNotifier create() => ProductDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ProductModel?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ProductModel?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailNotifierHash() =>
    r'28368caea5c59bf0902d323d62d7228a406b2e5d';

final class ProductDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductDetailNotifier,
          AsyncValue<ProductModel?>,
          AsyncValue<ProductModel?>,
          AsyncValue<ProductModel?>,
          String
        > {
  const ProductDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'productDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductDetailNotifierProvider call(String productId) =>
      ProductDetailNotifierProvider._(argument: productId, from: this);

  @override
  String toString() => r'productDetailProvider';
}

abstract class _$ProductDetailNotifier
    extends $Notifier<AsyncValue<ProductModel?>> {
  late final _$args = ref.$arg as String;
  String get productId => _$args;

  AsyncValue<ProductModel?> build(String productId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<ProductModel?>, AsyncValue<ProductModel?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProductModel?>, AsyncValue<ProductModel?>>,
              AsyncValue<ProductModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
