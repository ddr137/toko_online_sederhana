import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';

class BaseButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isTextButton;
  final Widget? icon;
  final double? width;
  final double? height;

  const BaseButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isTextButton = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final child = _buildChild();

    if (isTextButton) {
      return TextButton(onPressed: isLoading ? null : onPressed, child: child);
    }

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: child,
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon!, AppSpacing.sm, Text(text)],
      );
    }

    return Text(text);
  }
}

