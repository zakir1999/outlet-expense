
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/download_button.dart';
import '../../../../../core/widgets/shimmer.dart';
import '../../../../../core/widgets/date_picker.dart';
import '../bloc/sales_register_details_bloc.dart';
import '../bloc/sales_register_details_event.dart';
import '../bloc/sales_register_details_state.dart';
import '../model/sales_register_details_model.dart';


class SalesRegisterDetailsScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const SalesRegisterDetailsScreen({
    super.key,
    required this.apiClient,
    required this.navigatorKey,
  });

  @override
  State<SalesRegisterDetailsScreen> createState() =>
      _SalesRegisterDetailsScreenState();
}

class _SalesRegisterDetailsScreenState extends State<SalesRegisterDetailsScreen> {
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate = today;
    endDate = today;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SalesRegisterDetailsBloc>().add(
        FetchSalesRegisterDetailsEvent(
          startDate: today.toIso8601String(),
          endDate: today.toIso8601String(),
        ),
      );
    });
  }

  // ----------------- PDF GENERATION -----------------
  Future<void> _generatePDF(List<SalesRegisterItem> items, int grandTotal) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(12),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Center(
            child: pw.Text(
              "Sales Register Details",
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.3),
            columnWidths: const {
              0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(3),
              2: pw.FlexColumnWidth(2), 3: pw.FlexColumnWidth(4),
              4: pw.FlexColumnWidth(3), 5: pw.FlexColumnWidth(3),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _pdfCell("Created At", bold: true), _pdfCell("Invoice ID", bold: true),
                  _pdfCell("Qty", bold: true), _pdfCell("Customer Name", bold: true),
                  _pdfCell("Product", bold: true), _pdfCell("Sub Total(BDT)", bold: true),
                ],
              ),
              ...items.map((e) {
                return pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    _pdfCell(e.createdAt.split("T").first),
                    _pdfCell('${e.invoiceId.split('-').first}-${e.invoiceId.split('-').last}'),
                    _pdfCell(e.qty.toString()), _pdfCell(e.customerName),
                    _pdfCell(e.productName), _pdfCell(e.subTotal.toString()),
                  ],
                );
              }),
            ],
          )
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (_) async => pdf.save());
  }

  pw.Widget _pdfCell(String text, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        fontSize: 10,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text("Sales Register Details", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      floatingActionButton: BlocBuilder<SalesRegisterDetailsBloc, SalesRegisterDetailsState>(
        builder: (context, state) {
          if (state is SalesRegisterDetailsLoaded) {
            final items = state.response.data;
            final grandTotal = state.response.grandNetTotal;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 5),
              child: DownloadButton(
                onPressed: () => _generatePDF(items, grandTotal),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            _datePickerSection(),
            Expanded(
              child: BlocBuilder<SalesRegisterDetailsBloc, SalesRegisterDetailsState>(
                builder: (context, state) {
                  if (state is SalesRegisterDetailsLoading) {
                    return const ResponsiveShimmer();
                  }
                  if (state is SalesRegisterDetailsError) {
                    return Center(child: Text("❌ ${state.message}", style: const TextStyle(color: Colors.red)));
                  }
                  if (state is SalesRegisterDetailsLoaded) {
                    final items = state.response.data;
                    final grandTotal = state.response.grandNetTotal;
                    if (items.isEmpty) {
                      return const Center(child: Text("No data available for the selected dates."));
                    }
                    return _tableSection(items, grandTotal);
                  }
                  return const SizedBox.shrink();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // ----------------- DATE PICKER UI -----------------
  Widget _datePickerSection() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDatePicker(
                  title: "Start Date",
                  hintText: startDate!.toIso8601String().split("T").first,
                  initialDate: startDate!,
                  onDateSelected: (date) => setState(() => startDate = date),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: CustomDatePicker(
                  title: "End Date",
                  hintText: endDate!.toIso8601String().split("T").first,
                  initialDate: endDate!,
                  onDateSelected: (date) => setState(() => endDate = date),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomAnimatedButton(
                label: "Report",
                icon: Icons.analytics_outlined,
                onPressed: () {
                  context.read<SalesRegisterDetailsBloc>().add(
                    FetchSalesRegisterDetailsEvent(
                      startDate: startDate!.toIso8601String(),
                      endDate: endDate!.toIso8601String(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------- TABLE UI -----------------
  Widget _tableSection(List<SalesRegisterItem> items, int grandTotal) {
    const double slWidth = 60;
    const double invoiceWidth = 200;
    const double dateWidth = 100;
    const double customerWidth = 150;
    const double productWidth = 200;
    const double qtyWidth = 120;
    const double totalWidth = 150;
    const double totalTableWidth = slWidth + invoiceWidth + dateWidth + customerWidth + productWidth + qtyWidth + totalWidth;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: SizedBox(
          width: totalTableWidth,
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _TableHeaderDelegate(
                  height: 60,
                  child: Container(
                    color: const Color(0xFFE0E0E0),
                    child: Row(
                      children: [
                        _tableCell('SL', bold: true, width: slWidth),
                        _tableCell('Invoice ID', bold: true, width: invoiceWidth),
                        _tableCell('Date', bold: true, width: dateWidth),
                        _tableCell('Customer', bold: true, width: customerWidth),
                        _tableCell('Product', bold: true, width: productWidth),
                        _tableCell('Qty', bold: true, width: qtyWidth),
                        _tableCell('Sub Total (BDT)', bold: true, width: totalWidth),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index == items.length) {
                      return Container(
                        color: const Color(0xFFE0E0E0),
                        child: Row(
                          children: [
                            _tableCell('', width: slWidth + invoiceWidth + dateWidth + customerWidth + productWidth),
                            _tableCell('Grand Total', bold: true, width: qtyWidth),
                            _tableCell('$grandTotal', bold: true, width: totalWidth),
                          ],
                        ),
                      );
                    }
                    final item = items[index];
                    final bg = index.isEven ? Colors.white : const Color(0xFFF7F7F7);
                    return Container(
                      color: bg,
                      child: Row(
                        children: [
                          _tableCell('${index + 1}', width: slWidth),
                          _tableCell('${item.invoiceId.split('-').first}-${item.invoiceId.split('-').last}', width: invoiceWidth),
                          _tableCell(item.createdAt.split("T").first, width: dateWidth),
                          _tableCell(item.customerName, width: customerWidth),
                          _tableCell(item.productName, width: productWidth),
                          _tableCell(item.qty.toString(), width: qtyWidth),
                          _tableCell(item.subTotal.toString(), width: totalWidth),
                        ],
                      ),
                    );
                  },
                  childCount: items.length + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableCell(String text, {bool bold = false, double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// This helper delegate can be moved to a shared widgets file if used elsewhere.
class _TableHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _TableHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_TableHeaderDelegate oldDelegate) => oldDelegate.child != child || oldDelegate.height != height;
}