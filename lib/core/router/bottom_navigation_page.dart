import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userDetailProvider);

    return userState.when(
      data: (user) {
        if (user == null) {
          // If no user, show default navigation
          return _buildDefaultNav();
        }

        // CS1 and CS2: Only Orders and Profile
        if (user.role == 'cs1' || user.role == 'cs2') {
          return NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.receipt_long),
                label: 'Orders',
              ),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
            selectedIndex: navigationShell.currentIndex >= 2
                ? navigationShell.currentIndex - 2
                : 0,
            onDestinationSelected: (int index) {
              // Map to actual branch index (Orders=2, Profile=3)
              final actualIndex = index + 2;
              navigationShell.goBranch(
                actualIndex,
                initialLocation: actualIndex == navigationShell.currentIndex,
              );
            },
          );
        }

        // Customer: All tabs (Product, Cart, Orders, Profile)
        return _buildDefaultNav();
      },
      loading: () => _buildDefaultNav(),
      error: (_, __) => _buildDefaultNav(),
    );
  }

  Widget _buildDefaultNav() {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.restaurant_menu),
          label: 'Product',
        ),
        NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Orders'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (int index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
    );
  }
}
