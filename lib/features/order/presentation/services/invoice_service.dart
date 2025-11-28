import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:toko_online_sederhana/core/utils/spacing.dart';
import 'package:toko_online_sederhana/features/order/data/models/order_model.dart';

class InvoiceService {
  static Future<Uint8List> generateInvoice(OrderModel order) async {
    final pdf = Document();

    String formatCurrency(int amount) {
      final formatter = NumberFormat('#,###', 'en_US');
      return 'Rp ${formatter.format(amount).replaceAll(',', '.')}';
    }

    String formatDate(DateTime date) {
      final months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    MemoryImage? paymentProofImage;
    if (order.paymentProofPath != null && order.paymentProofPath!.isNotEmpty) {
      try {
        final imageBytes = await _loadImageBytes(order.paymentProofPath!);
        paymentProofImage = MemoryImage(imageBytes);
      } catch (e) {
        paymentProofImage = null;
      }
    }

    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(32),
        build: (Context context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INVOICE',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppGaps.xs),
                      Text(
                        'Toko Online Sederhana',
                        style: const TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'No. Invoice',
                        style: const TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                      SizedBox(height: AppGaps.xs),
                      Text(
                        '#${order.id?.toString().padLeft(6, '0') ?? '000000'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppGaps.sm),
                      Text(
                        'Tanggal',
                        style: const TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                      SizedBox(height: AppGaps.xs),
                      Text(
                        formatDate(order.createdAt),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppGaps.xl),
              Divider(thickness: 2),
              SizedBox(height: AppGaps.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DATA PEMBELI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: PdfColors.grey800,
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow('Nama', order.customerName),
                        _buildInfoRow('Telepon', order.customerPhone),
                        _buildInfoRow('Role', order.customerRole),
                        _buildInfoRow('Alamat', order.shippingAddress),
                      ],
                    ),
                  ),
                  SizedBox(width: AppGaps.xl),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STATUS PESANAN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: PdfColors.grey800,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusText(order.status),
                            style: const TextStyle(
                              fontSize: 12,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        if (order.updatedAt != null)
                          _buildInfoRow(
                            'Terakhir Diupdate',
                            formatDate(order.updatedAt!),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppGaps.xl),
              Text(
                'RINCIAN PESANAN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              SizedBox(height: 12),
              if (order.items != null && order.items!.isNotEmpty)
                Table(
                  border: TableBorder.all(color: PdfColors.grey300),
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: PdfColors.grey200),
                      children: [
                        _buildTableCell('Produk', isHeader: true),
                        _buildTableCell(
                          'Qty',
                          isHeader: true,
                          align: TextAlign.center,
                        ),
                        _buildTableCell(
                          'Harga',
                          isHeader: true,
                          align: TextAlign.right,
                        ),
                        _buildTableCell(
                          'Subtotal',
                          isHeader: true,
                          align: TextAlign.right,
                        ),
                      ],
                    ),
                    ...order.items!.map((item) {
                      final subtotal = item.price * item.quantity;
                      return TableRow(
                        children: [
                          _buildTableCell(item.productName),
                          _buildTableCell(
                            item.quantity.toString(),
                            align: TextAlign.center,
                          ),
                          _buildTableCell(
                            formatCurrency(item.price),
                            align: TextAlign.right,
                          ),
                          _buildTableCell(
                            formatCurrency(subtotal),
                            align: TextAlign.right,
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                )
              else
                Table(
                  border: TableBorder.all(color: PdfColors.grey300),
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: PdfColors.grey200),
                      children: [
                        _buildTableCell('Deskripsi', isHeader: true),
                        _buildTableCell(
                          'Qty',
                          isHeader: true,
                          align: TextAlign.center,
                        ),
                        _buildTableCell(
                          'Harga',
                          isHeader: true,
                          align: TextAlign.right,
                        ),
                        _buildTableCell(
                          'Subtotal',
                          isHeader: true,
                          align: TextAlign.right,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell('Pesanan ${order.customerName}'),
                        _buildTableCell('1', align: TextAlign.center),
                        _buildTableCell(
                          formatCurrency(order.totalPrice),
                          align: TextAlign.right,
                        ),
                        _buildTableCell(
                          formatCurrency(order.totalPrice),
                          align: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: AppGaps.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 250,
                    child: Column(
                      children: [
                        Divider(thickness: 1),
                        SizedBox(height: AppGaps.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL PEMBAYARAN ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCurrency(order.totalPrice),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: PdfColors.blue800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppGaps.xl),
              Divider(thickness: 1),
              SizedBox(height: AppGaps.md),
              Text(
                'BUKTI PEMBAYARAN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              SizedBox(height: 12),
              if (paymentProofImage != null)
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: PdfColors.grey300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    horizontalRadius: 4,
                    verticalRadius: 4,
                    child: Image(paymentProofImage, fit: BoxFit.contain),
                  ),
                )
              else
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: PdfColors.grey300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      'Belum ada bukti pembayaran',
                      style: const TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                ),
              Spacer(),
              Divider(),
              SizedBox(height: AppGaps.sm),
              Center(
                child: Text(
                  'Terima kasih atas kepercayaan Anda',
                  style: const TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Toko Online Sederhana • www.tokoonlinesederhana.com',
                  style: const TextStyle(fontSize: 9, color: PdfColors.grey500),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ),
          Text(': ', style: const TextStyle(fontSize: 10)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    TextAlign align = TextAlign.left,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? PdfColors.grey800 : PdfColors.black,
        ),
      ),
    );
  }

  static PdfColor _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'MENUNGGU_UPLOAD_BUKTI':
        return PdfColors.red700;
      case 'MENUNGGU_VERIFIKASI_CS1':
      case 'MENUNGGU_VERIFIKASI_CS2':
      case 'MENUNGGU_DIPROSES_CS2':
        return PdfColors.purple700;
      case 'SEDANG_DIPROSES':
        return PdfColors.orange700;
      case 'DIKIRIM':
        return PdfColors.blue700;
      case 'SELESAI':
        return PdfColors.green700;
      case 'DIBATALKAN':
        return PdfColors.grey700;
      default:
        return PdfColors.grey700;
    }
  }

  static String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'MENUNGGU_UPLOAD_BUKTI':
        return 'Menunggu Upload Bukti';
      case 'MENUNGGU_VERIFIKASI_CS1':
        return 'Menunggu Verifikasi CS1';
      case 'MENUNGGU_VERIFIKASI_CS2':
        return 'Menunggu Verifikasi CS2';
      case 'MENUNGGU_DIPROSES_CS2':
        return 'Menunggu Diproses CS2';
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

  static Future<String?> saveInvoice(OrderModel order) async {
    try {
      final pdfData = await generateInvoice(order);

      await Printing.sharePdf(
        bytes: pdfData,
        filename:
            'invoice_${order.id?.toString().padLeft(6, '0') ?? 'draft'}.pdf',
      );

      return 'PDF berhasil dibagikan';
    } catch (e) {
      throw Exception('Gagal menyimpan invoice: $e');
    }
  }

  static Future<void> previewInvoice(OrderModel order) async {
    final pdfData = await generateInvoice(order);

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  static Future<Uint8List> _loadImageBytes(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      } else {
        throw Exception('File tidak ditemukan: $imagePath');
      }
    } catch (e) {
      throw Exception('Gagal membaca file gambar: $e');
    }
  }
}
