import 'package:flutter/foundation.dart';
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
import '../bloc/sales_register_bloc.dart';
import '../bloc/sales_register_event.dart';
import '../bloc/sales_register_state.dart';
import '../model/sales_register_details_model.dart';

Future<Uint8List> _generatePdf(Map<String, dynamic> payload) async {
  final reports = (payload['reports'] as List)
      .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
      .toList();

  final pdf = pw.Document();

  String formatNum(dynamic value, {int fraction = 2}) {
    if (value == null) return "0.00";
    if (value is num) return value.toStringAsFixed(fraction);
    if (value is String) {
      final parsed = num.tryParse(value);
      if (parsed != null) return parsed.toStringAsFixed(fraction);
    }
    return "0.00";
  }



  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.portrait,
      margin: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      build: (pw.Context ctx) {
        return [
          pw.Center(
            child: pw.Text(
              'Sales Register Report',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 8),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.3),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(2),
              4: pw.FlexColumnWidth(2),
              5: pw.FlexColumnWidth(2),
              6: pw.FlexColumnWidth(2),
            },
            children: [
              // Header Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  for (var h in [
                    'Date',
                    'SL/IMEI',
                    'Sales Discount',
                    'Normal',
                    'Gift',
                    'Gift Amount',
                    'Sales Amount',
                  ])
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        h,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),

              // Data Rows
              ...List.generate(reports.length, (i) {
                final r = reports[i];
                final bg = i.isEven ? PdfColors.white : PdfColors.grey100;

                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: bg),
                  children: [
                    _pwCell(r['date'] ?? ''),
                    _pwCell(r['SL/IMEI'] ?? ''),
                    _pwCell(formatNum(r['Sales Discount'], fraction: 2)),
                    _pwCell(r['Normal']?.toString() ?? '0'),
                    _pwCell(r['Gift']?.toString() ?? '0'),
                    _pwCell(formatNum(r['Gift Amount'], fraction: 2)),
                    _pwCell(formatNum(r['Sales Amount'], fraction: 2)),
                  ],
                );
              }),
            ],
          ),
        ];
      },
    ),
  );

  return pdf.save();
}
pw.Widget _pwCell(dynamic value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(3),
    child: pw.Text(
      value.toString(),
      style: const pw.TextStyle(fontSize: 9),
      textAlign: pw.TextAlign.center,
    ),
  );
}

class SalesRegisterScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const SalesRegisterScreen({
    super.key,
    required this.navigatorKey,
    required this.apiClient,
  });

  @override
  State<SalesRegisterScreen> createState() => _SalesRegisterScreenState();
}

