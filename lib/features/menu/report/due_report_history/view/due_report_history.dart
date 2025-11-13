import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../bloc/due_report_bloc.dart';
import '../bloc/due_report_event.dart';
import '../bloc/due_report_state.dart';
import '../model/due_report_model.dart';
import '../repository/due_report_repository.dart';

class DueReportHistory extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const DueReportHistory({
    super.key,
    required this.apiClient,
    required this.navigatorKey,
  });

  @override
  State<DueReportHistory> createState() =>
      _DueHistoryReport();
}

class _DueHistoryReport
    extends State<DueReportHistory> {
  DateTime? startDate;
  DateTime? endDate;
  final due =TextEditingController();
  final customerOptions=["Customer","Vendor","Wholesaler","Exporter","Carrier"];


  final ScrollController _scrollController = ScrollController();


  late final DueReportBloc _bloc;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate = today;
    endDate = today;
    final due='customer';

    _bloc = DueReportBloc(
      repository: DueReportRepository(apiClient: widget.apiClient),
    );

    // Fetch data initially
    _bloc.add(
      FetchDueReportEvent(
        startDate: startDate!.toIso8601String(),
        endDate: endDate!.toIso8601String(),
        due: due,
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

  Future<void> _generatePDF(DueReportLoaded state) async {
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

                    _pdfCell('Invoice', bold: true),
                    _pdfCell('Name', bold: true),
                    _pdfCell('Paid Amount(BDT)', bold: true),
                    _pdfCell('Total Amount(BDT)', bold: true),
                    _pdfCell('Due(BDT)', bold: true),
                  ],
                ),
                ...List.generate(state.data.length, (i) {
                  final it = state.data[i];
                  final bg = i.isEven ? PdfColors.white : PdfColors.grey100;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(color: bg),
                    children: [
                      _pdfCell('${i + 1}'),
                      _pdfCell(it.invoiceId),
                      _pdfCell(it.name),
                      _pdfCell(it.paidAmount.toStringAsFixed(2)),
                      _pdfCell(it.totalAmount.toStringAsFixed(2)),
                      _pdfCell(it.due.toStringAsFixed(2)),
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
                  'Total Due: ${state.totalDue.toStringAsFixed(2)}',
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
            "Due Report History",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        floatingActionButton: BlocBuilder<DueReportBloc, DueReportState>(
          builder: (context, state) {
            if (state is DueReportLoaded) {
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

        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8, // horizontal space
          runSpacing: 8, // vertical space when wrapped
          children: [
            // Dropdown
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.55, // 55% of screen width
              child: CustomDropdown(
                label: 'Due Type',
                options: customerOptions,
                selectedValue: due.text.isEmpty ? null : due.text,
                onTap: () {},
                onChanged: (value) {
                  setState(() => due.text = value ?? "");
                },
              ),
            ),

            // Button
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: SizedBox(

                width: MediaQuery.of(context).size.width * 0.35, // 35% of screen width
                child: CustomAnimatedButton(
                  label: "Report",
                  icon: Icons.analytics_outlined,
                  color: const Color(0xFF3240B6),
                  pressedColor: const Color(0xFF26338A),
                  fullWidth: true,
                  height: 50,
                  borderRadius: 24,
                  onPressed: () {
                    if (startDate != null && endDate != null) {
                      _bloc.add(
                        FetchDueReportEvent(
                          startDate: startDate!.toIso8601String(),
                          endDate: endDate!.toIso8601String(),
                          due: due.toString(),
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
                ),
              ),
            ),
          ],
        ),

        Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                    BlocBuilder<
                        DueReportBloc,
                        DueReportState
                    >(
                      builder: (context, state) {
                        if (state is DueReportLoading) {
                          return const ResponsiveShimmer();
                        } else if (state is DueReportError) {
                          return Center(
                            child: Text(
                              "❌ ${state.message}",
                              style: const TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          );
                        } else if (state is DueReportLoaded) {
                          if (state.data.isEmpty) {
                            return _buildEmptyState();
                          }
                          return _buildTable(
                            state.data,
                            state.totalDue.toDouble()

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
      List<DueReportData> items,

      double totalDue,
      ) {
    final columnWidths = {
      0: const FixedColumnWidth(60),
      1: const FixedColumnWidth(120),
      2: const FixedColumnWidth(220),
      3: const FixedColumnWidth(120),
      4: const FixedColumnWidth(120),
      5: const FixedColumnWidth(220),
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
                ResponsiveCell(text: it.invoiceId, align: TextAlign.center),
                ResponsiveCell(text: it.name, align: TextAlign.center),
                ResponsiveCell(text: it.paidAmount.toStringAsFixed(2), align: TextAlign.center),
                ResponsiveCell(
                  text: it.totalAmount.toStringAsFixed(2),
                  align: TextAlign.center,
                ),
                ResponsiveCell(
                  text: it.due.toStringAsFixed(2),
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
                    'TotalDue: ${totalDue.toStringAsFixed(2)}',
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
      "Invoice",
      "Name",
      "Paid Amount(BDT)",
      "Total Amount(BDT)",
      "Due(BDT)",
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
