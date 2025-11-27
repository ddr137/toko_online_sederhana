import 'package:intl/intl.dart';

extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get capitalizeAll {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  String get currencyFormat {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
    );
    return formatter.format(double.parse(this));
  }
}
