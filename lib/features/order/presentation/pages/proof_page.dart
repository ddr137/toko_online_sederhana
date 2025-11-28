import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/cart/presentation/providers/cart_provider.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';
import 'package:toko_online_sederhana/features/order/presentation/providers/order_provider.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/copy_to_clipboard_ext.dart';
import 'package:toko_online_sederhana/shared/extensions/currency_ext.dart';
import 'package:toko_online_sederhana/shared/widgets/base_button.dart';
import 'package:toko_online_sederhana/shared/widgets/error_state_widget.dart';
import 'package:toko_online_sederhana/shared/widgets/loading_widget.dart';

class ProofPage extends ConsumerStatefulWidget {
  final String? orderId;

  const ProofPage({super.key, this.orderId});

  @override
  ConsumerState<ProofPage> createState() => _ProofPageState();
}

class _ProofPageState extends ConsumerState<ProofPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider);
    final ordersState = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Pembayaran'),
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.onSurface,
      ),
      body: _buildBody(checkoutState, ordersState),
    );
  }

  Widget _buildBody(AsyncValue checkoutState, AsyncValue ordersState) {
    // If orderId is provided, try to get specific order
    if (widget.orderId != null) {
      return _buildContentFromOrderId();
    }
    
    // Try to get data from checkout first (from checkout flow)
    if (checkoutState.hasValue && checkoutState.value != null) {
      final checkout = checkoutState.value!;
      return _buildContentFromCheckout(checkout);
    }
    
    // If no checkout data, try to get from orders (from order list flow)
    if (ordersState.hasValue && ordersState.value != null) {
      final orders = ordersState.value!;
      final pendingOrder = orders.firstWhere(
        (order) => order.status == 'MENUNGGU_UPLOAD_BUKTI',
        orElse: () => orders.first, // fallback to first order if no pending
      );
      return _buildContentFromOrder(pendingOrder);
    }
    
    // Loading state
    if (checkoutState.isLoading || ordersState.isLoading) {
      return const LoadingWidget(message: 'Memuat data...');
    }
    
    // Error state
    if (checkoutState.hasError) {
      return ErrorStateWidget(
        title: 'Terjadi kesalahan',
        message: checkoutState.error.toString(),
        onRetry: () {
          ref.read(checkoutProvider.notifier).loadCheckout();
        },
      );
    }
    
    if (ordersState.hasError) {
      return ErrorStateWidget(
        title: 'Terjadi kesalahan',
        message: ordersState.error.toString(),
        onRetry: () {
          ref.read(orderProvider.notifier).loadOrders();
        },
      );
    }
    
    // Default empty state
    return const Center(
      child: Text('Tidak ada data yang tersedia'),
    );
  }

  Widget _buildContentFromOrderId() {
    return Consumer(
      builder: (context, ref, child) {
        final ordersState = ref.watch(orderProvider);
        
        return ordersState.when(
          loading: () => const LoadingWidget(message: 'Memuat data order...'),
          error: (error, stackTrace) => ErrorStateWidget(
            title: 'Terjadi kesalahan',
            message: error.toString(),
            onRetry: () {
              ref.read(orderProvider.notifier).loadOrders();
            },
          ),
          data: (orders) {
            final order = orders.firstWhere(
              (order) => order.id.toString() == widget.orderId,
              orElse: () => orders.firstWhere(
                (order) => order.status == 'MENUNGGU_UPLOAD_BUKTI',
                orElse: () => orders.first,
              ),
            );
            return _buildContentFromOrder(order);
          },
        );
      },
    );
  }

  Widget _buildContentFromCheckout(dynamic checkout) {
    return Consumer(
      builder: (context, ref, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transfer Information Section
                TransferInfoSection(
                  totalAmount: ref.read(cartProvider.notifier).getTotalPrice(),
                ),
                AppSpacing.lg,

                // Payment Proof Form Section
                PaymentProofForm(
                  selectedImage: _selectedImage,
                  onImagePicked: _pickImage,
                  isUploading: _isUploading,
                ),
                AppSpacing.lg,

                // Submit Button
                BaseButton(
                  text: _isUploading ? 'Mengirim...' : 'Kirim Bukti Pembayaran',
                  width: double.infinity,
                  onPressed: _isUploading ? null : () {
                    if (_selectedImage != null) {
                      _submitPaymentProof();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silakan upload bukti transfer terlebih dahulu'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentFromOrder(OrderModel order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transfer Information Section
            TransferInfoSectionFromOrder(
              order: order,
            ),
            AppSpacing.lg,

            // Payment Proof Form Section
            PaymentProofForm(
              selectedImage: _selectedImage,
              onImagePicked: _pickImage,
              isUploading: _isUploading,
            ),
            AppSpacing.lg,

            // Submit Button
            BaseButton(
              text: _isUploading ? 'Mengirim...' : 'Kirim Bukti Pembayaran',
              width: double.infinity,
              onPressed: _isUploading ? null : () {
                if (_selectedImage != null) {
                  _submitPaymentProofFromOrder(order);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Silakan upload bukti transfer terlebih dahulu'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitPaymentProof() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // TODO: Upload image to server and associate with order
      // For now, we'll just simulate the upload
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Update order status from MENUNGGU_UPLOAD_BUKTI to MENUNGGU_VALIDASI
      // For now, we'll just show success message

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bukti pembayaran berhasil dikirim!'),
          backgroundColor: Colors.green,
        ),
      );

      context.pushReplacement('/orders');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim bukti pembayaran: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _submitPaymentProofFromOrder(OrderModel order) async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // TODO: Upload image to server and associate with order
      // For now, we'll just simulate the upload
      await Future.delayed(const Duration(seconds: 2));

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      // Update order status from MENUNGGU_UPLOAD_BUKTI to MENUNGGU_VERIFIKASI_CS1
      final updatedOrder = order.copyWith(
        status: 'MENUNGGU_VERIFIKASI_CS1',
        updatedAt: DateTime.now(),
      );

      await ref.read(orderProvider.notifier).updateOrderStatus(
        order.id!,
        updatedOrder.status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bukti pembayaran berhasil dikirim!'),
          backgroundColor: Colors.green,
        ),
      );

      context.pushReplacement('/orders');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim bukti pembayaran: $e'),
            backgroundColor: Colors.red,
          ),
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
}

class TransferInfoSection extends ConsumerWidget {
  final Future<int> totalAmount;

  const TransferInfoSection({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Transfer',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.md,
            TransferInfoItem(label: 'Bank', value: 'Bank Central Asia (BCA)'),
            TransferInfoItem(label: 'Nomor Rekening', value: '1234567890'),
            TransferInfoItem(
              label: 'Atas Nama',
              value: 'Toko Online Sederhana',
            ),
            const Divider(),
            FutureBuilder<int>(
              future: totalAmount,
              builder: (context, snapshot) {
                final total = snapshot.data ?? 0;
                final totalText = total.currencyFormatRp;
                return TransferInfoItem(
                  label: 'Total Pembayaran',
                  value: totalText,
                  isTotal: true,
                  onTap: () {
                    context.copyToClipboardAndShowSnackBar(totalText);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransferInfoSectionFromOrder extends StatelessWidget {
  final OrderModel order;

  const TransferInfoSectionFromOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final totalText = order.totalPrice.currencyFormatRp;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Transfer',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.md,
            TransferInfoItem(label: 'Bank', value: 'Bank Central Asia (BCA)'),
            TransferInfoItem(label: 'Nomor Rekening', value: '1234567890'),
            TransferInfoItem(
              label: 'Atas Nama',
              value: 'Toko Online Sederhana',
            ),
            const Divider(),
            TransferInfoItem(
              label: 'Total Pembayaran',
              value: totalText,
              isTotal: true,
              onTap: () {
                context.copyToClipboardAndShowSnackBar(totalText);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransferInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final VoidCallback? onTap;

  const TransferInfoItem({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: isTotal
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isTotal ? context.colorScheme.primary : null,
                        decoration: onTap != null
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.copy,
                      size: 16,
                      color: context.colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentProofForm extends StatelessWidget {
  final XFile? selectedImage;
  final VoidCallback onImagePicked;
  final bool isUploading;

  const PaymentProofForm({
    super.key,
    required this.selectedImage,
    required this.onImagePicked,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Bukti Transfer',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.md,
            GestureDetector(
              onTap: isUploading ? null : onImagePicked,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedImage != null
                        ? context.colorScheme.primary
                        : context.colorScheme.outline,
                    style: BorderStyle.solid,
                    width: selectedImage != null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isUploading
                      ? context.colorScheme.surfaceContainerHighest
                      : null,
                ),
                child: selectedImage != null
                    ? Stack(
                        children: [
                           ClipRRect(
                             borderRadius: BorderRadius.circular(7),
                             child: Image.file(
                               File(selectedImage!.path),
                               width: double.infinity,
                               height: double.infinity,
                               fit: BoxFit.cover,
                               errorBuilder: (context, error, stackTrace) {
                                 return const Center(
                                   child: Icon(Icons.broken_image, size: 48),
                                 );
                               },
                             ),
                           ),
                          if (!isUploading)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: onImagePicked,
                                ),
                              ),
                            ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 48,
                            color: isUploading
                                ? context.colorScheme.onSurfaceVariant.withOpacity(0.5)
                                : context.colorScheme.onSurfaceVariant,
                          ),
                          AppSpacing.sm,
                          Text(
                            isUploading
                                ? 'Mengupload...'
                                : 'Klik untuk upload bukti transfer',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: isUploading
                                  ? context.colorScheme.onSurfaceVariant.withOpacity(0.5)
                                  : context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Format: JPG, PNG (Max 2MB)',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
