import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/currency_ext.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const OrderItem({super.key, required this.order, this.onTap, this.onDelete});

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toUpperCase()) {
      case 'MENUNGGU_UPLOAD_BUKTI':
        return context.colorScheme.error;
      case 'MENUNGGU_VERIFIKASI_CS1':
      case 'MENUNGGU_VERIFIKASI_CS2':
        return context.colorScheme.tertiary;
      case 'SEDANG_DIPROSES':
        return Colors.orange;
      case 'DIKIRIM':
        return Colors.blue;
      case 'SELESAI':
        return context.colorScheme.primary;
      case 'DIBATALKAN':
        return context.colorScheme.outline;
      default:
        return context.colorScheme.outline;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'MENUNGGU_UPLOAD_BUKTI':
        return 'Menunggu Upload Bukti';
      case 'MENUNGGU_VERIFIKASI_CS1':
        return 'Menunggu Verifikasi CS1';
      case 'MENUNGGU_VERIFIKASI_CS2':
        return 'Menunggu Verifikasi CS2';
      case 'SEDANG_DIPROSES':
        return 'Sedang Diproses';
      case 'DIKIRIM':
        return 'Dikirim';
      case 'SELESAI':
        return 'Selesai';
      case 'DIBATALKAN':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: context.colorScheme.primaryContainer.withAlpha(64),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        AppSpacing.xs,
                        Text(
                          order.customerRole,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        context,
                        order.status,
                      ).withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(
                          context,
                          order.status,
                        ).withAlpha(51),
                      ),
                    ),
                    child: Text(
                      _getStatusText(order.status),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(context, order.status),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.sm,
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.xs,
                  Text(
                    order.customerPhone,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              AppSpacing.xs,
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.xs,
                  Expanded(
                    child: Text(
                      order.shippingAddress,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              AppSpacing.sm,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.totalPrice.currencyFormatRp,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




