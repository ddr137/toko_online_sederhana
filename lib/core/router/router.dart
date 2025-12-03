import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/core/router/bottom_navigation_page.dart';
import 'package:toko_online_sederhana/features/cart/presentation/pages/cart_page.dart';
import 'package:toko_online_sederhana/features/order/presentation/pages/checkout_page.dart';
import 'package:toko_online_sederhana/features/order/presentation/pages/order_detail_page.dart';
import 'package:toko_online_sederhana/features/order/presentation/pages/order_page.dart';
import 'package:toko_online_sederhana/features/product/presentation/pages/product_detail_page.dart';
import 'package:toko_online_sederhana/features/product/presentation/pages/product_page.dart';
import 'package:toko_online_sederhana/features/user/presentation/pages/auth_page.dart';
import 'package:toko_online_sederhana/features/user/presentation/pages/user_page.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';

import 'custom_route_observer.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  observers: [CustomRouteObserver()],
  debugLogDiagnostics: true,
  initialLocation: '/auth',
  redirect: (context, state) async {
    try {
      final container = ProviderScope.containerOf(context);
      final user = await container.read(userRepositoryProvider).isLoggedIn();

      final loggingIn = state.matchedLocation == '/auth';

      if (!user) return loggingIn ? null : '/auth';
      if (user && loggingIn) return '/products';

      return null;
    } catch (e) {
      debugPrint('⚠️ Router redirect error: $e');
      return '/auth';
    }
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNav(navigationShell: navigationShell),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/products',
              name: 'products',
              builder: (context, state) => const ProductPage(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              name: 'cart',
              builder: (context, state) => const CartPage(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              name: 'orders',
              builder: (context, state) => const OrderPage(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/user',
              name: 'user',
              builder: (context, state) {
                return UserPage();
              },
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),

    GoRoute(
      path: '/product-detail/:id',
      name: 'product-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailPage(productId: id);
      },
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/order-detail/:id',
      name: 'order-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OrderDetailPage(orderId: id);
      },
    ),
  ],
);

GoRouter get goRouter => _goRouter;
