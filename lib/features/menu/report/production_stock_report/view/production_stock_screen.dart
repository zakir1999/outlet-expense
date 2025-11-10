import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../../../../../core/api/api_client.dart';
import '../bloc/production_stock_bloc.dart';
import '../bloc/production_stock_event.dart';
import '../bloc/production_stock_state.dart';

import '../../../../../core/widgets/cell.dart';
import '../../../../../core/widgets/date_picker.dart';
import '../model/production_stock_model.dart';

class ProductionStockScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;
  const ProductionStockScreen({
    super.key,
    required this.apiClient,
    required this.navigatorKey,
  });

  @override
  State<ProductionStockScreen> createState() => _ProductionStockScreenState();
}

class _ProductionStockScreenState extends State<ProductionStockScreen> {
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate = today;
    endDate = today;

    // ✅ একবারই API ফেচ করবো
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductionStockBloc>().add(
        FetchProductionStockEvent(
          startDate: today.toIso8601String(),
          endDate: today.toIso8601String(),
        ),
      );
    });
  }

  Future<void> _generatePDF(ProductionStockResponse response) async {
    if (response.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No data to export.")),
      );
      return;
    }

    final pdf = pw.Document();
    final items = response.items;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'Product Stock Report',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.3),
              columnWidths: const {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(4),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(2),
                4: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _pdfCell('SL', bold: true),
                    _pdfCell('Product Name', bold: true),
                    _pdfCell('Current Stock', bold: true),
                    _pdfCell('Purchase Price', bold: true),
                    _pdfCell('Total Price', bold: true),
                  ],
                ),
                ...List.generate(items.length, (i) {
                  final it = items[i];
                  final total = it.currentStock * it.purchasePrice;
                  final bg = i.isEven ? PdfColors.white : PdfColors.grey100;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(color: bg),
                    children: [
                      _pdfCell('${i + 1}'),
                      _pdfCell(it.name),
                      _pdfCell(it.currentStock.toString()),
                      _pdfCell(it.purchasePrice.toString()),
                      _pdfCell(total.toStringAsFixed(2)),
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
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // ✅ BlocProvider এখন বাইরের লেভেলে থাকবে, এখানে নয়।
    // তাই নিচে Scaffold সরাসরি রাখা হলো।
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text("Product Stock History",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      floatingActionButton:
      BlocBuilder<ProductionStockBloc, ProductionStockState>(
        builder: (context, state) {
          if (state is ProductionStockLoaded) {
            return MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedScale(
                scale: _isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 120),
                child: FloatingActionButton(
                  onPressed: () => _generatePDF(state.response),
                  backgroundColor:
                  _isHovered ? Colors.blueGrey : Colors.grey,
                  elevation: _isHovered ? 8 : 4,
                  child: const Icon(Icons.file_download,
                      color: Colors.white, size: 28),
                ),
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
                    onDateSelected: (date) => setState(() => startDate = date),
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
                Container(
                  margin: const EdgeInsets.all(8),
                  width: 150,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3240B6),
                    ),
                    icon: const Icon(Icons.analytics_outlined,
                        color: Colors.white),
                    label: const Text(
                      "Report",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (startDate != null && endDate != null) {
                        context.read<ProductionStockBloc>().add(
                          FetchProductionStockEvent(
                            startDate: startDate!.toIso8601String(),
                            endDate: endDate!.toIso8601String(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text("Please select both start and end dates.")),
                        );
                      }
                    },
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
                  BlocBuilder<ProductionStockBloc, ProductionStockState>(
                    builder: (context, state) {
                      if (state is ProductionStockLoading) {
                        return _buildShimmer();
                      }
                      if (state is ProductionStockError) {
                        return Center(
                            child: Text("❌ ${state.message}",
                                style:
                                const TextStyle(color: Colors.redAccent)));
                      }
                      if (state is ProductionStockLoaded) {
                        if (state.response.items.isEmpty) {
                          return _buildEmptyState();
                        }
                        return _buildTable(state.response);
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
    );
  }

  Widget _buildShimmer() => ListView.builder(
    itemCount: 8,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.white),
    ),
  );

  Widget _buildEmptyState() => const Center(
      child:
      Text("No data found!", style: TextStyle(fontSize: 16, color: Colors.grey)));

  Widget _buildTable(ProductionStockResponse response) {
    final items = response.items;
    final columnWidths = {
      0: const FixedColumnWidth(60),
      1: const FixedColumnWidth(300),
      2: const FixedColumnWidth(120),
      3: const FixedColumnWidth(120),
      4: const FixedColumnWidth(120),
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
            final total = it.currentStock * it.purchasePrice;
            return TableRow(
              decoration: BoxDecoration(color: bg),
              children: [
                ResponsiveCell(text: '${i + 1}', align: TextAlign.center),
                ResponsiveCell(text: it.name, align: TextAlign.center),
                ResponsiveCell(
                    text: it.currentStock.toString(), align: TextAlign.center),
                ResponsiveCell(
                    text: it.purchasePrice.toString(), align: TextAlign.center),
                ResponsiveCell(
                    text: total.toStringAsFixed(2), align: TextAlign.center),
              ],
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildHeaderCells() {
    final headers = [
      "SL",
      "Product Name",
      "Current Stock",
      "Purchase Price",
      "Total Price"
    ];
    return headers
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
        .toList();
  }
}
