import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../chart/widgets/recent_oder.dart';


import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../invoice_card.dart';
import '../repository/invoice_repository.dart';
import 'invoice_details_screen.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InvoiceBloc>();
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice list'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.2,
      ),
      backgroundColor: const Color(0xFFF6F8FA),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Sales / Purchases Toggle
          BlocBuilder<InvoiceBloc, InvoiceState>(
            builder: (context, state) {
              String active = 'Inv';
              if (state is InvoiceLoaded) active = state.activeType;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: active == 'Inv' ? Colors.teal : Colors.grey.shade300,
                        ),
                        onPressed: () => bloc.add(ChangeTypeFilter('Inv')),
                        child: const Text('Sales'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: active == 'Pur' ? Colors.teal : Colors.grey.shade300,
                        ),
                        onPressed: () => bloc.add(ChangeTypeFilter('Pur')),
                        child: const Text('Purchase'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Invoice',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => bloc.add(SearchQueryChanged(v)),
            ),
          ),

          const SizedBox(height: 10),

          // Invoice List
          Expanded(
            child: BlocBuilder<InvoiceBloc, InvoiceState>(
              builder: (context, state) {
                if (state is InvoiceLoading || state is InvoiceInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is InvoiceError) {
                  return Center(child: Text(state.message));
                } else if (state is InvoiceLoaded) {
                  final invoices = state.visibleInvoices;
                  if (invoices.isEmpty) return const Center(child: Text('No Invoices Found'));
                  return ListView.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final inv = invoices[index];
                      return InvoiceCard(
                        id: inv.id,
                        customerName: inv.customerName,
                        createdAt: inv.createdAt,
                        amount: inv.amount,
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
