import 'package:flutter/material.dart';
import '../extensions/context_ext.dart';
import '../../core/utils/spacing.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final double? size;

  const LoadingWidget({
    super.key,
    this.message,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? 24,
            height: size ?? 24,
            child: const CircularProgressIndicator(),
          ),
          if (message != null) ...[
            AppSpacing.md,
            Text(
              message!,
              style: context.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
