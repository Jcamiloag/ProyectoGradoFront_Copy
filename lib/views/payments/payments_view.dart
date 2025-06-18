import 'package:flutter/material.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: const Center(
        child: Text(
          'Historial de Pagos',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
