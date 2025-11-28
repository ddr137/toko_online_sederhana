// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderLocalDataSource)
const orderLocalDataSourceProvider = OrderLocalDataSourceProvider._();

final class OrderLocalDataSourceProvider
    extends
        $FunctionalProvider<
          OrderLocalDataSource,
          OrderLocalDataSource,
          OrderLocalDataSource
        >
    with $Provider<OrderLocalDataSource> {
  const OrderLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<OrderLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrderLocalDataSource create(Ref ref) {
    return orderLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderLocalDataSource>(value),
    );
  }
}

String _$orderLocalDataSourceHash() =>
    r'5530fd1a359ca9192920339ff272d23b2ae2512b';

@ProviderFor(orderRepository)
const orderRepositoryProvider = OrderRepositoryProvider._();

final class OrderRepositoryProvider
    extends
        $FunctionalProvider<OrderRepository, OrderRepository, OrderRepository>
    with $Provider<OrderRepository> {
  const OrderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderRepository create(Ref ref) {
    return orderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRepository>(value),
    );
  }
}

String _$orderRepositoryHash() => r'79e5dbd60a5f741ca79827c1515d61a5666d808a';

@ProviderFor(OrderNotifier)
const orderProvider = OrderNotifierProvider._();

final class OrderNotifierProvider
    extends $NotifierProvider<OrderNotifier, AsyncValue<List<OrderModel>>> {
  const OrderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderNotifierHash();

  @$internal
  @override
  OrderNotifier create() => OrderNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<OrderModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<OrderModel>>>(value),
    );
  }
}

String _$orderNotifierHash() => r'14c80198a776f591f0f69a64fdf339cda83a9669';

abstract class _$OrderNotifier extends $Notifier<AsyncValue<List<OrderModel>>> {
  AsyncValue<List<OrderModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<OrderModel>>, AsyncValue<List<OrderModel>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<OrderModel>>,
                AsyncValue<List<OrderModel>>
              >,
              AsyncValue<List<OrderModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OrderDetailNotifier)
const orderDetailProvider = OrderDetailNotifierFamily._();

final class OrderDetailNotifierProvider
    extends $NotifierProvider<OrderDetailNotifier, AsyncValue<OrderModel?>> {
  const OrderDetailNotifierProvider._({
    required OrderDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderDetailNotifierHash();

  @override
  String toString() {
    return r'orderDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrderDetailNotifier create() => OrderDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<OrderModel?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<OrderModel?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderDetailNotifierHash() =>
    r'deeb6e75e8362c4219b229a4737fdc7221713464';

final class OrderDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          OrderDetailNotifier,
          AsyncValue<OrderModel?>,
          AsyncValue<OrderModel?>,
          AsyncValue<OrderModel?>,
          String
        > {
  const OrderDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'orderDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderDetailNotifierProvider call(String orderId) =>
      OrderDetailNotifierProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderDetailProvider';
}

abstract class _$OrderDetailNotifier
    extends $Notifier<AsyncValue<OrderModel?>> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  AsyncValue<OrderModel?> build(String orderId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<OrderModel?>, AsyncValue<OrderModel?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OrderModel?>, AsyncValue<OrderModel?>>,
              AsyncValue<OrderModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CheckoutNotifier)
const checkoutProvider = CheckoutNotifierProvider._();

final class CheckoutNotifierProvider
    extends $NotifierProvider<CheckoutNotifier, AsyncValue<CheckoutData>> {
  const CheckoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutNotifierHash();

  @$internal
  @override
  CheckoutNotifier create() => CheckoutNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CheckoutData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CheckoutData>>(value),
    );
  }
}

String _$checkoutNotifierHash() => r'9d415a000b87cae07746de6e30fb2f68d39907d7';

abstract class _$CheckoutNotifier extends $Notifier<AsyncValue<CheckoutData>> {
  AsyncValue<CheckoutData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<CheckoutData>, AsyncValue<CheckoutData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CheckoutData>, AsyncValue<CheckoutData>>,
              AsyncValue<CheckoutData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
