import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';

class PaymentMethodSection extends StatefulWidget {
  const PaymentMethodSection({super.key});

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  String _selectedPaymentMethod = 'transfer';

  final List<Map<String, String>> _paymentMethods = [
    {
      'value': 'transfer',
      'title': 'Transfer Bank',
      'description': 'BCA, Mandiri, BNI, BRI',
      'icon': 'account_balance',
    },
    {
      'value': 'ewallet',
      'title': 'E-Wallet',
      'description': 'GoPay, OVO, DANA, ShopeePay',
      'icon': 'account_balance_wallet',
    },
    {
      'value': 'cod',
      'title': 'Cash on Delivery (COD)',
      'description': 'Bayar saat barang sampai',
      'icon': 'local_shipping',
    },
    {
      'value': 'qris',
      'title': 'QRIS',
      'description': 'Scan QR untuk pembayaran',
      'icon': 'qr_code',
    },
  ];

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
              'Metode Pembayaran',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.md,
            ..._paymentMethods.map((method) => PaymentOption(
              value: method['value']!,
              title: method['title']!,
              description: method['description']!,
              icon: method['icon']!,
              isSelected: _selectedPaymentMethod == method['value'],
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = method['value']!;
                });
              },
            )),
          ],
        ),
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final String value;
  final String title;
  final String description;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.value,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? context.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              _getIconData(icon),
              size: 24,
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.md,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurface,
                    ),
                  ),
                  AppSpacing.xs,
                  Text(
                    description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: isSelected ? value : null,
              onChanged: (_) => onTap(),
              activeColor: context.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'account_balance':
        return Icons.account_balance;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'qr_code':
        return Icons.qr_code;
      default:
        return Icons.payment;
    }
  }
}
