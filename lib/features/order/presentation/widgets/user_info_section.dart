import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';

class UserInfoSection extends StatelessWidget {
  final dynamic user;

  const UserInfoSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Pengiriman',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.md,
            UserInfoLine(label: 'Nama', value: user.name, context: context),
            UserInfoLine(label: 'Role', value: user.role, context: context),
            UserInfoLine(label: 'Telepon', value: user.phone, context: context),
            UserInfoLine(label: 'Alamat', value: user.address, context: context),
          ],
        ),
      ),
    );
  }
}

class UserInfoLine extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const UserInfoLine({
    super.key,
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label: $value',
        style: context.textTheme.bodyMedium,
      ),
    );
  }
}