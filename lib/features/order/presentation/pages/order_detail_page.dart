import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_online_sederhana/core/enums/snack_bar_status_enum.dart';
import 'package:toko_online_sederhana/features/order/presentation/providers/order_provider.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/copy_to_clipboard_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/currency_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/custom_snack_bar_ext.dart';
import 'package:toko_online_sederhana/shared/widgets/base_button.dart';
import 'package:toko_online_sederhana/shared/widgets/error_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/loading_widget.dart';

class OrderDetailPage extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  // Bank transfer information (hardcoded for demo)
  final String _bankName = 'Bank Central Asia (BCA)';
  final String _accountNumber = '1234567890';
  final String _accountName = 'PT Toko Online Sederhana';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderDetailProvider(widget.orderId).notifier).loadOrderDetail();
    });
  }

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

  Future<void> _pickAndUploadImage() async {
    if (_isUploading) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() {
        _isUploading = true;
      });

      final success = await ref
          .read(orderDetailProvider(widget.orderId).notifier)
          .uploadPaymentProof(image.path);

      if (mounted) {
        if (success) {
          context.showSnackBar(
            'Bukti transfer berhasil diupload!',
            status: SnackBarStatus.success,
          );
        } else {
          context.showSnackBar(
            'Gagal mengupload bukti transfer',
            status: SnackBarStatus.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar(
          'Terjadi kesalahan: ${e.toString()}',
          status: SnackBarStatus.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderDetailState = ref.watch(orderDetailProvider(widget.orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.onSurface,
      ),
      body: orderDetailState.when(
        loading: () => const LoadingWidget(message: 'Memuat detail pesanan...'),
        error: (error, stackTrace) => ErrorStateWidget(
          title: 'Terjadi kesalahan',
          message: error.toString(),
          onRetry: () {
            ref
                .read(orderDetailProvider(widget.orderId).notifier)
                .loadOrderDetail();
          },
        ),
        data: (order) {
          if (order == null) {
            return Center(
              child: Text(
                'Pesanan tidak ditemukan',
                style: context.textTheme.bodyLarge,
              ),
            );
          }

          final canUpload =
              order.status.toUpperCase() == 'MENUNGGU_UPLOAD_BUKTI';
          final hasUploadedProof =
              order.paymentProofPath != null &&
              order.paymentProofPath!.isNotEmpty;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status Pesanan',
                              style: context.textTheme.titleMedium,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  context,
                                  order.status,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getStatusText(order.status),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: _getStatusColor(context, order.status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(context, 'ID Pesanan', '#${order.id}'),
                        _buildInfoRow(
                          context,
                          'Tanggal',
                          '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Bank Transfer Information (only show if waiting for upload)
                if (canUpload) ...[
                  Card(
                    color: context.colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance,
                                color: context.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Informasi Transfer',
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: context.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildCopyableRow(context, 'Bank', _bankName),
                          _buildCopyableRow(
                            context,
                            'No. Rekening',
                            _accountNumber,
                            canCopy: true,
                          ),
                          _buildCopyableRow(context, 'Atas Nama', _accountName),
                          _buildCopyableRow(
                            context,
                            'Nominal Transfer',
                            order.totalPrice.currencyFormatRp,
                            canCopy: true,
                            value: order.totalPrice.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Payment Proof Section
                if (canUpload || hasUploadedProof) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bukti Transfer',
                            style: context.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          if (hasUploadedProof) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(order.paymentProofPath!),
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: context.colorScheme.surfaceVariant,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image,
                                            size: 48,
                                            color: context
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Gambar tidak dapat dimuat',
                                            style: context.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bukti transfer telah diupload',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ] else ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.colorScheme.outline,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    size: 48,
                                    color: context.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Belum ada bukti transfer',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (canUpload) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: BaseButton(
                                onPressed: _pickAndUploadImage,
                                text: hasUploadedProof
                                    ? 'Ganti Bukti Transfer'
                                    : 'Upload Bukti Transfer',
                                isLoading: _isUploading,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Customer Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Pelanggan',
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(context, 'Nama', order.customerName),
                        _buildInfoRow(context, 'Role', order.customerRole),
                        _buildInfoRow(context, 'Telepon', order.customerPhone),
                        _buildInfoRow(
                          context,
                          'Alamat Pengiriman',
                          order.shippingAddress,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ringkasan Pembayaran',
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Harga',
                              style: context.textTheme.bodyLarge,
                            ),
                            Text(
                              order.totalPrice.currencyFormatRp,
                              style: context.textTheme.titleLarge?.copyWith(
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Back Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Kembali'),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildCopyableRow(
    BuildContext context,
    String label,
    String displayValue, {
    bool canCopy = false,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onPrimaryContainer.withOpacity(
                      0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayValue,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (canCopy) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                context.copyToClipboardAndShowSnackBar(value ?? displayValue);
              },
              icon: Icon(
                Icons.copy,
                size: 20,
                color: context.colorScheme.primary,
              ),
              tooltip: 'Salin',
            ),
          ],
        ],
      ),
    );
  }
}
