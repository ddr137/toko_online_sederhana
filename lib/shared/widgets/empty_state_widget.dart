import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, AppSpacing.lg],
            Text(
              title,
              style: context.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              AppSpacing.sm,
              Text(
                subtitle!,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[AppSpacing.lg, action!],
          ],
        ),
      ),
    );
  }
}

