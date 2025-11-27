import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.restaurant_menu),
          label: 'Product',
        ),
        NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Orders'),
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
