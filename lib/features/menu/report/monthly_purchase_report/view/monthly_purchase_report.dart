import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/download_button.dart';
import '../../../../../core/widgets/responsive_cell.dart';
import '../../../../../core/widgets/date_picker.dart';
import '../../../../../core/widgets/shimmer.dart';
import '../bloc/monthly_purchase_report_bloc.dart';
import '../bloc/monthly_purchase_report_event.dart';
import '../bloc/monthly_purchase_report_state.dart';
import '../model/monthly_purchase_report_model.dart';
import '../repository/monthly_purchase_repository.dart';

class MonthlyPurchaseReportScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const MonthlyPurchaseReportScreen({
    super.key,
    required this.apiClient,
    required this.navigatorKey,
  });

  @override
  State<MonthlyPurchaseReportScreen> createState() =>
      _MonthlyPurchaseReportScreenState();
}

class _MonthlyPurchaseReportScreenState
    extends State<MonthlyPurchaseReportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  final ScrollController _scrollController = ScrollController();


  late final MonthlyPurchaseReportBloc _bloc;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate = today;
    endDate = today;

    _bloc = MonthlyPurchaseReportBloc(
      repository: MonthlyPurchaseRepository(apiClient: widget.apiClient),
    );

    // Fetch data initially
    _bloc.add(
      FetchMonthlyPurchaseEvent(
        startDate: startDate!.toIso8601String(),
        endDate: endDate!.toIso8601String(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  String startDateString() =>
      (startDate ?? DateTime.now()).toIso8601String().split('T').first;

  String endDateString() =>
      (endDate ?? DateTime.now()).toIso8601String().split('T').first;

  Future<void> _generatePDF(MonthlyPurchaseLoaded state) async {
    if (state.data.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No data to export.")));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'Monthly Purchase Day Count',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text('Date range: ${startDateString()} - ${endDateString()}'),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.3),
              columnWidths: const {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(3),
                2: pw.FlexColumnWidth(3),
                3: pw.FlexColumnWidth(2),
                4: pw.FlexColumnWidth(2),
                5: pw.FlexColumnWidth(2),
                6: pw.FlexColumnWidth(3),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _pdfCell('SL', bold: true),
                    _pdfCell('Date', bold: true),
                    _pdfCell('Invoice', bold: true),
                    _pdfCell('Vendor', bold: true),
                    _pdfCell('Product', bold: true),
                    _pdfCell('Qty', bold: true),
                    _pdfCell('Price', bold: true),
                  ],
                ),
                ...List.generate(state.data.length, (i) {
                  final it = state.data[i];
                  final bg = i.isEven ? PdfColors.white : PdfColors.grey100;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(color: bg),
                    children: [
                      _pdfCell('${i + 1}'),
                      _pdfCell(it.date),
                      _pdfCell(it.invoiceId),
                      _pdfCell(it.vendorName),
                      _pdfCell(it.productName),
                      _pdfCell(it.qty.toString()),
                      _pdfCell(it.price.toStringAsFixed(2)),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Grand Total: ${state.grandTotal.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.Widget _pdfCell(String text, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.all(6.0),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: bold ? pw.FontWeight.bold : null,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: const Text(
            "Monthly Purchase Day Count",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        floatingActionButton: BlocBuilder<MonthlyPurchaseReportBloc, MonthlyPurchaseState>(
          builder: (context, state) {
            if (state is MonthlyPurchaseLoaded) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 5),
                child: DownloadButton(
                  onPressed: () => _generatePDF(state),
                  icon: Icons.file_download_rounded,
                  backgroundColor: Colors.grey.shade800.withOpacity(0.85),
                  iconColor: Colors.white,
                  size: 60,
                  iconSize: 26,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      title: "Start Date",
                      hintText: startDateString(),
                      initialDate: startDate ?? DateTime.now(),
                      onDateSelected: (date) =>
                          setState(() => startDate = date),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CustomDatePicker(
                      title: "End Date",
                      hintText: endDateString(),
                      initialDate: endDate ?? DateTime.now(),
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
                        fullWidth: false,
                        width: 150,
                        height: 50,
                        borderRadius: 24,
                        onPressed: () {
                          if (startDate != null && endDate != null) {
                            _bloc.add(
                              FetchMonthlyPurchaseEvent(
                                startDate: startDate!.toIso8601String(),
                                endDate: endDate!.toIso8601String(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select both start and end dates."),
                              ),
                            );
                          }
                        },
                      )


                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        BlocBuilder<
                          MonthlyPurchaseReportBloc,
                          MonthlyPurchaseState
                        >(
                          builder: (context, state) {
                            if (state is MonthlyPurchaseLoading) {
                              return const ResponsiveShimmer();
                            } else if (state is MonthlyPurchaseError) {
                              return Center(
                                child: Text(
                                  "❌ ${state.message}",
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              );
                            } else if (state is MonthlyPurchaseLoaded) {
                              if (state.data.isEmpty) {
                                return _buildEmptyState();
                              }
                              return _buildTable(
                                state.data,
                                state.daysCount,
                                state.grandTotal,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() => const Center(
    child: Text(
      "No data found!",
      style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );

  Widget _buildTable(
    List<MonthlyPurchaseItem> items,
    int daysCount,
    double grandTotal,
  ) {
    final columnWidths = {
      0: const FixedColumnWidth(60),
      1: const FixedColumnWidth(120),
      2: const FixedColumnWidth(220),
      3: const FixedColumnWidth(220),
      4: const FixedColumnWidth(120),
      5: const FixedColumnWidth(120),
      6: const FixedColumnWidth(220),
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Table(
        border: const TableBorder(),
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFEEF0FA)),
            children: _buildHeaderCells(),
          ),
          ...List.generate(items.length, (i) {
            final it = items[i];
            final bg = i.isEven ? Colors.white : const Color(0xFFF7F8FC);
            return TableRow(
              decoration: BoxDecoration(color: bg),
              children: [
                ResponsiveCell(text: '${i + 1}', align: TextAlign.center),
                ResponsiveCell(text: it.date, align: TextAlign.center),
                ResponsiveCell(text: it.invoiceId, align: TextAlign.center),
                ResponsiveCell(text: it.vendorName, align: TextAlign.center),
                ResponsiveCell(text: it.productName, align: TextAlign.center),
                ResponsiveCell(
                  text: it.qty.toString(),
                  align: TextAlign.center,
                ),
                ResponsiveCell(
                  text: it.price.toStringAsFixed(2),
                  align: TextAlign.center,
                ),
              ],
            );
          }),
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFEFEFF5)),
            children: [
              const SizedBox.shrink(),
              const SizedBox.shrink(),
              const SizedBox.shrink(),
              const SizedBox.shrink(),
              const SizedBox.shrink(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Days: $daysCount',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Grand: ${grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHeaderCells() {
    final headers = [
      "SL",
      "Date",
      "Invoice",
      "Vendor",
      "Product",
      "Qty",
      "Price",
    ];
    return headers
        .map(
          (h) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              child: Text(
                h,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
