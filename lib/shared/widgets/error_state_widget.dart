import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final Widget? icon;

  const ErrorStateWidget({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              AppSpacing.lg,
            ] else
              Icon(
                Icons.error_outline,
                size: 64,
                color: context.colorScheme.error,
              ),
            AppSpacing.lg,
            Text(
              title,
              style: context.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.sm,
              Text(
                message!,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              AppSpacing.lg,
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

