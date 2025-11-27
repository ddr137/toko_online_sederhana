import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_online_sederhana/features/user/data/models/user_model.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ref
                    .read(userProvider.notifier)
                    .addUser(
                      UserModel(
                        name: 'Satria',
                        role: 'pembeli',
                        phone: '08123456789',
                        address: 'Jl. Satria No. 1',
                      ),
                    );
              },
              child: const Text('Pembeli'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(userProvider.notifier)
                    .addUser(
                      UserModel(
                        name: 'CS Layer 1',
                        role: 'cs',
                        phone: '08123456789',
                        address: 'Jl. Satria No. 1',
                      ),
                    );
              },
              child: const Text('CS Layer 1'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(userProvider.notifier)
                    .addUser(
                      UserModel(
                        name: 'CS Layer 2',
                        role: 'cs',
                        phone: '08123456789',
                        address: 'Jl. Satria No. 1',
                      ),
                    );
              },
              child: const Text('CS Layer 2'),
            ),
          ],
        ),
      ),
    );
  }
}
