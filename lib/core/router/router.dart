import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/core/router/bottom_navigation_page.dart';
import 'package:toko_online_sederhana/features/auth/presentation/pages/auth_page.dart';
import 'package:toko_online_sederhana/features/product/presentation/pages/product_detail_page.dart';
import 'package:toko_online_sederhana/features/product/presentation/pages/product_page.dart';
import 'package:toko_online_sederhana/features/user/presentation/pages/user_page.dart';

import 'custom_route_observer.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  observers: [CustomRouteObserver()],
  debugLogDiagnostics: true,
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNav(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/product',
              name: 'product',
              builder: (context, state) => const ProductPage(),
            ),
            GoRoute(
              path: '/user/:id',
              name: 'user',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return UserPage(userId: id);
              },
            ),
          ],
        ),],
    ),

    GoRoute(
      path: '/product-detail/:id',
      name: 'product-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailPage(productId: id);
      },
    ),
  ],
);

GoRouter get goRouter => _goRouter;
