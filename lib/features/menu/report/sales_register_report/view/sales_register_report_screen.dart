import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/download_button.dart';
import '../../../../../core/widgets/responsive_cell.dart';
import '../../../../../core/widgets/date_picker.dart';
import '../../../../../core/widgets/shimmer.dart';
import '../bloc/sales_register_details_bloc.dart';
import '../bloc/sales_register_details_event.dart';
import '../bloc/sales_register_details_state.dart';
import '../model/sales_register_details_model.dart';
import '../repository/sales_register_details_repository.dart';

class SalesRegisterScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const SalesRegisterScreen({
    super.key,
    required this.navigatorKey,
    required this.apiClient,
  });

  static Widget create({
    required GlobalKey<NavigatorState> navigatorKey,
    required ApiClient apiClient,
  }) {
    return BlocProvider(
      create: (_) => SalesRegisterBloc(
        repository: SalesRegisterRepository(apiClient: apiClient),
      ),
      child: SalesRegisterScreen(
        navigatorKey: navigatorKey,
        apiClient: apiClient,
      ),
    );
  }

  @override
  State<SalesRegisterScreen> createState() => _SalesRegisterScreenState();
}

class _SalesRegisterScreenState extends State<SalesRegisterScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate = today;
    endDate = today;

    // BlocProvider উপরে থাকলে postFrameCallback দরকার নেই
    context.read<SalesRegisterBloc>().add(
      FetchSalesRegisterDetails(
        startDate: _isoDate(today),
        endDate: _isoDate(today),
      ),
    );
  }

  /// সার্ভারে পাঠানোর জন্য তারিখ ফরম্যাট
  String _isoDate(DateTime dt) => dt.toString().split(' ').first;

  /// PDF রিপোর্ট জেনারেটর
  Future<void> _generatePDF(SalesRegisterDetailsModel response) async {
    if (response.data.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No Recode found')));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        build: (pw.Context ctx) {
          return [
            pw.Center(
              child: pw.Text(
                'Sales Register  Report',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'From: ${_isoDate(startDate!)}   To: ${_isoDate(endDate!)}',
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: [
                'Date',
                'SL IMEI',
                'Sales Discount',
                'Normal',
                'Gift',
                'Gift Amount',
                'Sales Amount',
              ],
              data: response.data.asMap().entries.map((e) {
                final d = e.value;
                return [
                  d.date,
                  d.slImei.toString(),
                  d.salesDiscount.toString(),
                  d.normal.toString(),
                  d.gift.toString(),
                  d.giftAmount.toString(),
                  d.salesAmount.toString(),

                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
              ),
              cellStyle: pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              border: pw.TableBorder.all(width: 0.4, color: PdfColors.grey600),
            ),
          ];
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }



  Widget _buildEmptyState() => const Center(
    child: Text(
      "No recode found",
      style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );

  Widget _buildTable(SalesRegisterDetailsModel response) {
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
              decoration: const BoxDecoration(color: Color(0xFFEEF0FA)),
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
              decoration: const BoxDecoration(color: Color(0xFF919393)),
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
              decoration: const BoxDecoration(color: Color(0xFF919393)),
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
                ResponsiveCell(
 text: '',
                ),
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

  /// টেবিল হেডার
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

  @override
  Widget build(BuildContext context) {
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
        elevation: 0.6,
      ),



      floatingActionButton: BlocBuilder<SalesRegisterBloc, SalesRegisterDetailsState>(
        builder: (context, state) {
          if (state is SalesRegisterLoaded) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 5),
              child: DownloadButton(
                onPressed: () => _generatePDF(state.response),
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // 🔹 তারিখ ফিল্টার রো
              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      title: "Start Date",
                      hintText: (startDate ?? DateTime.now())
                          .toIso8601String()
                          .split("T")
                          .first,
                      initialDate: startDate ?? DateTime.now(),
                      onDateSelected: (date) =>
                          setState(() => startDate = date),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CustomDatePicker(
                      title: "End Date",
                      hintText: (endDate ?? DateTime.now())
                          .toIso8601String()
                          .split("T")
                          .first,
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
                        context.read<SalesRegisterBloc>().add(
                          FetchSalesRegisterDetails(
                            startDate: _isoDate(startDate!),
                            endDate: _isoDate(endDate!),
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
                  )








                ],
              ),
              Expanded(
                child:
                    BlocBuilder<SalesRegisterBloc, SalesRegisterDetailsState>(
                      builder: (context, state) {
                        if (state is SalesRegisterLoading) {
                          return ResponsiveShimmer();
                        } else if (state is SalesRegisterError) {
                          return Center(
                            child: Text(
                              '❌ ${state.message}',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          );
                        } else if (state is SalesRegisterLoaded) {
                          return state.response.data.isEmpty
                              ? _buildEmptyState()
                              : _buildTable(state.response);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
