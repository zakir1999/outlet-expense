import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/date_picker.dart';
import '../../../../../core/widgets/download_button.dart';
import '../../../../../core/widgets/shimmer.dart';
import '../bloc/profit_loss_account_report_bloc.dart';
import '../bloc/profit_loss_account_report_event.dart';
import '../bloc/profit_loss_account_report_state.dart';
import '../model/profit_loss_account_report_model.dart';

class ProfitLossReportScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const ProfitLossReportScreen({
    super.key,
    required this.apiClient,
    required this.navigatorKey,
  });

  @override
  State<ProfitLossReportScreen> createState() => _ProfitLossReportScreenState();
}

class _ProfitLossReportScreenState extends State<ProfitLossReportScreen> {
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
      _fetchReport();
    });
  }

  void _fetchReport() {
    context.read<ProfitLossReportBloc>().add(
      FetchProfitLossReportEvent(
        startDate: startDate!.toIso8601String(),
        endDate: endDate!.toIso8601String(),
      ),
    );
  }

  String startDateString() =>
      (startDate ?? DateTime.now()).toIso8601String().split('T').first;

  String endDateString() =>
      (endDate ?? DateTime.now()).toIso8601String().split('T').first;

  Future<void> _generatePDF(ProfitLossReport report) async {
    final pdf = pw.Document();
    final f = NumberFormat('#,##0', 'en_US');

    final leftItems = report.expenses.entries.map((e) => MapEntry(e.key, e.value)).toList();
    final rightItems = <MapEntry<String, num>>[
      MapEntry('Gross Profit b/d', report.grossProfit),
      MapEntry('Net Profit', report.netProfit),
    ];
    final maxRows = leftItems.length > rightItems.length ? leftItems.length : rightItems.length;

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(14),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Profit and Loss Account',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey700, width: 0.8),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(3),
              3: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _pdfCell('Particulars', bold: true),
                  _pdfCell('Amount (In BDT)', bold: true),
                  _pdfCell('Particulars', bold: true),
                  _pdfCell('Amount (In BDT)', bold: true),
                ],
              ),
              for (var i = 0; i < maxRows; i++)
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: i.isEven ? PdfColors.white : PdfColors.grey100,
                  ),
                  children: [
                    i < leftItems.length ? _pdfCell(leftItems[i].key) : _pdfCell(''),
                    i < leftItems.length ? _pdfCell(f.format(leftItems[i].value)) : _pdfCell(''),
                    i < rightItems.length ? _pdfCell(rightItems[i].key) : _pdfCell(''),
                    i < rightItems.length ? _pdfCell(f.format(rightItems[i].value)) : _pdfCell(''),
                  ],
                ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _pdfCell('Total Expenses (In BDT):', bold: true),
                  _pdfCell(f.format(report.totalExpenses), bold: true),
                  _pdfCell('Total (In BDT):', bold: true),
                  _pdfCell(f.format(report.grossProfit + report.netProfit), bold: true),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              'Note: All amounts are in BDT.',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (_) async => pdf.save());
  }

  pw.Widget _pdfCell(String text, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.left,
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0', 'en_US');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text('Profit & Loss Report', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      floatingActionButton: BlocSelector<ProfitLossReportBloc, ProfitLossReportState, ProfitLossReport?>(
        selector: (state) => state is ProfitLossReportLoaded ? state.report : null,
        builder: (context, report) {
          if (report == null) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 5),
            child: DownloadButton(
              onPressed: () => _generatePDF(report),
              icon: Icons.file_download_rounded,
              backgroundColor: const Color(0xF2959292),
              iconColor: Colors.white,
              size: 60,
              iconSize: 26,
            ),
          );
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            _datePickerSection(),

            // ---------------------------
            // FIX APPLIED HERE
            // ---------------------------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<ProfitLossReportBloc, ProfitLossReportState>(
                      buildWhen: (prev, current) =>
                      current is ProfitLossReportLoading ||
                          current is ProfitLossReportError ||
                          current is ProfitLossReportLoaded,
                      builder: (context, state) {
                        if (state is ProfitLossReportLoading) {
                          return ResponsiveShimmer();
                        }

                        if (state is ProfitLossReportError) {
                          return Center(
                            child: Text(
                              "❌ ${state.message}",
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                    // Table Section
                    SizedBox(
                      height: 600, // keeps scroll working & avoids overflow
                      child: BlocSelector<ProfitLossReportBloc,
                          ProfitLossReportState, ProfitLossReport?>(
                        selector: (state) =>
                        state is ProfitLossReportLoaded ? state.report : null,
                        builder: (context, data) {
                          if (data == null) {
                            return const Center(
                              child: Text(
                                'No report data found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return _tableSection(data, formatter);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ---------------------------
          ],
        ),
      ),
    );
  }

  Widget _datePickerSection() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDatePicker(
                  title: 'Start Date',
                  hintText: startDateString(),
                  initialDate: startDate ?? DateTime.now(),
                  onDateSelected: (date) => setState(() => startDate = date),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: CustomDatePicker(
                  title: 'End Date',
                  hintText: endDateString(),
                  initialDate: endDate!,
                  onDateSelected: (date) => setState(() => endDate = date),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomAnimatedButton(
                label: 'Report',
                icon: Icons.analytics_outlined,
                color: const Color(0xFF3240B6),
                pressedColor: const Color(0xFF26338A),
                fullWidth: false,
                height: 50,
                borderRadius: 24,
                width: 150,
                onPressed: _fetchReport,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableSection(ProfitLossReport report, NumberFormat f) {
    const double particularsWidth = 280;
    const double amountWidth = 140;
    const double totalWidth =
        particularsWidth + amountWidth + particularsWidth + amountWidth;

    final leftItems = report.expenses.entries.map((e) => MapEntry(e.key, e.value)).toList();
    final rightItems = <MapEntry<String, num>>[
      MapEntry('Gross Profit b/d', report.grossProfit),
      MapEntry('Net Profit', report.netProfit),
    ];
    final maxRows = leftItems.length > rightItems.length ? leftItems.length : rightItems.length;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: SizedBox(
          width: totalWidth,
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
                        _tableCell('Particulars', bold: true, width: particularsWidth),
                        _tableCell('Amount (In BDT)', bold: true, width: amountWidth),
                        _tableCell('Particulars', bold: true, width: particularsWidth),
                        _tableCell('Amount (In BDT)', bold: true, width: amountWidth),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index == maxRows) {
                      return Container(
                        color: const Color(0xFFE0E0E0),
                        child: Row(
                          children: [
                            _tableCell('Total Expenses (In BDT):', bold: true, width: particularsWidth),
                            _tableCell(f.format(report.totalExpenses), bold: true, width: amountWidth),
                            _tableCell('Total (In BDT):', bold: true, width: particularsWidth),
                            _tableCell(f.format(report.grossProfit + report.netProfit), bold: true, width: amountWidth),
                          ],
                        ),
                      );
                    }

                    final bg = index.isEven ? Colors.white : const Color(0xFFF7F7F7);
                    final leftText = index < leftItems.length ? leftItems[index].key : '';
                    final leftAmount = index < leftItems.length ? f.format(leftItems[index].value) : '';
                    final rightText = index < rightItems.length ? rightItems[index].key : '';
                    final rightAmount = index < rightItems.length ? f.format(rightItems[index].value) : '';

                    return Container(
                      color: bg,
                      child: Row(
                        children: [
                          _tableCell(leftText, width: particularsWidth),
                          _tableCell(leftAmount, width: amountWidth),
                          _tableCell(rightText, width: particularsWidth),
                          _tableCell(rightAmount, width: amountWidth),
                        ],
                      ),
                    );
                  },
                  childCount: maxRows + 1, // rows + total row
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
            fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: 14),
      ),
    );
  }

  @override
  void dispose() {
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
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_TableHeaderDelegate oldDelegate) =>
      oldDelegate.child != child || oldDelegate.height != height;
}
