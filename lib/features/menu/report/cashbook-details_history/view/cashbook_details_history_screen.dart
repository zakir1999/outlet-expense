import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/download_button.dart';
import '../../../../../core/widgets/drop_down.dart';
import '../../../../../core/widgets/responsive_cell.dart';
import '../../../../../core/widgets/date_picker.dart';
import '../../../../../core/widgets/shimmer.dart';
import '../bloc/cashbook_details_history_bloc.dart';
import '../bloc/cashbook_details_history_event.dart';
import '../bloc/cashbook_details_history_state.dart';
import '../model/cashbook_details_model.dart';
import '../repository/cashbook_repository.dart';


class TransactionReportScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const TransactionReportScreen({
    super.key,
    required this.apiClient,
    required this.navigatorKey,
  });

  @override
  State<TransactionReportScreen> createState() =>
      _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {


  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  Map<String, int> _paymentMap = {};
  int? _selectedPaymentTypeId;
  String _orderType = "asc";

  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  late final CashbookDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate = today;
    endDate = today;

    _bloc = CashbookDetailsBloc(
      repository: CashbookDetailsRepository(apiClient: widget.apiClient),
    );

    _bloc.add(FetchPaymentTypeOptions());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _horizontalController.dispose();
    _bloc.close();
    super.dispose();
  }

  String _fmt(DateTime? d) =>
      (d ?? DateTime.now()).toIso8601String().split('T').first;

  Future<void> _generatePDF(CashbookDetailsLoaded state) async {
    if (state.data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No data to export.")),
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(12),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'Case Book Details History',
                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Text('Date Range: ${_fmt(state.startDate)} - ${_fmt(state.endDate)}'),
            pw.SizedBox(height: 6),
            pw.Text('Payment Type: ${state.paymentTypeName ?? "-"}'),
            pw.SizedBox(height: 12),

            // TABLE
            pw.Table(
              border: pw.TableBorder.all(width: 0.3),
              columnWidths: const {
                0: pw.FlexColumnWidth(0.7),
                1: pw.FlexColumnWidth(1.4),
                2: pw.FlexColumnWidth(1.4),
                3: pw.FlexColumnWidth(1.4),
                4: pw.FlexColumnWidth(1.4),
                5: pw.FlexColumnWidth(1.4),
                6: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _pdfHeader('SL'),
                    _pdfHeader('Date'),
                    _pdfHeader('Status'),
                    _pdfHeader('Type'),
                    _pdfHeader('Invoice'),
                    _pdfHeader('Amount'),
                    _pdfHeader('Particulars'),
                  ],
                ),
                ...List.generate(state.data.length, (i) {
                  final TransactionItem item = state.data[i];
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                        color: i.isEven
                            ? PdfColors.grey100
                            : PdfColors.white),
                    children: [
                      _pdfCell('${i + 1}'),
                      _pdfCell(item.date),
                      _pdfCell(item.status),
                      _pdfCell(item.typeName),
                      _pdfCell(item.invoiceId),
                      _pdfCell(item.paymentAmount.toStringAsFixed(2)),
                      _pdfCell(item.particulars ?? ''),
                    ],
                  );
                })
              ],
            ),

            pw.SizedBox(height: 12),
            pw.Text(
              "Opening Balance: ${state.openingBalance}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "Total Credit: ${state.currentTotalCredit}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "Total Debit: ${state.currentTotalDebit}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "Closing Balance: ${state.closingBalance}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.Widget _pdfHeader(String text) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      );

  pw.Widget _pdfCell(String text) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(text, textAlign: pw.TextAlign.center),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Cash Book Details History",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
        ),

        floatingActionButton:
        BlocBuilder<CashbookDetailsBloc, CashbookDetailsState>(
          builder: (_, state) {
            if (state is CashbookDetailsLoaded && state.data.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 6),
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

        body: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<CashbookDetailsBloc, CashbookDetailsState>(
            builder: (context, state) {
              if (state is CashbookDetailsLoading) {
                return const ResponsiveShimmer();
              }
              if (state is CashbookDetailsError) {
                return Center(child: Text("Error: ${state.message}"));
              }

              if (state is CashbookDetailsLoaded) {
                _paymentMap = {
                  for (var p in state.paymentTypes) p.typeName: p.id
                };

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomDatePicker(
                            title: "Start Date",
                            hintText: _fmt(state.startDate),
                            initialDate: state.startDate ?? DateTime.now(),
                            onDateSelected: (date) {
                              setState(() {
                                startDate=date;
                              });
                              _bloc.add(UpdateCashbookDateRange(
                                  startDate: date, endDate: state.endDate));
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomDatePicker(
                            title: "End Date",
                            hintText: _fmt(state.endDate),
                            initialDate: state.endDate ?? DateTime.now(),
                            onDateSelected: (date) {
                              setState(() {
                                endDate = date;
                              });
                              _bloc.add(UpdateCashbookDateRange(
                                  startDate: state.startDate, endDate: date));
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdown(
                            label: "Payment Type",
                            options:
                            state.paymentTypes.map((e) => e.typeName).toList(),
                            selectedValue:
                            state.paymentTypeName?.isNotEmpty == true
                                ? state.paymentTypeName
                                : null,
                            onChanged: (value) {
                              final id = _paymentMap[value] ?? 0;
                              _selectedPaymentTypeId = id;

                              _bloc.add(UpdatePaymentTypeSelection(
                                  id: id, name: value));
                            },
                          ),
                        ),
                        const SizedBox(width:2),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Order"),
                            Row(
                              children: [
                                Radio<String>(
                                  value: "asc",
                                  groupValue: state.orderType,
                                  onChanged: (v) {
                                    _bloc.add(UpdateOrderType(v!));
                                  },
                                ),
                                const Text("ASC"),
                                Radio<String>(
                                  value: "desc",
                                  groupValue: state.orderType,
                                  onChanged: (v) {
                                    _bloc.add(UpdateOrderType(v!));
                                  },
                                ),
                                const Text("DESC"),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomAnimatedButton(
                        label: "Report",
                        icon: Icons.analytics,
                        color: const Color(0xFF3240B6),
                        pressedColor: const Color(0xFF26338A),
                        width: 150,
                        height: 50,
                        borderRadius: 24,
                        onPressed: () {
                          if (state.startDate == null ||
                              state.endDate == null ||
                              state.paymentTypeId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select date range & payment type")));
                            return;
                          }

                          _bloc.add(FetchCashbookDetailsReport(
                            startDate: state.startDate!.toIso8601String(),
                            endDate:state.endDate!.toIso8601String(),
                            paymentTypeId: state.paymentTypeId!,
                            orderType: state.orderType,
                          ));
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: state.data.isEmpty
                          ? const Center(
                          child: Text("No data found!",
                              style:
                              TextStyle(fontSize: 16, color: Colors.grey)))
                          : SingleChildScrollView(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _horizontalController,
                          child: _buildTable(state),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTable(CashbookDetailsLoaded state) {
    List<TransactionItem> items = state.data.cast<TransactionItem>();

    final columnWidths = {
      0: const FixedColumnWidth(60),
      1: const FixedColumnWidth(100),
      2: const FixedColumnWidth(120),
      3: const FixedColumnWidth(150),
      4: const FixedColumnWidth(120),
      5: const FixedColumnWidth(120),
      6: const FixedColumnWidth(250),
    };

    return Table(
      border: const TableBorder(),
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFEEF0FA)),
          children: [
            _header("SL"),
            _header("Date"),
            _header("Status"),
            _header("Type"),
            _header("Invoice"),
            _header("Amount"),
            _header("Particulars"),
          ],
        ),

        ...List.generate(items.length, (i) {
          final it = items[i];
          final bg = i.isEven ? Colors.white : const Color(0xFFF7F8FC);

          return TableRow(
            decoration: BoxDecoration(color: bg),
            children: [
              ResponsiveCell(text: "${i + 1}", align: TextAlign.center),
              ResponsiveCell(text: it.date, align: TextAlign.center),
              ResponsiveCell(text: it.status, align: TextAlign.center),
              ResponsiveCell(text: it.typeName, align: TextAlign.center),
              ResponsiveCell(text: it.invoiceId, align: TextAlign.center),
              ResponsiveCell(
                  text: it.paymentAmount.toStringAsFixed(2),
                  align: TextAlign.center),
              ResponsiveCell(text: it.particulars ?? "", align: TextAlign.center),
            ],
          );
        }),

        // TOTALS FOOTER
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFEFEFF5)),
          children: [
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Closing Balance",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )),
            Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.closingBalance.toStringAsFixed(2),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }

  Widget _header(String text) => Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14)),
    ),
  );
}
