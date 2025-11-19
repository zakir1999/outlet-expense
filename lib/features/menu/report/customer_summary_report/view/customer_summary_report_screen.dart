//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
//
// import '../../../../../core/api/api_client.dart';
// import '../../../../../core/widgets/button.dart';
// import '../../../../../core/widgets/download_button.dart';
// import '../../../../../core/widgets/drop_down.dart';
// import '../../../../../core/widgets/responsive_cell.dart';
// import '../../../../../core/widgets/date_picker.dart';
// import '../../../../../core/widgets/shimmer.dart';
// import '../bloc/customer_summary_report_bloc.dart';
// import '../bloc/customer_summary_report_event.dart';
// import '../bloc/customer_summary_report_state.dart';
// import '../model/customer_summary_report_model.dart';
// import '../repository/customer_summary_report_repository.dart';
//
// class CustomerSummaryReportScreen extends StatefulWidget {
//   final GlobalKey<NavigatorState> navigatorKey;
//   final ApiClient apiClient;
//
//   const CustomerSummaryReportScreen({
//     super.key,
//     required this.apiClient,
//     required this.navigatorKey,
//   });
//
//   @override
//   State<CustomerSummaryReportScreen> createState() =>
//       _EmployeeWiseSalesReportScreenState();
// }
//
// class _EmployeeWiseSalesReportScreenState
//     extends State<CustomerSummaryReportScreen> {
//   DateTime? startDate;
//   DateTime? endDate;
//   final employeeController = TextEditingController();
//   final ScrollController _employeeIdScrollController = ScrollController();
//   final ScrollController _horizontalScrollController = ScrollController();
//   late final CustomerSummaryReportBloc _bloc;
//
//   Map<String, int> _employeeNameToId = {};
//   int? _selectedEmployeeId;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final today = DateTime.now();
//     startDate = today;
//     endDate = today;
//     employeeController.text = '';
//     _bloc = CustomerSummaryReportBloc(
//       repository: CustomerSummaryReportRepository(apiClient: widget.apiClient),
//     );
//     _bloc.add(FetchCustomerOptions());
//   }
//
//   @override
//   void dispose() {
//     employeeController.dispose();
//     _employeeIdScrollController.dispose();
//     _horizontalScrollController.dispose();
//     _bloc.close();
//     super.dispose();
//   }
//
//   String startDateString() =>
//       (startDate ?? DateTime.now()).toIso8601String().split('T').first;
//
//   String endDateString() =>
//       (endDate ?? DateTime.now()).toIso8601String().split('T').first;
//
//   Future<void> _generatePDF(CustomerSummaryLoaded state) async {
//     if (state.data.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No data to export.")),
//       );
//       return;
//     }
//
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         build: (context) {
//           return [
//             pw.Center(
//               child: pw.Text(
//                 'Customer Summary Report',
//                 style: pw.TextStyle(
//                   fontSize: 18,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//             ),
//             pw.SizedBox(height: 8),
//             pw.Text('Date range: ${startDateString()} - ${endDateString()}'),
//             pw.SizedBox(height: 8),
//             pw.Table(
//               border: pw.TableBorder.all(color: PdfColors.black, width: 0.3),
//               columnWidths: const {
//                 0: pw.FlexColumnWidth(0.8),
//                 1: pw.FlexColumnWidth(1.5),
//                 2: pw.FlexColumnWidth(2),
//                 3: pw.FlexColumnWidth(3),
//                 4: pw.FlexColumnWidth(2.5),
//                 5: pw.FlexColumnWidth(3),
//                 6: pw.FlexColumnWidth(1.5),
//               },
//               children: [
//                 pw.TableRow(
//                   decoration: const pw.BoxDecoration(color: PdfColors.grey300),
//                   children: [
//                     _pdfCell('SL', bold: true),
//                     _pdfCell('Date', bold: true),
//                     _pdfCell('Invoice', bold: true),
//                     _pdfCell('Customer', bold: true),
//                     _pdfCell('Employee', bold: true),
//                     _pdfCell('Products', bold: true),
//                     _pdfCell('Paid (BDT)', bold: true),
//                   ],
//                 ),
//                 ...List.generate(state.data.length, (i) {
//                   final it = state.data[i];
//                   final bg = i.isEven ? PdfColors.white : PdfColors.grey100;
//                   return pw.TableRow(
//                     decoration: pw.BoxDecoration(color: bg),
//                     children: [
//                       _pdfCell('${i + 1}'),
//                       _pdfCell(it.date),
//                       _pdfCell(it.invoiceId),
//                       _pdfCell(it.customerName),
//                       _pdfCell(it.employeeName),
//                       _pdfCell(it.productNames),
//                       _pdfCell(it.paidAmount.toStringAsFixed(2)),
//                     ],
//                   );
//                 }),
//               ],
//             ),
//             pw.SizedBox(height: 10),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.end,
//               children: [
//                 pw.Text(
//                   'Grand Total Paid: ${state.grandTotal.toStringAsFixed(2)}',
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                 ),
//               ],
//             ),
//           ];
//         },
//       ),
//     );
//
//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }
//
//   pw.Widget _pdfCell(String text, {bool bold = false}) => pw.Padding(
//     padding: const pw.EdgeInsets.all(6.0),
//     child: pw.Text(
//       text,
//       textAlign: pw.TextAlign.center,
//       style: pw.TextStyle(
//         fontSize: 10,
//         fontWeight: bold ? pw.FontWeight.bold : null,
//       ),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _bloc,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: Colors.black),
//           backgroundColor: Colors.white,
//           title: const Text(
//             "Customer Summary Report",
//             style: TextStyle(color: Colors.black),
//           ),
//           centerTitle: true,
//         ),
//         floatingActionButton:
//         BlocBuilder<CustomerSummaryReportBloc, CustomerSummaryReportState>(
//           builder: (context, state) {
//             if (state is CustomerSummaryLoaded) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 10, right: 5),
//                 child: DownloadButton(
//                   onPressed: () => _generatePDF(state),
//                   icon: Icons.file_download_rounded,
//                   backgroundColor: Colors.grey.shade800.withOpacity(0.85),
//                   iconColor: Colors.white,
//                   size: 60,
//                   iconSize: 26,
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: BlocBuilder<CustomerSummaryReportBloc,
//                 CustomerSummaryReportState>(
//               builder: (context, state) {
//                 if (state is CustomerSummaryError) {
//                   return Center(child: Text('Error: ${state.message}'));
//                 } else if (state is CustomerSummaryLoaded) {
//                   _employeeNameToId = {
//                     for (var e in state.customerOptions)
//                       e.name: e.id,
//                   };
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomDatePicker(
//                               title: "Start Date",
//                               hintText: startDateString(),
//                               initialDate: startDate ?? DateTime.now(),
//                               onDateSelected: (date) {
//                                 setState(() => startDate = date);
//                                 context.read<CustomerSummaryReportBloc>().add(
//                                   CustomerWiseUpdateDates(
//                                     startDate: startDate,
//                                     endDate: endDate,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: CustomDatePicker(
//                               title: "End Date",
//                               hintText: endDateString(),
//                               initialDate: endDate ?? DateTime.now(),
//                               onDateSelected: (date) {
//                                 setState(() => endDate = date);
//                                 context.read<CustomerSummaryReportBloc>().add(
//                                   CustomerWiseUpdateDates(
//                                     startDate: startDate,
//                                     endDate: endDate,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 2),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomDropdown(
//                               label: "Customer",
//                               options: state.customerOptions.map((e) => e.name).toList(),
//                               selectedValue: state.customerName?.isNotEmpty == true
//                                   ? state.customerName
//                                   : null,
//                               scrollController: _employeeIdScrollController,
//                               onChanged: (value) {
//                                 final selectedName = value ?? '';
//                                 employeeController.text = selectedName;
//                                 _selectedEmployeeId = _employeeNameToId[selectedName];
//
//                                 context.read<CustomerSummaryReportBloc>().add(
//                                   UpdateCustomerName(customerName: selectedName),
//                                 );
//
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 8,),
//                           Container(
//                             margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                             child: SizedBox(
//                               height: 60,
//                               child: CustomAnimatedButton(
//                                 label: "Report",
//                                 icon: Icons.analytics_outlined,
//                                 color: const Color(0xFF3240B6),
//                                 pressedColor: const Color(0xFF26338A),
//                                 width: 150,
//                                 height: 60,
//                                 borderRadius: 24,
//                                 onPressed: () {
//                                   if (_selectedEmployeeId != null && startDate != null && endDate != null) {
//                                     _bloc.add(FetchCustomerSummaryReportEvent(
//                                       startDate: startDate!.toIso8601String(),
//                                       endDate: endDate!.toIso8601String(),
//                                       id: _selectedEmployeeId!,
//                                     ));
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Please select both start/end dates and an employee."),
//                                       ),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Builder(builder: (context) {
//                             if (state is CustomerSummaryLoading) {
//                               return const ResponsiveShimmer();
//                             } else if (state.data.isEmpty) {
//                               return _buildEmptyState();
//                             } else {
//                               return SingleChildScrollView(
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   controller: _horizontalScrollController,
//                                   child: _buildTable(state.data, state.grandTotal.toDouble()),
//                                 ),
//                               );
//                             }
//                           }),
//                         ),
//                       ),
//                     ],
//                   );
//                 } else if (state is CustomerSummaryLoading) {
//                   return const ResponsiveShimmer();
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() => const Center(
//     child: Text(
//       "No data found!",
//       style: TextStyle(fontSize: 16, color: Colors.grey),
//     ),
//   );
//
//   Widget _buildTable(List<CustomerSummaryReportItem> items, double grandTotal) {
//     final columnWidths = {
//       0: const FixedColumnWidth(60),
//       1: const FixedColumnWidth(100),
//       2: const FixedColumnWidth(120),
//       3: const FixedColumnWidth(220),
//       4: const FixedColumnWidth(160),
//       5: const FixedColumnWidth(260),
//       6: const FixedColumnWidth(120),
//     };
//
//     return Table(
//       border: const TableBorder(),
//       columnWidths: columnWidths,
//       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//       children: [
//         TableRow(
//           decoration: const BoxDecoration(color: Color(0xFFEEF0FA)),
//           children: _buildHeaderCells(),
//         ),
//         ...List.generate(items.length, (i) {
//           final it = items[i];
//           final bg = i.isEven ? Colors.white : const Color(0xFFF7F8FC);
//           return TableRow(
//             decoration: BoxDecoration(color: bg),
//             children: [
//               ResponsiveCell(text: '${i + 1}', align: TextAlign.center),
//               ResponsiveCell(text: it.date, align: TextAlign.center),
//               ResponsiveCell(text: it.invoiceId, align: TextAlign.center),
//               ResponsiveCell(text: it.customerName, align: TextAlign.center),
//               ResponsiveCell(text: it.employeeName, align: TextAlign.center),
//               ResponsiveCell(text: it.productNames, align: TextAlign.center),
//               ResponsiveCell(
//                   text: it.paidAmount.toStringAsFixed(2),
//                   align: TextAlign.center),
//             ],
//           );
//         }),
//         TableRow(
//           decoration: const BoxDecoration(color: Color(0xFFEFEFF5)),
//           children: [
//             const SizedBox.shrink(),
//             const SizedBox.shrink(),
//             const SizedBox.shrink(),
//             const SizedBox.shrink(),
//             const SizedBox.shrink(),
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Grand Total: ${grandTotal.toStringAsFixed(2)}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox.shrink(),
//           ],
//         ),
//       ],
//     );
//   }
//
//   List<Widget> _buildHeaderCells() {
//     final headers = [
//       "SL",
//       "Date",
//       "Invoice",
//       "Customer",
//       "Employee",
//       "Products",
//       "Paid Amount(BDT)",
//     ];
//     return headers
//         .map(
//           (h) => Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
//           child: Text(
//             h,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ),
//     )
//         .toList();
//   }
// }

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
import '../bloc/customer_summary_report_bloc.dart';
import '../bloc/customer_summary_report_event.dart';
import '../bloc/customer_summary_report_state.dart';
import '../model/customer_summary_report_model.dart';
import '../repository/customer_summary_report_repository.dart';

class CustomerSummaryReportScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const CustomerSummaryReportScreen({
    super.key,
    required this.apiClient,
    required this.navigatorKey,
  });

  @override
  State<CustomerSummaryReportScreen> createState() =>
      _CustomerSummaryReportScreenState();
}

