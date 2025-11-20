import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/core/widgets/download_button.dart';
import 'package:outlet_expense/core/widgets/shimmer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/date_picker.dart';
import '../bloc/category_sale_report_bloc.dart';
import '../bloc/category_sale_report_event.dart';
import '../bloc/category_sale_report_state.dart';
import '../model/category_sales_report_model.dart';

Future<Uint8List> _generatePdf(Map<String, dynamic> payload) async {
  final reports = (payload['reports'] as List)
      .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
      .toList();
  final double grandTotal = (payload['grandTotal'] as num?)?.toDouble() ?? 0.0;
  final double discountTotal =
      (payload['discountTotal'] as num?)?.toDouble() ?? 0.0;
  final int daysCount = (payload['daysCount'] as int?) ?? 0;

  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.portrait,
        margin: const pw.EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        build: (context) {
        return [
          pw.Center(
            child: pw.Text(
              'Category Sales Report',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 8),
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
                    "Profit",
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
              ...List.generate(reports.length, (i) {
                final r = reports[i];
                final bg = i.isEven ? PdfColors.white : PdfColors.grey100;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: bg),
                  children: [
                    _pwCell('${i + 1}'),
                    _pwCell(r['date'] ?? ''),
                    _pwCell(r['invoiceId'] ?? ''),
                    _pwCell(r['customerName'] ?? ''),
                    _pwCell(r['paymentType'] ?? ''),
                    _pwCell(r['productName'] ?? ''),
                    _pwCell((r['qty'] ?? '').toString()),
                    _pwCell((r['price'] ?? 0).toStringAsFixed(2)),
                    _pwCell((r['purchasePrice'] ?? 0).toStringAsFixed(2)),
                    _pwCell((r['profit'] ?? 0).toStringAsFixed(2)),
                  ],
                );
              }),
              // footer rows
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _pwCell('$daysCount Days', bold: true),
                  _pwCell('Grand Total', bold: true),
                  _pwCell(''),
                  _pwCell(''),
                  _pwCell(''),
                  _pwCell(''),
                  _pwCell(''),
                  _pwCell(grandTotal.toStringAsFixed(2), bold: true),
                  _pwCell('', bold: true),
                  _pwCell('', bold: true),
                ],
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _pwCell('', bold: true),
                  _pwCell('Discount Total', bold: true),
                  for (int i = 0; i < 8; i++)
                    _pwCell(i == 6 ? discountTotal.toStringAsFixed(2) : ''),
                ],
              ),
            ],
          ),
        ];
      },
    ),
  );

  return pdf.save();
}

pw.Widget _pwCell(String text, {bool bold = false}) => pw.Padding(
  padding: const pw.EdgeInsets.all(5),
  child: pw.Text(
    text,
    textAlign: pw.TextAlign.center,
    style: pw.TextStyle(
      fontSize: 9,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
    ),
  ),
);

class CategorySaleReportScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const CategorySaleReportScreen({
    super.key,
    required this.navigatorKey,
    required this.apiClient,
  });

  @override
  State<CategorySaleReportScreen> createState() => _CategorySaleReportScreen();
}

