import 'package:flutter/material.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final String invoiceId;
  final String? customerName;
  final String? createdAt;
  final double? amount;

  const InvoiceDetailsScreen({
    Key? key,
    required this.invoiceId,
    this.customerName,
    this.createdAt,
    this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice #$invoiceId'),
        backgroundColor: const Color.fromARGB(255, 35, 59, 201),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer: ${customerName ?? "N/A"}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Created At: ${createdAt ?? "N/A"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: \$${amount?.toStringAsFixed(2) ?? "0.00"}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Additional Details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can add more invoice details here, like items, taxes, payment status, etc.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
