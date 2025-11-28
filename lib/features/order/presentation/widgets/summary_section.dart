import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';

class SummarySection extends StatelessWidget {
  final int total;

  const SummarySection({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 0,
      color: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _line(
              context,
              label: "Total Bayar",
              value: "Rp $total",
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(
    BuildContext context, {
    required String label,
    required String value,
    bool isBold = false,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