class _CategorySaleReportScreen extends State<CategorySaleReportScreen>   with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  String filter = "All";
  String brandId = "";
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<CategoryReportBloc>();
      bloc.add(
        FetchCategorySaleEvent(
          startDate: startDate!.toIso8601String(),
          endDate: endDate!.toIso8601String(),
          filter: filter,
          brandId: brandId,
        ),
      );
    });
  }

  Future<void> _onDownloadPressed(CategorySaleResponse response) async {
    final payload = <String, dynamic>{
      'reports': response.reports.map((r) {
        return {
          'date': r.date,
          'invoiceId': r.invoiceId,
          'customerName': r.customerName,
          'paymentType': r.paymentType,
          'productName': r.productName,
          'qty': r.qty,
          'price': r.price,
          'purchasePrice': r.purchasePrice,
          'profit': r.profit,
        };
      }).toList(),
      'grandTotal': response.grandTotal,
      'discountTotal': response.discountTotal,
      'daysCount': response.daysCount,
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
      (d ?? DateTime.now()).toIso8601String().split('T').first;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Category Sale Report",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      floatingActionButton:
          BlocSelector<
            CategoryReportBloc,
            CategorySaleReportState,
            CategorySaleResponse?
          >(
            selector: (state) =>
                state is CategorySaleLoaded ? state.reportResponse : null,
            builder: (context, reportResponse) {
              if (reportResponse == null) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 5),
                child: DownloadButton(
                  onPressed: () => _onDownloadPressed(reportResponse),
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
                const SizedBox(width: 5),
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
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      children: ["All", "IMEI", "Normal"].map((item) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
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
                        context.read<CategoryReportBloc>().add(
                          FetchCategorySaleEvent(
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
                              "Please select both start and end dates.",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    BlocBuilder<CategoryReportBloc, CategorySaleReportState>(
                      buildWhen: (prev, current) =>
                          current is CategorySaleLoading ||
                          current is CategorySaleError ||
                          current is CategorySaleLoaded,
                      builder: (context, state) {
                        if (state is CategorySaleLoading) {
                          return ResponsiveShimmer();
                        }
                        if (state is CategorySaleError) {
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
                      CategoryReportBloc,
                      CategorySaleReportState,
                      CategorySaleResponse?
                    >(
                      selector: (state) {
                        if (state is CategorySaleLoaded) {
                          return state.reportResponse;
                        }
                        return null;
                      },
                      builder: (context, data) {
                        if (data == null) {
                          return Center(
                            child: Text(
                              'No data found',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          );
                        }
                        if (data.reports.isEmpty) {
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
    );
  }

  Widget _buildTable(CategorySaleResponse reportResponse) {
    final reports = reportResponse.reports;
    final double totalSales = reports.fold(0.0, (sum, r) => sum + (r.price));
    final double totalPurchase = reports.fold(
      0.0,
      (sum, r) => sum + (r.purchasePrice),
    );
    final double totalProfit = totalSales - totalPurchase;
    final widths = [
      60.0,
      150.0,
      150.0,
      150.0,
      150.0,
      200.0,
      150.0,
      150.0,
      150.0,
      150.0,
    ];
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalScrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: widths.reduce((a, b) => a + b)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFFC8C6C6),
                child: Row(children: _buildHeaderCells(widths)),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: widths.reduce((a, b) => a + b),
                child: ListView.builder(
                  controller: _verticalScrollController,
                  itemCount: reports.length + 1,
                  itemBuilder: (context, index) {
                    if (index == reports.length) {
                      return _footerWidget(
                        reportResponse,
                        widths,
                        totalSales,
                        totalPurchase,
                        totalProfit,
                      );
                    }
                    final r = reports[index];
                    final bg = index.isEven
                        ? Colors.white
                        : const Color(0xFFD6D6D8);
                    return Container(
                      color: bg,

                        child: Row(
                          children: [
                            _cellSized("${index + 1}", widths[0], center: true),
                            _cellSized(r.date, widths[1], center: true),
                            _cellSized(
                              "${r.invoiceId.split('-').first}-${r.invoiceId.split('-').last}",
                              widths[2],
                            center: true),
                            _cellSized(r.customerName, widths[3], center: true),
                            _cellSized(r.paymentType, widths[4], center: true),
                            _cellSized(r.productName, widths[5], center: true),
                            _cellSized(
                              (r.qty).toString(),
                              widths[6],
                              center: true,
                            ),
                            _cellSized(
                              (r.price).toStringAsFixed(2),
                              widths[7],
                              center: true,
                            ),
                            _cellSized(
                              (r.purchasePrice).toStringAsFixed(2),
                              widths[8],
                              center: true,
                            ),
                            _cellSized(
                              (r.profit).toStringAsFixed(2),
                              widths[9],
                              center: true,
                            ),
                          ],
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

  Widget _footerWidget(
    CategorySaleResponse reportResponse,
    List<double> widths,
    double totalSales,
    double totalPurchase,
    double totalProfit,
  ) {
    return Container(
      color: const Color(0xFFC8C6C6),
      child: Row(
        children: [
          _cellSized('${reportResponse.daysCount} Days', widths[0], bold: true),
          _cellSized('Grand Total', widths[1], bold: true),
          _cellSized('', widths[2]),
          _cellSized('', widths[3]),
          _cellSized('', widths[4]),
          _cellSized('', widths[5]),
          _cellSized('', widths[6]),
          _cellSized(totalSales.toStringAsFixed(2), widths[7], bold: true),
          _cellSized(totalPurchase.toStringAsFixed(2), widths[8], bold: true),
          _cellSized(totalProfit.toStringAsFixed(2), widths[9], bold: true),
        ],
      ),
    );
  }

  Widget _cellSized(
    String text,
    double width, {
    bool bold = false,
    bool center = false,
  }) {
    final media = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first,
    );
    final double screenWidth = media.size.width;
    double fontSize = screenWidth < 350
        ? 14
        : screenWidth < 450
        ? 16
        : 18;
    EdgeInsets padding = EdgeInsets.symmetric(
      vertical: screenWidth < 360 ? 5 : 7,
      horizontal: 6,
    );
    return SizedBox(
      width: width,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeaderCells(List<double> widths) {
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
      "Profit",
    ];

    return List.generate(headers.length, (i) {
      return SizedBox(
        width: widths[i],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Text(
            headers[i],
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
    });
  }
}
