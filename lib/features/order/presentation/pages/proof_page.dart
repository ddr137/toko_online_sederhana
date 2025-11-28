import 'package:flutter/material.dart';

class ProofPage extends StatelessWidget {
  const ProofPage({super.key, required this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bukti Pembayaran')),
      body: Center(child: Text('Bukti pembayaran akan ditampilkan di sini')),
    );
  }
}
