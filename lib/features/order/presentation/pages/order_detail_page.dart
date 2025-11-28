import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_online_sederhana/core/enums/snack_bar_status_enum.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';
import 'package:toko_online_sederhana/features/order/presentation/providers/order_provider.dart';
import 'package:toko_online_sederhana/features/order/presentation/services/invoice_service.dart';
import 'package:toko_online_sederhana/features/user/presentation/providers/user_provider.dart';
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
  bool _isDownloadingInvoice = false;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _downloadInvoice(OrderModel order) async {
    if (_isDownloadingInvoice) return;

    setState(() {
      _isDownloadingInvoice = true;
    });

    try {
      await InvoiceService.saveInvoice(order);

      if (mounted) {
        context.showSnackBar(
          'Invoice berhasil dibagikan!',
          status: SnackBarStatus.success,
        );
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar(
          'Gagal mengunduh invoice: ${e.toString()}',
          status: SnackBarStatus.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloadingInvoice = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderDetailState = ref.watch(orderDetailProvider(widget.orderId));
    final order = orderDetailState.asData?.value;
    final userState = ref.watch(userDetailProvider);
    final isCs1 = userState.value?.role == 'cs1';
    final isCs2 = userState.value?.role == 'cs2';

    return Scaffold(
      bottomNavigationBar: _buildBottomBar(context, order, isCs1, isCs2),
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
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
                Card(
                  elevation: 0,
                  color: context.colorScheme.surfaceContainerHighest.withAlpha(
                    64,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: context.colorScheme.outlineVariant.withAlpha(64),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Pesanan',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        AppSpacing.vertical(AppGaps.sm),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
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
                        ),

                        AppSpacing.vertical(AppGaps.md),

                        _buildInfoRow(context, 'ID Pesanan', '#${order.id}'),
                        _buildInfoRow(
                          context,
                          'Tanggal',
                          '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} '
                              '${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}',
                        ),
                      ],
                    ),
                  ),
                ),

                AppSpacing.md,

                if (canUpload) ...[
                  Card(
                    elevation: 0,
                    color: context.colorScheme.primaryContainer.withAlpha(64),
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
                              AppSpacing.horizontal(AppGaps.sm),
                              Text(
                                'Informasi Transfer',
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.vertical(AppGaps.md),
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
                  AppSpacing.vertical(AppGaps.md),
                ],

                if (canUpload || hasUploadedProof) ...[
                  Card(
                    color: context.colorScheme.surfaceContainerHighest
                        .withAlpha(64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: context.colorScheme.outlineVariant.withAlpha(64),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bukti Transfer',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          AppSpacing.vertical(AppGaps.md),
                          if (hasUploadedProof) ...[
                            GestureDetector(
                              onTap: () => _showImagePreview(
                                context,
                                order.paymentProofPath!,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(order.paymentProofPath!),
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      color: context
                                          .colorScheme
                                          .surfaceContainerHighest,
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
                                            AppSpacing.vertical(AppGaps.sm),
                                            Text(
                                              'Gambar tidak dapat dimuat',
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: context.colorScheme.primary,
                                ),
                                AppSpacing.horizontal(AppGaps.sm),
                                Text(
                                  'Bukti transfer telah diupload',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.colorScheme.outlineVariant,
                                  style: BorderStyle.solid,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.upload_file_outlined,
                                    size: 48,
                                    color: context.colorScheme.primary,
                                  ),
                                  AppSpacing.vertical(AppGaps.sm),
                                  Text(
                                    'Belum ada bukti transfer',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: context
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (canUpload) ...[
                            AppSpacing.vertical(AppGaps.md),
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
                  AppSpacing.vertical(AppGaps.md),
                ],

                if (order.items != null && order.items!.isNotEmpty) ...[
                  Card(
                    elevation: 0,
                    color: context.colorScheme.surfaceContainerHighest
                        .withAlpha(76),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: context.colorScheme.outlineVariant.withAlpha(64),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Detail Barang',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          AppSpacing.vertical(AppGaps.md),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: order.items!.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 24),
                            itemBuilder: (context, index) {
                              final item = order.items![index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        AppSpacing.vertical(AppGaps.xs),
                                        Text(
                                          '${item.quantity} x ${item.price.currencyFormatRp}',
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                                color: context
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    (item.quantity * item.price)
                                        .currencyFormatRp,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: context.colorScheme.primary,
                                        ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.vertical(AppGaps.md),
                ],

                Card(
                  elevation: 0,
                  color: context.colorScheme.surfaceContainerHighest.withAlpha(
                    76,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: context.colorScheme.outlineVariant.withAlpha(64),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Data pembeli',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        AppSpacing.vertical(AppGaps.md),
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
                AppSpacing.vertical(AppGaps.md),

                Card(
                  elevation: 0,
                  color: context.colorScheme.surfaceContainerHighest.withAlpha(
                    76,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: context.colorScheme.outlineVariant.withAlpha(64),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ringkasan Pembayaran',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        AppSpacing.vertical(AppGaps.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Harga',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
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
                AppSpacing.vertical(AppGaps.lg),

                SizedBox(
                  width: double.infinity,
                  child: BaseButton(
                    onPressed: () => _downloadInvoice(order),
                    text: 'Unduh Invoice (PDF)',
                    isLoading: _isDownloadingInvoice,
                    icon: const Icon(Icons.download),
                  ),
                ),
                const SizedBox(height: 12),

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

  Widget? _buildBottomBar(
    BuildContext context,
    OrderModel? order,
    bool isCs1,
    bool isCs2,
  ) {
    if (order == null) return null;

    final userState = ref.watch(userDetailProvider);
    final isCustomer = userState.value?.role == 'customer';

    if (isCs1 && order.status == 'MENUNGGU_VERIFIKASI_CS1') {
      return _buildCs1BottomBar(context, order);
    }

    if (isCs2) {
      if (order.status == 'MENUNGGU_VERIFIKASI_CS2') {
        return _buildCs2BottomBar(
          context,
          order,
          'SEDANG_DIPROSES',
          'Proses Pesanan',
        );
      } else if (order.status == 'SEDANG_DIPROSES') {
        return _buildCs2BottomBar(context, order, 'DIKIRIM', 'Kirim Pesanan');
      } else if (order.status == 'DIKIRIM') {
        return _buildCs2BottomBar(
          context,
          order,
          'SELESAI',
          'Selesaikan Pesanan',
        );
      }
    }

    if (isCustomer && order.status == 'DIKIRIM') {
      return _buildCustomerBottomBar(context, order);
    }

    return null;
  }

  Widget _buildCs1BottomBar(BuildContext context, OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _handleCancel(context, order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.colorScheme.error,
                  side: BorderSide(color: context.colorScheme.error),
                ),
                child: const Text('Batalkan'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: () => _handleConfirm(context, order),
                style: FilledButton.styleFrom(
                  backgroundColor: context.colorScheme.primary,
                ),
                child: const Text('Konfirmasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCs2BottomBar(
    BuildContext context,
    OrderModel order,
    String nextStatus,
    String buttonText,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => _handleStatusUpdate(context, order, nextStatus),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
            ),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerBottomBar(BuildContext context, OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => _handleStatusUpdate(context, order, 'SELESAI'),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
            ),
            child: const Text('Pesanan Diterima'),
          ),
        ),
      ),
    );
  }

  void _handleStatusUpdate(
    BuildContext context,
    OrderModel order,
    String nextStatus,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status Pesanan'),
        content: Text(
          'Apakah Anda yakin ingin mengubah status pesanan menjadi "$nextStatus"?',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              ref
                  .read(orderDetailProvider(widget.orderId).notifier)
                  .updateOrderStatus(nextStatus);
            },
            child: const Text('Ya, Update'),
          ),
        ],
      ),
    );
  }

  void _handleConfirm(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pesanan'),
        content: Text(
          'Apakah Anda yakin ingin mengkonfirmasi pesanan "${order.customerName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              ref
                  .read(orderDetailProvider(widget.orderId).notifier)
                  .updateOrderStatus('MENUNGGU_VERIFIKASI_CS2');
            },
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(color: Colors.black87),
              ),
            ),
            InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4,
              child: Image.file(File(imagePath), fit: BoxFit.contain),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                style: IconButton.styleFrom(backgroundColor: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCancel(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan'),
        content: Text(
          'Apakah Anda yakin ingin membatalkan pesanan "${order.customerName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Kembali'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              ref
                  .read(orderDetailProvider(widget.orderId).notifier)
                  .updateOrderStatus('DIBATALKAN');
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            child: const Text('Batalkan Pesanan'),
          ),
        ],
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
          AppSpacing.vertical(AppGaps.xs),
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
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.vertical(AppGaps.xs),
                Text(
                  displayValue,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (canCopy) ...[
            AppSpacing.horizontal(AppGaps.sm),
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
