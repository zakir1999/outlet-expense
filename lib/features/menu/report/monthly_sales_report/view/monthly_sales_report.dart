import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/core/widgets/shimmer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/download_button.dart';
import '../../../../../core/widgets/responsive_cell.dart';
import '../../../../../core/widgets/date_picker.dart';
import '../bloc/monthly_sales_report_bloc.dart';
import '../bloc/monthly_sales_report_event.dart';
import '../bloc/monthly_sales_report_state.dart';
import '../model/monthly_sales_model.dart';


class MonthlySalesReportScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MonthlySalesReportScreen({super.key, required this.navigatorKey});

  @override
  State<MonthlySalesReportScreen> createState() => _MonthlySaleScreenState();
}

class _MonthlySaleScreenState extends State<MonthlySalesReportScreen> {
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  String filter = "All";
  String brandId = "";
  final ScrollController _scrollController = ScrollController();
  bool _isHovered = false;

  late MonthlySaleReportBloc _reportBloc;

  @override
  void initState() {
    super.initState();

    _reportBloc = MonthlySaleReportBloc(navigatorKey: widget.navigatorKey);

    // Page load auto API hit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (startDate != null && endDate != null) {
        _reportBloc.add(
          FetchMonthlySaleEvent(
            startDate: startDate!.toIso8601String(),
            endDate: endDate!.toIso8601String(),
            filter: filter,
            brandId: brandId,
          ),
        );
      }
    });
  }

  Future<void> _generatePDF(MonthlySalesModel reportResponse) async {
    if (reportResponse.data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No report data available to export.")),
      );
      return;
    }

    final pdf = pw.Document();
    final reports = reportResponse.data;
    final double totalSales = reports.fold(0, (sum, r) => sum + r.price);
    final double totalPurchase =
    reports.fold(0, (sum, r) => sum + r.purchasePrice);
    final double totalProfit = totalSales - totalPurchase;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Monthly Sales Report',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.3),
            columnWidths: const {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(2.5),
              4: pw.FlexColumnWidth(2),
              5: pw.FlexColumnWidth(3),
              6: pw.FlexColumnWidth(1),
              7: pw.FlexColumnWidth(2),
              8: pw.FlexColumnWidth(2),
              9: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  for (var h in [
                    "SL",
                    "Transaction Date",
                    "Voucher Number",
                    "Customer Name",
                    "Order Type",
                    "Product Name",
                    "Qty",
                    "Sales Amount",
                    "Purchase Amount",
                    "Profit"
                  ])
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
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
              ...List.generate(reports.length, (i) {
                final r = reports[i];
                final bgColor =
                i.isEven ? PdfColors.white : PdfColors.grey100;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: bgColor),
                  children: [
                    _pdfCell("${i + 1}"),
                    _pdfCell(r.date),
                    _pdfCell(
                        '${r.invoiceId.split('-').first}-${r.invoiceId.split('-').last}'),
                    _pdfCell(r.customerName),
                    _pdfCell(r.paymentType),
                    _pdfCell(r.productName),
                    _pdfCell(r.qty.toString()),
                    _pdfCell(r.price.toStringAsFixed(2)),
                    _pdfCell(r.purchasePrice.toStringAsFixed(2)),
                    _pdfCell(r.profit.toStringAsFixed(2)),
                  ],
                );
              }),
              _pdfFooterRow(
                days: "${reportResponse.daysCount} Days",
                title: "Grand Total",
                sales: reportResponse.grandTotal,
                purchase: totalPurchase,
                profit: totalProfit,
              ),
              _pdfFooterRow(
                title: "Discount Total",
                sales: reportResponse.discountTotal,
              ),
              _pdfFooterRow(
                title: "Actual Grand Total",
                sales: reportResponse.grandTotal -
                    reportResponse.discountTotal,
              ),
              _pdfFooterRow(
                title: "Profit Total",
                profit: totalProfit - reportResponse.discountTotal,
              ),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.Widget _pdfCell(String text, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.all(5),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        fontSize: 9,
      ),
      maxLines: 2,
      overflow: pw.TextOverflow.clip,
    ),
  );

  pw.TableRow _pdfFooterRow({
    String days = "",
    required String title,
    double? sales,
    double? purchase,
    double? profit,
  }) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: [
        _pdfCell(days, bold: true),
        _pdfCell(title, bold: true),
        _pdfCell(""),
        _pdfCell(""),
        _pdfCell(""),
        _pdfCell(""),
        _pdfCell(""),
        _pdfCell(sales != null ? sales.toStringAsFixed(2) : "", bold: true),
        _pdfCell(
            purchase != null ? purchase.toStringAsFixed(2) : "", bold: true),
        _pdfCell(profit != null ? profit.toStringAsFixed(2) : "", bold: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _reportBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: const Text("Monthly Sales Report", style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        floatingActionButton: BlocBuilder<MonthlySaleReportBloc, MonthlySalesReportState>(
          builder: (context, state) {
            if (state is MonthlySaleLoaded) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 5),
                child: DownloadButton(
                  onPressed: () => _generatePDF(state.reportResponse),
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
                      hintText: (startDate ?? DateTime.now())
                          .toIso8601String()
                          .split("T")
                          .first,
                      initialDate: startDate ?? DateTime.now(),
                      onDateSelected: (date) {
                        setState(() => startDate = date);
                      },
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      children: ["All", "IEMI", "Normal"].map((item) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: item,
                              groupValue: filter,
                              onChanged: (val) =>
                                  setState(() => filter = val!),
                            ),
                            Text(item),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

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
                        _reportBloc.add(
                          FetchMonthlySaleEvent(
                            startDate: startDate!.toIso8601String(),
                            endDate: endDate!.toIso8601String(),
                            filter: filter,
                            brandId: brandId,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please select both start and end dates."),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      BlocBuilder<MonthlySaleReportBloc, MonthlySalesReportState>(
                        builder: (context, state) {
                          if (state is MonthlySaleLoading) {
                            return const ResponsiveShimmer();
                          }
                          if (state is MonthlySaleError) {
                            return Center(
                              child: Text("❌ ${state.message}",
                                  style: const TextStyle(
                                      color: Colors.redAccent)),
                            );
                          }
                          if (state is MonthlySaleLoaded) {
                            if (state.reportResponse.data.isEmpty) {
                              return _buildEmptyState();
                            }
                            return _buildUnifiedTable(state.reportResponse);
                          }
                          return const SizedBox.shrink();
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



  Widget _buildEmptyState() => const Center(
    child: Text(
      "No report data found!",
      style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );

// ... _buildUnifiedTable, _buildHeaderCells, _footerRow remain unchanged

  Widget _buildUnifiedTable(MonthlySalesModel reportResponse) {
    final reports = reportResponse.data;
    double totalSales = reports.fold(0, (sum, r) => sum + r.price);
    double totalPurchase = reports.fold(0, (sum, r) => sum + r.purchasePrice);
    double totalProfit = totalSales - totalPurchase;

    final columnWidths = {
      0: const FixedColumnWidth(60),
      1: const FixedColumnWidth(150),
      2: const FixedColumnWidth(120),
      3: const FixedColumnWidth(120),
      4: const FixedColumnWidth(100),
      5: const FixedColumnWidth(200),
      6: const FixedColumnWidth(60),
      7: const FixedColumnWidth(100),
      8: const FixedColumnWidth(120),
      9: const FixedColumnWidth(100),
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
          ...List.generate(reports.length, (i) {
            final r = reports[i];
            final bgColor =
            i.isEven ? Colors.white : const Color(0xFFF7F8FC);
            return TableRow(
              decoration: BoxDecoration(color: bgColor),
              children: [
                ResponsiveCell(text: "${i + 1}"),
                ResponsiveCell(text: r.date, align: TextAlign.center),
                ResponsiveCell(
                  text:
                  '${r.invoiceId.split('-').first}-${r.invoiceId.split('-').last}',
                  align: TextAlign.center,
                ),
                ResponsiveCell(text: r.customerName, align: TextAlign.center),
                ResponsiveCell(text: r.paymentType, align: TextAlign.center),
                ResponsiveCell(text: r.productName, align: TextAlign.center),
                ResponsiveCell(
                    text: r.qty.toString(), align: TextAlign.center),
                ResponsiveCell(
                    text: r.price.toStringAsFixed(2), align: TextAlign.center),
                ResponsiveCell(
                    text: r.purchasePrice.toStringAsFixed(2),
                    align: TextAlign.center),
                ResponsiveCell(
                    text: r.profit.toStringAsFixed(2),
                    align: TextAlign.center),
              ],
            );
          }),
          _footerRow(
            days: '${reportResponse.daysCount.toString()} Days',
            title: "Grand Total",
            sales: reportResponse.grandTotal,
            purchase: totalPurchase,
            profit: totalProfit,
          ),
          _footerRow(
            title: "Discount Total",
            sales: reportResponse.discountTotal,
          ),
          _footerRow(
            title: "Actual Grand Total",
            sales: reportResponse.grandTotal -
                reportResponse.discountTotal,
          ),
          _footerRow(
            title: 'Profit Total',
            profit: totalProfit - reportResponse.discountTotal,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHeaderCells() {
    final headers = [
      "SL",
      "Transaction\n Date",
      "Voucher\n Number",
      "Customer\n Name",
      "Order\nType",
      "Product\nName",
      "Qty",
      "Sales\nAmount",
      "Purchase\nAmount",
      "Profit"
    ];
    return headers
        .map((h) => Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Text(
        h,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13),
      ),
    ))
        .toList();
  }

  TableRow _footerRow({
    String days = "",
    required String title,
    double? sales,
    double? purchase,
    double? profit,
  }) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFE8E8E8)),
      children: [
        ResponsiveCell(text: days, bold: true),
        ResponsiveCell(text: title, bold: true),
        const ResponsiveCell(text: ""),
        const ResponsiveCell(text: ""),
        const ResponsiveCell(text: ""),
        const ResponsiveCell(text: ""),
        const ResponsiveCell(text: ""),
        ResponsiveCell(
          text: sales != null ? sales.toStringAsFixed(2) : "",
          align: TextAlign.center,
          bold: true,
        ),
        ResponsiveCell(
          text: purchase != null ? purchase.toStringAsFixed(2) : "",
          align: TextAlign.center,
          bold: true,
        ),
        ResponsiveCell(
          text: profit != null ? profit.toStringAsFixed(2) : "",
          align: TextAlign.center,
          bold: true,
        ),
      ],
    );
  }
}
