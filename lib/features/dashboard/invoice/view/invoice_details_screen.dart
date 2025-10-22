import 'package:flutter/material.dart';
import '../model/invoice_model.dart';
import '../repository/invoice_repository.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;
  final InvoiceRepository repository;
  const InvoiceDetailScreen({super.key, required this.invoiceId, required this.repository});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late Future<Invoice> _invoiceFuture;

  @override
  void initState() {
    super.initState();
    _invoiceFuture = widget.repository.fetchInvoiceById(widget.invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: const BackButton(color: Colors.black),
      ),
      body: FutureBuilder<Invoice>(
        future: _invoiceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Invoice not found'));
          }

          final invoice = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(invoice.id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Customer: ${invoice.customerName}'),
                    Text('Amount: ${invoice.amount} ৳'),
                    Text('Created At: ${invoice.createdAt}'),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
