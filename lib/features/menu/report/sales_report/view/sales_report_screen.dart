// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// import '../bloc/sales_report_bloc.dart';
// import '../bloc/sales_report_event.dart';
// import '../bloc/sales_report_state.dart';
// import '../sales_model/sales_report_model.dart';
//
// class SalesReportScreen extends StatefulWidget {
//   final GlobalKey<NavigatorState> navigatorKey;
//   const SalesReportScreen({super.key, required this.navigatorKey});
//
//   @override
//   State<SalesReportScreen> createState() => _ReportScreenState();
// }
//
// class _ReportScreenState extends State<SalesReportScreen> {
//   DateTime? startDate;
//   DateTime? endDate;
//   String filter = "All";
//   String brandId = "";
//
//   Future<void> _pickDate(BuildContext context, bool isStart) async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2030),
//     );
//     if (date != null) {
//       setState(() {
//         isStart ? startDate = date : endDate = date;
//       });
//     }
//   }
//
//   void _generatePDF(List<ReportModel> reports) async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.MultiPage(
//         build: (context) => [
//           pw.Text('Sales Report',
//               style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table.fromTextArray(
//             headers: [
//               'Date', 'Invoice', 'Customer', 'Product', 'Qty',
//               'Sale Amt', 'Purchase Amt', 'Profit', 'IMEI'
//             ],
//             data: reports.map((e) {
//               return [
//                 e.date,
//                 e.invoiceId,
//                 e.customerName,
//                 e.productName,
//                 e.qty.toString(),
//                 e.salesAmount.toStringAsFixed(1),
//                 e.purchaseAmount.toStringAsFixed(1),
//                 e.profit.toStringAsFixed(1),
//                 e.imei ?? '-'
//               ];
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//
//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ReportBloc(navigatorKey: widget.navigatorKey),
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Sales Report"), centerTitle: true),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => _pickDate(context, true),
//                       child: Text(startDate == null
//                           ? "Start Date"
//                           : DateFormat('yyyy-MM-dd').format(startDate!)),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => _pickDate(context, false),
//                       child: Text(endDate == null
//                           ? "End Date"
//                           : DateFormat('yyyy-MM-dd').format(endDate!)),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: ["All", "IEMI", "Normal"].map((item) {
//                   return Row(
//                     children: [
//                       Radio<String>(
//                         value: item,
//                         groupValue: filter,
//                         onChanged: (val) => setState(() => filter = val!),
//                       ),
//                       Text(item),
//                     ],
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 12),
//               Expanded(
//                 child: BlocBuilder<ReportBloc, ReportState>(
//                   builder: (context, state) {
//                     if (state is ReportLoading) return _buildShimmer();
//                     if (state is ReportLoaded) {
//                       if (state.reports.isEmpty) return _buildEmptyState();
//                       return Column(
//                         children: [
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: ElevatedButton.icon(
//                               icon: const Icon(Icons.picture_as_pdf),
//                               label: const Text("Export PDF"),
//                               onPressed: () => _generatePDF(state.reports),
//                             ),
//                           ),
//                           Expanded(child: _buildReportTable(state.reports)),
//                         ],
//                       );
//                     }
//                     if (state is ReportError) {
//                       return Center(
//                         child: Text("❌ ${state.message}",
//                             style: const TextStyle(color: Colors.red)),
//                       );
//                     }
//
//                     return Center(
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.analytics),
//                         label: const Text("Generate Report"),
//                         onPressed: () {
//                           if (startDate != null && endDate != null) {
//                             context.read<ReportBloc>().add(FetchReportEvent(
//                               startDate: startDate!.toIso8601String(),
//                               endDate: endDate!.toIso8601String(),
//                               filter: filter,
//                               brandId: brandId,
//                             ));
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text("Please select both dates.")),
//                             );
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShimmer() => ListView.builder(
//     itemCount: 6,
//     itemBuilder: (_, __) => Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//           height: 60,
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           color: Colors.white),
//     ),
//   );
//
//   Widget _buildEmptyState() => const Center(
//     child: Text("No report data found!",
//         style: TextStyle(fontSize: 16, color: Colors.grey)),
//   );
//
//   /// ===================== TABLE UI =====================
//   Widget _buildReportTable(List<ReportModel> reports) {
//     double totalSales = reports.fold(0, (sum, r) => sum + r.salesAmount);
//     double totalPurchase = reports.fold(0, (sum, r) => sum + r.purchaseAmount);
//     double totalProfit = reports.fold(0, (sum, r) => sum + r.profit);
//
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: DataTable(
//                 columnSpacing: 20,
//                 dataRowHeight: 48,
//                 headingRowHeight: 52,
//                 border: TableBorder.all(color: Colors.black, width: 1),
//                 headingRowColor: MaterialStateProperty.all(
//                     const Color(0xFFEEF0FA)), // header bg color
//                 columns: [
//                   DataColumn(
//                     label: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "SL",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Transaction\nDate",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Voucher\nNumber",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Customer\nName",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Order\nType",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Expanded(
//                       child:Center(
//                       child: Text(
//                         "Product\nName",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Qty",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Sales\nAmount",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Purchase\nAmount",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Expanded(child: Center(
//                       child: Text(
//                         "Profit",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ),
//                   ),
//                 ],
//
//                 rows: List.generate(reports.length, (i) {
//                   final r = reports[i];
//                   final isEven = i % 2 == 0;
//                   return DataRow(
//                     color: MaterialStateProperty.all(
//                         isEven ? Colors.white : const Color(0xFFF7F8FC)),
//                     cells: [
//                       DataCell(Text("${i + 1}")),
//                       DataCell(Center(child: Text(r.date))),
//                       DataCell(Center( child:Text(
//                         '${r.invoiceId.split('-').first}-${r.invoiceId.split('-').last}',
//                       ))),
//                       DataCell(Center(child: Text(r.customerName))),
//                       DataCell(Center( child: Text(r.orderTypeName))),
//                       DataCell(Center(child: Text(r.productName))),
//                       DataCell(Text(r.qty.toString())),
//                       DataCell(Center(child:Text(r.salesAmount.toStringAsFixed(2)))),
//                       DataCell(Center( child:Text(r.purchaseAmount.toStringAsFixed(2)))),
//                       DataCell(Center(child:Text(r.profit.toStringAsFixed(2)))),
//
//                     ],
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 10),
//
//         _buildSummaryRow("1 Days", "Grand Total", totalSales, totalPurchase, totalProfit),
//         _buildSummaryRow("", "Discount Total", 0, 0, 0),
//         _buildSummaryRow("", "Actual Grand Total", 0, 0, 0),
//         _buildSummaryRow("", "Profit Total", 0, 0, totalProfit),
//       ],
//     );
//   }
//
//   Widget _buildSummaryRow(
//       String leftText, String title, double sales, double purchase, double profit) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.black, width: 1),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       child: Row(
//         children: [
//           Expanded(flex: 2, child: Text(leftText, style: const TextStyle(fontWeight: FontWeight.bold))),
//           Expanded(flex: 3, child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
//           Expanded(child: Text(sales == 0 ? "0" : sales.toStringAsFixed(2), textAlign: TextAlign.right)),
//           Expanded(child: Text(purchase == 0 ? "0" : purchase.toStringAsFixed(2), textAlign: TextAlign.right)),
//           Expanded(child: Text(profit == 0 ? "0" : profit.toStringAsFixed(2), textAlign: TextAlign.right)),
//         ],
//       ),
//     );
//     }
// }



