class _SalesRegisterScreenState extends State<SalesRegisterScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<SalesRegisterBloc>();
      bloc.add(
        FetchSalesRegister(
          startDate: startDate!.toIso8601String(),
          endDate: endDate!.toIso8601String(),
        ),
      );
    });
  }

  Future<void> _onDownloadPressed(SalesRegisterModel response) async {
    final payload = <String, dynamic>{
      'reports': response.data.map((r) {
        return {
          'date': r.date,
          'SL/IMEI': r.slImei,
          'Normal': r.normal,
          'Sales Amount': r.salesAmount,
          'Sales Discount': r.salesDiscount,
          'Gift': r.gift,
          'Gift Amount': r.giftAmount,
        };
      }).toList(),
      'Total Sales Amount': response.totalSalesAmount,
      'Total Discount Amount': response.totalDiscountAmount,
    };

    final bytes = await compute(_generatePdf, payload);
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime? d) =>
      (d ?? DateTime.now())
          .toIso8601String()
          .split('T')
          .first;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sales Register Report',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),

      floatingActionButton:
      BlocSelector<
          SalesRegisterBloc,
          SalesRegisterState,
          SalesRegisterModel?
      >(
        selector: (state) =>
        state is SalesRegisterLoaded ? state.response : null,

        builder: (context, response) {
          if (response == null) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 5),
            child: DownloadButton(
              onPressed: () => _onDownloadPressed(response),
              icon: Icons.file_download_rounded,
              backgroundColor: Color(0xF2959292),
              iconColor: Colors.white,
              size: 60,
              iconSize: 26,
            ),
          );
        },
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [

              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      title: "Start Date",
                      hintText: _fmtDate(startDate),
                      initialDate: startDate ?? DateTime.now(),
                      onDateSelected: (date) {
                        setState(() => startDate = date);
                      },
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: CustomDatePicker(
                      title: "End Date",
                      hintText: _fmtDate(endDate),
                      initialDate: endDate,
                      onDateSelected: (date) {
                        setState(() => endDate = date);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
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
                        context.read<SalesRegisterBloc>().add(
                          FetchSalesRegister(
                            startDate: startDate!.toIso8601String(),
                            endDate: endDate!.toIso8601String(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select both start and end dates.",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      BlocBuilder<SalesRegisterBloc, SalesRegisterState>(
                        buildWhen: (prev, current) =>
                        current is SalesRegisterLoading ||
                            current is SalesRegisterError ||
                            current is SalesRegisterLoaded,
                        builder: (context, state) {
                          if (state is SalesRegisterLoading) {
                            return ResponsiveShimmer();
                          }
                          if (state is SalesRegisterError) {
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
                      BlocSelector<
                          SalesRegisterBloc,
                          SalesRegisterState,
                          SalesRegisterModel?
                      >(
                        selector: (state) {
                          if (state is SalesRegisterLoaded) {
                            return state.response;
                          }
                          return null;
                        },
                        builder: (context, data) {
                          if (data == null) {
                            return Center(
                              child: Text(
                                'No report data found',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            );
                          }
                          if (data.data.isEmpty) {
                            return Center(
                              child: Text(
                                "No report data found!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return _buildTable(data);
                        },
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTable(SalesRegisterModel response) {
    final items = response.data;
    final columnWidths = {
      0: const FixedColumnWidth(140),
      1: const FixedColumnWidth(140),
      2: const FixedColumnWidth(140),
      3: const FixedColumnWidth(100),
      4: const FixedColumnWidth(90),
      5: const FixedColumnWidth(90),
      6: const FixedColumnWidth(120),
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Table(
          border: const TableBorder(),
          columnWidths: columnWidths,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFC8C6C6)),
              children: _buildHeaderCells(),
            ),
            ...List.generate(items.length, (i) {
              final it = items[i];
              final bg = i.isEven ? Colors.white : const Color(0xFFF7F8FC);
              return TableRow(
                decoration: BoxDecoration(color: bg),
                children: [
                  ResponsiveCell(text: it.date, align: TextAlign.center),
                  ResponsiveCell(
                    text: it.slImei.toString(),
                    align: TextAlign.center,
                  ),
                  ResponsiveCell(
                    text: it.normal.toString(),
                    align: TextAlign.center,
                  ),
                  ResponsiveCell(
                    text: it.gift.toString(),
                    align: TextAlign.center,
                  ),
                  ResponsiveCell(
                    text: it.giftAmount.toString(),
                    align: TextAlign.center,
                  ),
                  ResponsiveCell(
                    text: it.salesDiscount.toString(),
                    align: TextAlign.center,
                  ),
                  ResponsiveCell(
                    text: it.salesAmount.toString(),
                    align: TextAlign.center,
                  ),
                ],
              );
            }),
            // মোট সারি
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFC8C6C6)),
              children: [
                ResponsiveCell(
                  text: 'Total Discount',
                  align: TextAlign.center,
                  bold: true,
                ),
                const ResponsiveCell(text: ''),

                const ResponsiveCell(text: ''),
                const ResponsiveCell(text: ''),
                const ResponsiveCell(text: ''),
                const ResponsiveCell(text: ''),
                ResponsiveCell(
                  text: response.totalDiscountAmount.toString(),
                  align: TextAlign.center,
                  bold: true,
                ),
              ],
            ),
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFC8C6C6)),
              children: [
                ResponsiveCell(
                  text: 'Grand Total',
                  align: TextAlign.center,
                  bold: true,
                ),
                const ResponsiveCell(text: ''),

                const ResponsiveCell(text: ''),
                const ResponsiveCell(text: ''),
                const ResponsiveCell(text: ''),
                ResponsiveCell(text: ''),
                ResponsiveCell(
                  text: response.totalSalesAmount.toString(),
                  align: TextAlign.center,
                  bold: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHeaderCells() {
    final headers = [
      'Date',
      'SL/IMEI',
      'Normal',
      'Gift',
      'Gift Amount',
      'Sales Discount',
      'Sales Amount',
    ];
    return headers
        .map(
          (h) => ResponsiveCell(text: h, bold: true, align: TextAlign.center),
    )
        .toList();
  }
}