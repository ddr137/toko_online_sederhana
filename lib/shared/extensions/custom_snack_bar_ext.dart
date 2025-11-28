import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/core/enums/snack_bar_status_enum.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarStatus status = SnackBarStatus.info,
  }) {
    late Color bg;
    late Color fg;

    switch (status) {
      case SnackBarStatus.error:
        bg = colorScheme.error;
        fg = colorScheme.onError;
        break;
      case SnackBarStatus.success:
        bg = colorScheme.primary;
        fg = colorScheme.onPrimary;
        break;
      case SnackBarStatus.warning:
        bg = colorScheme.tertiary;
        fg = colorScheme.onTertiary;
        break;
      case SnackBarStatus.info:
        bg = colorScheme.secondary;
        fg = colorScheme.onSecondary;
        break;
    }

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        duration: duration,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        backgroundColor: bg,
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: fg),
        ),
      ),
    );
  }
}
