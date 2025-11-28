import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toko_online_sederhana/core/enums/snack_bar_status_enum.dart';
import 'package:toko_online_sederhana/shared/extensions/custom_snack_bar_ext.dart';


extension CopyToClipboard on BuildContext {
  Future<void> copyToClipboardAndShowSnackBar(
    String text, {
    Duration duration = const Duration(seconds: 2),
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    showSnackBar(
      'Telah disalin ke clipboard',
      duration: duration,
      status: SnackBarStatus.info,
    );
  }
}
