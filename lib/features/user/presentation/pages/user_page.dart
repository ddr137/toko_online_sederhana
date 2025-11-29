import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toko_online_sederhana/core/enums/snack_bar_status_enum.dart';
import 'package:toko_online_sederhana/core/services/alarm_service.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/custom_snack_bar_ext.dart';
import 'package:toko_online_sederhana/shared/widgets/error_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/loading_widget.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  Duration? _selectedTestDuration = const Duration(hours: 24);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.onSurface,
      ),
      body: userState.when(
        loading: () => const LoadingWidget(message: 'Memuat profil...'),
        error: (err, _) => ErrorStateWidget(
          title: 'Gagal memuat profil',
          message: err.toString(),
          onRetry: () {
            ref.read(userDetailProvider.notifier).loadUserDetail();
          },
        ),
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.no_accounts_outlined,
                    size: 64,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.md,
                  Text(
                    'Tidak ada pengguna yang login',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.lg,
                  FilledButton(
                    onPressed: () => context.go('/auth'),
                    child: const Text('Login Sekarang'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AppSpacing.vertical(20),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.primary.withAlpha(51),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: context.colorScheme.primaryContainer,
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: context.textTheme.displayMedium?.copyWith(
                        color: context.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                AppSpacing.md,
                Text(
                  user.name,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.xs,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.role.toUpperCase(),
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                AppSpacing.vertical(AppGaps.xl),

                Card(
                  elevation: 0,
                  color: context.colorScheme.surfaceContainerHighest.withAlpha(
                    64,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: context.colorScheme.outlineVariant.withAlpha(64),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: context.colorScheme.primary,
                            ),
                            AppSpacing.sm,
                            Text(
                              'Informasi Pribadi',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(context, 'Nama Lengkap', user.name),
                        _buildInfoRow(context, 'Nomor Telepon', user.phone),
                        _buildInfoRow(context, 'Alamat', user.address),
                      ],
                    ),
                  ),
                ),

                AppSpacing.vertical(AppGaps.xl),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _testAutoCancelMechanism(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.bug_report),
                    label: const Text(
                      'Test Auto Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                AppSpacing.vertical(AppGaps.sm),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colorScheme.errorContainer,
                      foregroundColor: context.colorScheme.onErrorContainer,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Keluar Akun',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => context.pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.error,
                foregroundColor: context.colorScheme.onError,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final ok = await ref.read(userDetailProvider.notifier).logout();
      if (ok && context.mounted) {
        context.go('/auth');
      }
    }
  }

  Future<void> _testAutoCancelMechanism(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('Test Auto Cancel'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih durasi untuk membatalkan pesanan yang masih berstatus "MENUNGGU_UPLOAD_BUKTI":',
                  ),
                  AppSpacing.vertical(AppGaps.md),
                  DropdownButtonFormField<Duration>(
                    value: _selectedTestDuration,
                    decoration: InputDecoration(
                      labelText: 'Durasi Threshold',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: Duration(minutes: 1),
                        child: Text('1 Menit'),
                      ),
                      DropdownMenuItem(
                        value: Duration(minutes: 5),
                        child: Text('5 Menit'),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 1),
                        child: Text('1 Jam'),
                      ),
                      DropdownMenuItem(
                        value: Duration(hours: 24),
                        child: Text('24 Jam (Default)'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedTestDuration = value;
                      });
                    },
                  ),
                  AppSpacing.vertical(AppGaps.sm),
                  Text(
                    'Pesanan yang dibuat > ${_formatDuration(_selectedTestDuration!)} akan dibatalkan.',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () => context.pop(true),
                  child: const Text('Jalankan Test'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true && context.mounted) {
      try {
        await AlarmService().triggerManualCheck(
          threshold: _selectedTestDuration,
        );
        if (context.mounted) {
          context.showSnackBar(
            'Pengecekan berhasil (threshold: ${_formatDuration(_selectedTestDuration!)})',
            status: SnackBarStatus.success,
          );
        }
      } catch (e) {
        if (context.mounted) {
          context.showSnackBar(
            'Error: ${e.toString()}',
            status: SnackBarStatus.error,
          );
        }
      }
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} hari';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} jam';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} menit';
    } else {
      return '${duration.inSeconds} detik';
    }
  }
}
