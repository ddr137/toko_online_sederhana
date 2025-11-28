import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userDetailProvider.notifier).loadUserDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userDetailProvider);

    return userState.when(
      data: (user) {
        if (user == null) {
          return _buildDefaultNav();
        }

        if (user.role == 'cs1' || user.role == 'cs2') {
          return NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.receipt_long),
                label: 'Pesanan',
              ),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
            ],
            selectedIndex: widget.navigationShell.currentIndex >= 2
                ? widget.navigationShell.currentIndex - 2
                : 0,
            onDestinationSelected: (int index) {
              final actualIndex = index + 2;
              widget.navigationShell.goBranch(
                actualIndex,
                initialLocation: actualIndex == widget.navigationShell.currentIndex,
              );
            },
          );
        }

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
          icon: Icon(Icons.dashboard),
          label: 'Produk',
        ),
        NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
        NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
      ],
      selectedIndex: widget.navigationShell.currentIndex,
      onDestinationSelected: (int index) {
        widget.navigationShell.goBranch(
          index,
          initialLocation: index == widget.navigationShell.currentIndex,
        );
      },
    );
  }
}

