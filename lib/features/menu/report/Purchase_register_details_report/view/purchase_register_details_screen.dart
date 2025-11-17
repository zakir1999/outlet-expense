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

import '../bloc/purchase_register_details_bloc.dart';
import '../bloc/purchase_register_details_event.dart';
import '../bloc/purchase_register_details_state.dart';
import '../model/purchase_register_details_model.dart';

class PurchaseRegisterDetailsScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const PurchaseRegisterDetailsScreen({
    super.key,
    required this.apiClient,
    required this.navigatorKey,
  });

  @override
  State<PurchaseRegisterDetailsScreen> createState() =>
      _PurchaseRegisterDetailsScreenState();
}

class _PurchaseRegisterDetailsScreenState extends State<PurchaseRegisterDetailsScreen> {
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
      context.read<PurchaseRegisterDetailsBloc>().add(
        FetchPurchaseRegisterDetailsEvent(
          startDate: today.toIso8601String(),
          endDate: today.toIso8601String(),
        ),
      );
    });
  }

  // ----------------- PDF GENERATION -----------------
  Future<void> _generatePDF(List<PurchaseRegisterItem> item,
      int grandTotal) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(12),
        pageFormat: PdfPageFormat.a4,
        build: (context) =>
        [
          pw.Center(
            child: pw.Text(
              "Purchase Register Details",
              style:
              pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.3),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(3),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(4),
              4: pw.FlexColumnWidth(3),
              5: pw.FlexColumnWidth(3),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _pdfCell("Created At", bold: true),
                  _pdfCell("Invoice ID", bold: true),
                  _pdfCell("Qty", bold: true),
                  _pdfCell("Vendor Name", bold: true),
                  _pdfCell("Product", bold: true),
                  _pdfCell("Sub Total(BDT)", bold: true),
                ],
              ),

              ...item.map((e) {
                return pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    _pdfCell(e.createdAt.split("T").first,),
                    _pdfCell('${e.invoiceId.split('-').first}-${e.invoiceId.split('-').last}'),
                    _pdfCell(e.qty.toString()),
                    _pdfCell(e.vendorName),
                    _pdfCell(e.productName),
                    _pdfCell(e.subTotal.toString()),
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

  pw.Widget _pdfCell(String text, {bool bold = false}) =>
      pw.Padding(
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
        title: const Text(
          "Purchase Register Details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      floatingActionButton: BlocBuilder<PurchaseRegisterDetailsBloc,
          PurchaseRegisterDetailsState>(
        builder: (context, state) {
          if (state is PurchaseRegisterDetailsLoaded) {
            final items = state.response.data; // ← use data list
            final grandTotal = state.response.grandNetTotal;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 5),
              child: DownloadButton(
                icon: Icons.file_download_rounded,
                backgroundColor: Colors.grey.shade800,
                iconColor: Colors.white,
                size: 60,
                iconSize: 26,
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
              child: BlocBuilder<PurchaseRegisterDetailsBloc,
                  PurchaseRegisterDetailsState>(
                builder: (context, state) {
                  if (state is PurchaseRegisterDetailsLoading) {
                    return const ResponsiveShimmer();
                  }
                  if (state is PurchaseRegisterDetailsError) {
                    return Center(
                      child: Text(
                        "❌ ${state.message}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (state is PurchaseRegisterDetailsLoaded) {
                    final items = state.response.data; // ← use data list
                    final grandTotal = state.response
                        .grandNetTotal; // grand total
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
                  hintText: startDate!
                      .toIso8601String()
                      .split("T")
                      .first,
                  initialDate: startDate!,
                  onDateSelected: (date) => setState(() => startDate = date),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: CustomDatePicker(
                  title: "End Date",
                  hintText: endDate!
                      .toIso8601String()
                      .split("T")
                      .first,
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
                color: const Color(0xFF3240B6),
                pressedColor: const Color(0xFF26338A),
                width: 150,
                height: 50,
                borderRadius: 24,
                fullWidth: false,
                onPressed: () {
                  context.read<PurchaseRegisterDetailsBloc>().add(
                    FetchPurchaseRegisterDetailsEvent(
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



  Widget _tableSection(List<PurchaseRegisterItem> items, int grandTotal) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController, // header & rows scroll together horizontally
        child: SizedBox(
          width: 60 + 200 + 100 + 150 + 200 + 120 + 150, // total table width
          child: CustomScrollView(
            slivers: [
              // ------------------ PINNED HEADER ------------------
              SliverPersistentHeader(
                pinned: true,
                delegate: _TableHeaderDelegate(
                  height: 60,
                  child: Container(
                    color: const Color(0xFFE0E0E0),
                    child: Row(
                      children: [
                        _tableCell('SL', bold: true, width: 60),
                        _tableCell('Invoice ID', bold: true, width: 200),
                        _tableCell('Date', bold: true, width: 100),
                        _tableCell('Vendor', bold: true, width: 150),
                        _tableCell('Product', bold: true, width: 200),
                        _tableCell('Qty', bold: true, width: 120),
                        _tableCell('Sub Total (BDT)', bold: true, width: 150),
                      ],
                    ),
                  ),
                ),
              ),

              // ------------------ DATA ROWS ------------------
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index == items.length) {
                      // ------------------ GRAND TOTAL ROW ------------------
                      return Container(
                        color: const Color(0xFFE0E0E0),
                        child: Row(
                          children: [
                            _tableCell('', width: 60),
                            _tableCell('', width: 200),
                            _tableCell('', width: 100),
                            _tableCell('', width: 150),
                            _tableCell('', width: 200),
                            _tableCell('Grand Total', bold: true, width: 120),
                            _tableCell('$grandTotal', bold: true, width: 150),
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

                          _tableCell('${index + 1}', width: 60),

                          _tableCell(
                              '${item.invoiceId.split('-').first}-${item.invoiceId.split('-').last}',
                              width: 200
                          ),

                          _tableCell(item.createdAt.split("T").first, width: 100),
                          _tableCell(item.vendorName, width: 150),
                          _tableCell(item.productName, width: 200),
                          _tableCell(item.qty.toString(), width: 120),
                          _tableCell(item.subTotal.toString(), width: 150),
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
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }


  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();


  }

}

class _TableHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _TableHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_TableHeaderDelegate oldDelegate) =>
      oldDelegate.child != child || oldDelegate.height != height;
}