import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../../../../../core/widgets/cell.dart';
import '../bloc/sales_report_bloc.dart';
import '../bloc/sales_report_event.dart';
import '../bloc/sales_report_state.dart';
import '../sales_model/sales_report_model.dart';

class SalesReportScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const SalesReportScreen({super.key, required this.navigatorKey});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String filter = "All";
  String brandId = "";
  final ScrollController _scrollController = ScrollController();

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        isStart ? startDate = date : endDate = date;
      });
    }
  }

  void _generatePDF(ReportResponse reportResponse) async {
    final pdf = pw.Document();
    final reports = reportResponse.reports;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Sales Report',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Date',
              'Invoice',
              'Customer',
              'Product',
              'Qty',
              'Sale Amt',
              'Purchase Amt',
              'Profit',
              'IMEI',
            ],
            data: reports.map((e) {
              return [
                e.date,
                e.invoiceId,
                e.customerName,
                e.productName,
                e.qty.toString(),
                e.price.toStringAsFixed(2),
                e.purchasePrice.toStringAsFixed(2),
                (e.price - e.purchasePrice).toStringAsFixed(2),
                e.imei ?? '-',
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
            border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(55),
              1: const pw.FixedColumnWidth(55),
              2: const pw.FixedColumnWidth(65),
              3: const pw.FixedColumnWidth(70),
              4: const pw.FixedColumnWidth(25),
              5: const pw.FixedColumnWidth(50),
              6: const pw.FixedColumnWidth(50),
              7: const pw.FixedColumnWidth(45),
              8: const pw.FixedColumnWidth(60),
            },
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(3),
              2: pw.FlexColumnWidth(3),
            },
            children: [
              _pdfSummaryRow(reportResponse.daysCount.toString(), 'Grand Total',
                  reportResponse.grandTotal, null, null),
              _pdfSummaryRow("", 'Discount Total', reportResponse.discountTotal, null, null),
              _pdfSummaryRow("", 'Actual Grand Total', reportResponse.grandTotal - reportResponse.discountTotal, null, null),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.TableRow _pdfSummaryRow(String days, String title, double? sales, double? purchase, double? profit) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(days, style:  pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            sales != null ? sales.toStringAsFixed(2) : "",
            textAlign: pw.TextAlign.right,
            style:  pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => ReportBloc(navigatorKey: widget.navigatorKey),
      child: Scaffold(
        appBar: AppBar(title: const Text("Sales Report"), centerTitle: true),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _pickDate(context, true),
                                child: Text(startDate == null
                                    ? "Start Date"
                                    : DateFormat('yyyy-MM-dd').format(startDate!)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _pickDate(context, false),
                                child: Text(endDate == null
                                    ? "End Date"
                                    : DateFormat('yyyy-MM-dd').format(endDate!)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          children: ["All", "IEMI", "Normal"].map((item) {
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
                        const SizedBox(height: 12),
                        BlocBuilder<ReportBloc, ReportState>(
                          builder: (context, state) {
                            if (state is ReportLoading) return SizedBox(height: screenHeight * 0.6, child: _buildShimmer());
                            if (state is ReportError) return Center(child: Text("❌ ${state.message}", style: const TextStyle(color: Colors.red)));
                            if (state is ReportLoaded) {
                              if (state.reportResponse.reports.isEmpty) return _buildEmptyState();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.picture_as_pdf_outlined),
                                      label: const Text("Export PDF"),
                                      onPressed: () => _generatePDF(state.reportResponse),
                                    ),
                                  ),
                                  _buildUnifiedTable(state.reportResponse),
                                ],
                              );
                            }
                            return Center(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.analytics_outlined),
                                label: const Text("Generate Report"),
                                onPressed: () {
                                  if (startDate != null && endDate != null) {
                                    context.read<ReportBloc>().add(
                                      FetchReportEvent(
                                        startDate: startDate!.toIso8601String(),
                                        endDate: endDate!.toIso8601String(),
                                        filter: filter,
                                        brandId: brandId,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Please select both dates.")),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmer() => ListView.builder(
    itemCount: 6,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(height: 60, margin: const EdgeInsets.symmetric(vertical: 8), color: Colors.white),
    ),
  );

  Widget _buildEmptyState() => const Center(
    child: Text("No report data found!", style: TextStyle(fontSize: 16, color: Colors.grey)),
  );

  Widget _buildUnifiedTable(ReportResponse reportResponse) {

    final reports = reportResponse.reports;
    double totalSales = reports.fold(0, (sum, r) => sum + r.price);
    double totalPurchase = reports.fold(0, (sum, r) => sum + r.purchasePrice);
     double totalProfit = totalSales-totalPurchase;
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

        border: const TableBorder(
          bottom: BorderSide(color: Colors.black, width: 1),

        ),
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,

        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFEEF0FA)),
            children: _buildHeaderCells(),
          ),
          ...List.generate(reports.length, (i) {
            final r = reports[i];
            final bgColor = i.isEven ? Colors.white : const Color(0xFFF7F8FC);
            return TableRow(
              decoration: BoxDecoration(color: bgColor),
              children: [
                ResponsiveCell(text: "${i + 1}"),
                ResponsiveCell(text: r.date, align: TextAlign.center),
                ResponsiveCell(
                  text: '${r.invoiceId.split('-').first}-${r.invoiceId.split('-').last}',
                  align: TextAlign.center,
                ),
                ResponsiveCell(text: r.customerName, align: TextAlign.center),
                ResponsiveCell(text: r.paymentType, align: TextAlign.center),
                ResponsiveCell(text: r.productName, align: TextAlign.center),
                ResponsiveCell(text: r.qty.toString(), align: TextAlign.center),
                ResponsiveCell(text: r.price.toStringAsFixed(2), align: TextAlign.center),
                ResponsiveCell(text: r.purchasePrice.toStringAsFixed(2), align: TextAlign.center),
                ResponsiveCell(text: r.profit.toStringAsFixed(2), align: TextAlign.center),
              ],

            );
          }),
          _footerRow(days: '${reportResponse.daysCount.toString()}Days', title: "Grand Total", sales: reportResponse.grandTotal,purchase: totalPurchase,profit: totalProfit ),
          _footerRow(title: "Discount Total", sales: reportResponse.discountTotal),
          _footerRow(title: "Actual Grand Total", sales: reportResponse.grandTotal - reportResponse.discountTotal),
          _footerRow(title:'Profit total',profit: totalProfit-reportResponse.discountTotal),
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Text(h, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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


