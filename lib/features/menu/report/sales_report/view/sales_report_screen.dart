import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../bloc/sales_report_bloc.dart';
import '../bloc/sales_report_event.dart';
import '../bloc/sales_report_state.dart';
import '../sales_model/sales_report_model.dart';

class SalesReportScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const SalesReportScreen({super.key, required this.navigatorKey});

  @override
  State<SalesReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<SalesReportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String filter = "All";
  String brandId = "";

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        isStart ? startDate = date : endDate = date;
      });
    }
  }

  void _generatePDF(List<ReportModel> reports) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Sales Report',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: [
              'Date', 'Invoice ID', 'Customer', 'Product', 'Qty',
              'Sale Amt', 'Purchase Amt', 'Profit', 'IMEI'
            ],
            data: reports.map((e) {
              return [
                e.date,
                e.invoiceId,
                e.customerName,
                e.productName,
                e.qty.toString(),
                e.salesAmount.toStringAsFixed(2),
                e.purchaseAmount.toStringAsFixed(2),
                e.profit.toStringAsFixed(2),
                e.imei ?? '-'
              ];
            }).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportBloc(navigatorKey: widget.navigatorKey),
      child: Scaffold(
        appBar: AppBar(title: const Text("Sales Report"), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(context, true),
                      child: Text(startDate == null
                          ? "Start Date"
                          : DateFormat('yyyy-MM-dd').format(startDate!)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(context, false),
                      child: Text(endDate == null
                          ? "End Date"
                          : DateFormat('yyyy-MM-dd').format(endDate!)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ["All", "IEMI", "Normal"].map((item) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: item,
                        groupValue: filter,
                        onChanged: (val) => setState(() => filter = val!),
                      ),
                      Text(item),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<ReportBloc, ReportState>(
                  builder: (context, state) {
                    if (state is ReportLoading) return _buildShimmer();
                    if (state is ReportLoaded) {
                      if (state.reports.isEmpty) return _buildEmptyState();
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text("Export PDF"),
                              onPressed: () => _generatePDF(state.reports),
                            ),
                          ),
                          Expanded(child: _buildReportTable(state.reports)),
                        ],
                      );
                    }
                    if (state is ReportError) {
                      return Center(
                        child: Text("❌ ${state.message}",
                            style: const TextStyle(color: Colors.red)),
                      );
                    }

                    return Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.analytics),
                        label: const Text("Generate Report"),
                        onPressed: () {
                          if (startDate != null && endDate != null) {
                            context.read<ReportBloc>().add(FetchReportEvent(
                              startDate: startDate!.toIso8601String(),
                              endDate: endDate!.toIso8601String(),
                              filter: filter,
                              brandId: brandId,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please select both dates.")),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() => ListView.builder(
    itemCount: 6,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.white),
    ),
  );

  Widget _buildEmptyState() => const Center(
    child: Text("No report data found!",
        style: TextStyle(fontSize: 16, color: Colors.grey)),
  );

  /// ===================== TABLE UI =====================
  Widget _buildReportTable(List<ReportModel> reports) {
    double totalSales = reports.fold(0, (sum, r) => sum + r.salesAmount);
    double totalPurchase = reports.fold(0, (sum, r) => sum + r.purchaseAmount);
    double totalProfit = reports.fold(0, (sum, r) => sum + r.profit);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20,
                dataRowHeight: 48,
                headingRowHeight: 52,
                border: TableBorder.all(color: Colors.black, width: 1),
                headingRowColor: MaterialStateProperty.all(
                    const Color(0xFFEEF0FA)), // header bg color
                columns: const [
                  DataColumn(
                      label: Text("SL",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Transaction Date",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Voucher Number",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Customer Name",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Order Type",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Product Name",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Qty",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Sales Amount",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Purchase Amount",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Profit",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: List.generate(reports.length, (i) {
                  final r = reports[i];
                  final isEven = i % 2 == 0;
                  return DataRow(
                    color: MaterialStateProperty.all(
                        isEven ? Colors.white : const Color(0xFFF7F8FC)),
                    cells: [
                      DataCell(Text("${i + 1}")),
                      DataCell(Text(r.date)),
                      DataCell(Text(r.invoiceId)),
                      DataCell(Text(r.customerName)),
                      DataCell(Text(r.orderTypeName)),
                      DataCell(Text(r.productName)),
                      DataCell(Text(r.qty.toString())),
                      DataCell(Text(r.salesAmount.toStringAsFixed(2))),
                      DataCell(Text(r.purchaseAmount.toStringAsFixed(2))),
                      DataCell(Text(r.profit.toStringAsFixed(2))),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Summary Section
        _buildSummaryRow("1 Days", "Grand Total", totalSales, totalPurchase, totalProfit),
        _buildSummaryRow("", "Discount Total", 0, 0, 0),
        _buildSummaryRow("", "Actual Grand Total", 0, 0, 0),
        _buildSummaryRow("", "Profit Total", 0, 0, totalProfit),
      ],
    );
  }

  Widget _buildSummaryRow(
      String leftText, String title, double sales, double purchase, double profit) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(leftText, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(sales == 0 ? "0" : sales.toStringAsFixed(2), textAlign: TextAlign.right)),
          Expanded(child: Text(purchase == 0 ? "0" : purchase.toStringAsFixed(2), textAlign: TextAlign.right)),
          Expanded(child: Text(profit == 0 ? "0" : profit.toStringAsFixed(2), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