class _CustomerSummaryReportScreenState
    extends State<CustomerSummaryReportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  final ScrollController _customerScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  late final CustomerSummaryReportBloc _bloc;

  Map<String, int> _customerNameToId = {};
  int? _selectedCustomerId;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    startDate = today;
    endDate = today;

    _bloc = CustomerSummaryReportBloc(
      repository: CustomerSummaryReportRepository(apiClient: widget.apiClient),
    );

    _bloc.add(FetchCustomerOptions());
  }

  @override
  void dispose() {
    _customerScrollController.dispose();
    _horizontalScrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  String startDateString() =>
      (startDate ?? DateTime.now()).toIso8601String().split('T').first;

  String endDateString() =>
      (endDate ?? DateTime.now()).toIso8601String().split('T').first;

  // PDF EXPORT FUNCTION
  Future<void> _generatePDF(CustomerSummaryLoaded state) async {
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
        margin: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'Customer Summary Report',
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
                0: pw.FlexColumnWidth(0.8),
                1: pw.FlexColumnWidth(1.5),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(1),
                4: pw.FlexColumnWidth(1.5),

              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _pdfCell('SL', bold: true),
                    _pdfCell('Date', bold: true),
                    _pdfCell('Invoice', bold: true),

                    _pdfCell('Sub Total', bold: true),
                    _pdfCell('Paid Amount', bold: true),


                  ],
                ),
                ...List.generate(state.data.length, (i) {
                  final it = state.data[i];
                  final bg = i.isEven ? PdfColors.white : PdfColors.grey100;

                  return pw.TableRow(
                    decoration: pw.BoxDecoration(color: bg),
                    children: [
                      _pdfCell('${i + 1}'),
                      _pdfCell(it.createdAt),                 // Date
                      _pdfCell(it.invoiceId),                 // Invoice I// Total quantity
                      _pdfCell(it.subTotal.toStringAsFixed(2)),   // Subtotal
                      _pdfCell(it.paidAmount.toStringAsFixed(2)), // Paid amount

                    ],
                  );
                }),
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
            "Customer Summary Report",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),

        // PDF BUTTON
        floatingActionButton:
        BlocBuilder<CustomerSummaryReportBloc, CustomerSummaryReportState>(
          builder: (context, state) {
            if (state is CustomerSummaryLoaded) {
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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<CustomerSummaryReportBloc,
                CustomerSummaryReportState>(
              builder: (context, state) {
                if (state is CustomerSummaryError) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (state is CustomerSummaryLoaded) {
                  // BUILD CUSTOMER NAME MAP
                  _customerNameToId = {
                    for (var e in state.customerOptions) e.name: e.id,
                  };

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DATE PICKER ROW
                      Row(
                        children: [
                          Expanded(
                            child: CustomDatePicker(
                              title: "Start Date",
                              hintText: startDateString(),
                              initialDate: startDate ?? DateTime.now(),
                              onDateSelected: (date) {
                                setState(() => startDate = date);
                                context
                                    .read<CustomerSummaryReportBloc>()
                                    .add(CustomerWiseUpdateDates(
                                  startDate: startDate,
                                  endDate: endDate,
                                ));
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomDatePicker(
                              title: "End Date",
                              hintText: endDateString(),
                              initialDate: endDate ?? DateTime.now(),
                              onDateSelected: (date) {
                                setState(() => endDate = date);
                                context
                                    .read<CustomerSummaryReportBloc>()
                                    .add(CustomerWiseUpdateDates(
                                  startDate: startDate,
                                  endDate: endDate,
                                ));
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // CUSTOMER DROPDOWN + REPORT BUTTON
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdown(
                              label: "Customer",
                              options: state.customerOptions
                                  .map((e) => e.name)
                                  .toList(),
                              selectedValue:
                              state.customerName?.isNotEmpty == true
                                  ? state.customerName
                                  : null,
                              scrollController: _customerScrollController,
                              onChanged: (value) {
                                final selectedName = value ?? '';
                                _selectedCustomerId =
                                _customerNameToId[selectedName];

                                context
                                    .read<CustomerSummaryReportBloc>()
                                    .add(UpdateCustomerName(
                                    customerName: selectedName));
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              height: 60,
                              child: CustomAnimatedButton(
                                label: "Report",
                                icon: Icons.analytics_outlined,
                                color: const Color(0xFF3240B6),
                                pressedColor: const Color(0xFF26338A),
                                width: 150,
                                height: 60,
                                borderRadius: 24,
                                onPressed: () {
                                  if (_selectedCustomerId != null &&
                                      startDate != null &&
                                      endDate != null) {
                                    _bloc.add(FetchCustomerSummaryReportEvent(
                                      startDate:
                                      startDate!.toIso8601String(),
                                      endDate: endDate!.toIso8601String(),
                                      id: _selectedCustomerId!,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please select both start/end dates and a customer.",
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // TABLE DATA
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Builder(builder: (context) {
                            if (state is CustomerSummaryLoading) {
                              return const ResponsiveShimmer();
                            } else if (state.data.isEmpty) {
                              return _buildEmptyState();
                            }

                            return SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalScrollController,
                                child: _buildTable(
                                  state.data,
                                  state.grandTotal.toDouble(),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                }

                if (state is CustomerSummaryLoading) {
                  return const ResponsiveShimmer();
                }

                return const SizedBox.shrink();
              },
            ),
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

  Widget _buildTable(List<InvoiceItem> items, double grandTotal) {
    final columnWidths = {
      0: const FixedColumnWidth(60),
      1: const FixedColumnWidth(120),
      2: const FixedColumnWidth(150),
      3: const FixedColumnWidth(80),
      4: const FixedColumnWidth(100),
    };

    return Table(
      border: const TableBorder(),
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // HEADER
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFEEF0FA)),
          children: [
            'SL',
            'Date',
            'Invoice',
            'Sub Total',
            'Paid Amount',
          ]
              .map((h) => Center(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              child: Text(
                h,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ))
              .toList(),
        ),

        // DATA ROWS
        ...List.generate(items.length, (i) {
          final it = items[i];
          final bg = i.isEven ? Colors.white : const Color(0xFFF7F8FC);

          return TableRow(
            decoration: BoxDecoration(color: bg),
            children: [
              ResponsiveCell(text: '${i + 1}', align: TextAlign.center),
              ResponsiveCell(text: it.createdAt, align: TextAlign.center),
              ResponsiveCell(text: it.invoiceId, align: TextAlign.center),
              ResponsiveCell(text: it.subTotal.toStringAsFixed(2), align: TextAlign.center),
              ResponsiveCell(text: it.paidAmount.toStringAsFixed(2), align: TextAlign.center),

            ],
          );
        }),

        // GRAND TOTAL ROW
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFEFEFF5)),
          children: [
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Grand Total: ${grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
