import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/widgets/empty_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/error_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/loading_widget.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userState = ref.read(userListProvider.notifier);
      await userState.addSampleUsers();
      await userState.loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Center(
        child: userState.when(
          loading: () => const LoadingWidget(message: 'Memuat data...'),
          error: (error, stackTrace) => ErrorStateWidget(
            title: 'Terjadi kesalahan',
            message: error.toString(),
            onRetry: () {
              ref.read(userListProvider.notifier).loadUsers();
            },
          ),
          data: (users) {
            if (users.isEmpty) {
              return EmptyStateWidget(
                title: 'Belum ada data',
                subtitle: 'Tambahkan data pertama Anda untuk memulai',
                icon: Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              );
            }

            return SizedBox(
              height: 380,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pilih user untuk masuk ke aplikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Setiap role memiliki tampilan menu yang berbeda.',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.vertical(20),

                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: ElevatedButton(
                              onPressed: () async {
                                final notifier = ref.read(
                                  userListProvider.notifier,
                                );

                                final ok = await notifier.login(user);
                                if (!ok) return;

                                if (!context.mounted) return;

                                switch (user.role.toLowerCase()) {
                                  case 'customer':
                                    context.go('/products');
                                    break;
                                  case 'cs1':
                                    context.go('/user');
                                    break;
                                  case 'cs2':
                                    context.go('/user');
                                    break;
                                  default:
                                    context.go('/products');
                                    break;
                                }
                              },
                              child: Text(
                                '${user.name} (${user.role.toUpperCase()})',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



