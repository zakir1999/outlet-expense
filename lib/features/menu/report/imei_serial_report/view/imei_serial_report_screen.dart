import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:outlet_expense/core/theme/app_colors.dart';
import 'package:outlet_expense/core/widgets/drop_down.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/widgets/TextField.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/download_button.dart';
import '../bloc/imei_event.dart';
import '../bloc/imei_state.dart';
import '../bloc/imei_bloc.dart';
import '../model/imei_model.dart';
import '../repository/imei_report_repository.dart';

import 'package:pdf/widgets.dart' as pw; // ✅ correct
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';




class ImeiSerialReportScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const ImeiSerialReportScreen({
    super.key,
    required this.navigatorKey,
    required this.apiClient,
  });

  @override
  Widget build(BuildContext context) {
    final repository = ImeiSerialReportRepository(apiClient: apiClient);
    return BlocProvider(
      create: (context) => ImeiSerialReportBloc(repository: repository),
      child: const ImeiSerialReportView(),
    );
  }
}

class ImeiSerialReportView extends StatefulWidget {
  const ImeiSerialReportView({Key? key}) : super(key: key);

  @override
  State<ImeiSerialReportView> createState() => _ImeiSerialReportViewState();
}

class _ImeiSerialReportViewState extends State<ImeiSerialReportView> {
  final ScrollController _customerScrollController = ScrollController();

  bool _isDateSelected = false;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();

  final _customerCtrl = TextEditingController();
  final _vendorCtrl = TextEditingController();
  final _productCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _imeiCtrl = TextEditingController();
  final _conditionCtrl = TextEditingController();

  String _stockType = '';

  @override
  void initState() {
    super.initState();
    context.read<ImeiSerialReportBloc>().add(FetchAllDropdownOptions());
  }

  // Helper Methods
  String _formatDate(DateTime? date) =>
      date == null ? '' : DateFormat('yyyy-MM-dd').format(date);

  Future<void> _pickStartDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
      context.read<ImeiSerialReportBloc>().add(
        ImeiSerialReportUpdateDates(startDate: _startDate, endDate: _endDate),
      );
    }
  }


  // 🆕 Function to Generate PDF from the current grouped table
  Future<void> _generatePDF(Map<String, List<ImeiSerialRecord>> groups) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) => [
          pw.Center(
            child: pw.Text(
              'IMEI / Serial Report',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 12),

          for (final entry in groups.entries) ...[
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 6),
              child: pw.Text(
                entry.key,
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ),

            pw.Table.fromTextArray(
              headers: [
                'Date',
                'Brand',
                'Product Name',
                'IMEI/Serial',
                'Invoice No.',
                'Purchase Price',
                'Sale Price',
                'Product Condition',
                'Vendor Name',
                'Customer Name',
              ],
              data: entry.value.map((r) {
                return [
                  r.date ?? '',
                  r.brandName ?? '',
                  r.productName ?? '',
                  r.imei ?? '',
                  (r.purchaseInvoice?.isNotEmpty == true
                      ? r.purchaseInvoice
                      : r.saleInvoice) ?? '',
                  (r.purchasePrice ?? 0).toString(),
                  (r.salePrice ?? 0).toString(),
                  r.productCondition ?? '',
                  r.vendorName ?? '',
                  r.customerName ?? '',
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              border: pw.TableBorder.all(width: 0.4, color: PdfColors.grey600),
              cellAlignment: pw.Alignment.centerLeft,

              // ✅ Correct columnWidths usage
              columnWidths: {
                0: pw.FractionColumnWidth(0.10),
                1: pw.FractionColumnWidth(0.10),
                2: pw.FractionColumnWidth(0.20),
                3: pw.FractionColumnWidth(0.12),
                4: pw.FractionColumnWidth(0.12),
                5: pw.FractionColumnWidth(0.08),
                6: pw.FractionColumnWidth(0.08),
                7: pw.FractionColumnWidth(0.10),
                8: pw.FractionColumnWidth(0.12),
                9: pw.FractionColumnWidth(0.12),
              },
            ),

            pw.SizedBox(height: 10),
          ]
        ],
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }


  Future<void> _pickEndDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
      context.read<ImeiSerialReportBloc>().add(
        ImeiSerialReportUpdateDates(startDate: _startDate, endDate: _endDate),
      );
    }
  }

  void _applyFilters() {
    context.read<ImeiSerialReportBloc>().add(
      ImeiSerialReportUpdateFilters(
        brandName: _brandCtrl.text.trim(),
        productName: _productCtrl.text.trim(),
        imei: _imeiCtrl.text.trim(),
        productCondition: _conditionCtrl.text.trim(),
        customerName: _customerCtrl.text.trim(),
        vendorName: _vendorCtrl.text.trim(),
        stockType: _stockType,
      ),
    );
    context.read<ImeiSerialReportBloc>().add(const ImeiSerialFetchRequested());
  }

  // UI Widgets
  Widget _inputField(
      String label,
      TextEditingController controller, {
        VoidCallback? onTap,
      }) {
    return TextField(
      controller: controller,
      readOnly: onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _filtersSection() {
    return BlocBuilder<ImeiSerialReportBloc, ImeiSerialReportState>(
      builder: (context, state) {
        List<String> customerOptions = [];
        List<String> vendorOptions = [];
        List<String> productOptions = [];
        List<String> brandOptions = [];
        List<String> conditionOptions =["Intact","Used","Damaged","Service","Client"];

        if (state is ImeiSerialLoadSuccess) {
          customerOptions = state.customerOptions;
          vendorOptions = state.vendorOptions;
          productOptions = state.productOptions;
          brandOptions = state.brandOptions;

        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _isDateSelected,
                  onChanged: (v) {
                    setState(() => _isDateSelected = v ?? false);
                    context.read<ImeiSerialReportBloc>().add(
                      ImeiSerialToggleDateSelection(_isDateSelected),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text('Select Date', style: TextStyle(fontSize: 16)),
                const Spacer(),
                CustomAnimatedButton(
                  label: "Report",
                  icon: Icons.analytics_outlined,
                  color: const Color(0xFF3240B6),
                  pressedColor: const Color(0xFF26338A),
                  fullWidth: false,
                  width: 150,
                  height: 50,
                  borderRadius: 24,
                  onPressed: _applyFilters,
                )

              ],
            ),
            const SizedBox(height: 12),
            if (_isDateSelected)
              Row(
                children: [
                  Expanded(
                    child: _inputField(
                      'Start Date',
                      TextEditingController(text: _formatDate(_startDate)),
                      onTap: () => _pickStartDate(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _inputField(
                      'End Date',
                      TextEditingController(text: _formatDate(_endDate)),
                      onTap: () => _pickEndDate(context),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),

            // ✅ Customer + Product Dropdown
            // ✅ Customer + Product + Vendor + Brand + Condition Dropdowns
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    label: 'Customer',
                    options: customerOptions,
                    selectedValue: _customerCtrl.text.isEmpty ? null : _customerCtrl.text,
                    onTap: () {
                      if (customerOptions.isEmpty) {
                        context.read<ImeiSerialReportBloc>().add(FetchAllDropdownOptions());
                      }
                    },
                    onChanged: (value) {
                      setState(() => _customerCtrl.text = value ?? "");
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown(
                    label: 'Product',
                    options: productOptions,
                    selectedValue: _productCtrl.text.isEmpty ? null : _productCtrl.text,
                    onTap: () {
                      if (productOptions.isEmpty) {
                        context.read<ImeiSerialReportBloc>().add(FetchAllDropdownOptions());
                      }
                    },
                    onChanged: (value) {
                      setState(() => _productCtrl.text = value ?? "");
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    label: 'Vendor',
                    options: vendorOptions,
                    selectedValue: _vendorCtrl.text.isEmpty ? null : _vendorCtrl.text,
                    onTap: () {
                      if (vendorOptions.isEmpty) {
                        context.read<ImeiSerialReportBloc>().add(FetchAllDropdownOptions());
                      }
                    },
                    onChanged: (value) {
                      setState(() => _vendorCtrl.text = value ?? "");
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown(
                    label: 'Product Condition',
                    options: conditionOptions,
                    selectedValue: _conditionCtrl.text.isEmpty ? null : _conditionCtrl.text,
                    onChanged: (value) {
                      setState(() => _conditionCtrl.text = value ?? "");
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hint: 'IMEI',
                    label: "IMEI Number",
                    obscureText: false,
                    onChanged: (value) {
                      setState(() => _imeiCtrl.text = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown(
                    label: 'Brand',
                    options: brandOptions,
                    selectedValue: _brandCtrl.text.isEmpty ? null : _brandCtrl.text,
                    onTap: () {
                      if (brandOptions.isEmpty) {
                        context.read<ImeiSerialReportBloc>().add(FetchAllDropdownOptions());
                      }
                    },
                    onChanged: (value) {
                      setState(() => _brandCtrl.text = value ?? "");
                    },
                  ),
                ),
              ],
            ),


            const Gap(8.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _stockTypeButton('Stock In'),
                const SizedBox(width: 12),
                _stockTypeButton('Stock Out'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _stockTypeButton(String type) {
    final isSelected = _stockType == type;
    return OutlinedButton(
      onPressed: () => setState(() => _stockType = type),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      ),
      child: Text(
        type,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildGroupedTable(Map<String, List<ImeiSerialRecord>> groups) {
    if (groups.isEmpty) {
      return const Center(child: Text('No records found'));
    }

    return Column(
      children: groups.entries.map((entry) {
        final productName = entry.key;
        final items = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Brand')),
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('IMEI/Serial')),
                  DataColumn(label: Text('Invoice No.')),
                  DataColumn(label: Text('Purchase Price')),
                  DataColumn(label: Text('Sale Price')),
                  DataColumn(label: Text('Product Condition')),
                  DataColumn(label: Text('Vendor Name')),
                  DataColumn(label: Text('Customer Name')),
                ],
                rows: items.map((r) {
                  return DataRow(
                    cells: [
                      DataCell(Text(r.date ?? '')),
                      DataCell(Text(r.brandName ?? '')),
                      DataCell(Text(r.productName)),
                      DataCell(Text(r.imei ?? '')),
                      DataCell(Text(r.purchaseInvoice ?? r.saleInvoice ?? '')),
                      DataCell(Text('${r.purchasePrice ?? 0}')),
                      DataCell(Text('${r.salePrice ?? 0}')),
                      DataCell(Text(r.productCondition ?? '')),
                      DataCell(Text(r.vendorName ?? '')),
                      DataCell(Text(r.customerName ?? '')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'IMEI/Serial Report',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.6,
      ),
      floatingActionButton: BlocBuilder<ImeiSerialReportBloc, ImeiSerialReportState>(
        builder: (context, state) {
          if (state is ImeiSerialLoadSuccess && state.groupedRecords.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 5),
              child: DownloadButton(
                onPressed: () => _generatePDF(state.groupedRecords),
                icon: Icons.file_download_rounded,
                backgroundColor: Colors.grey.shade800.withOpacity(0.85),
                iconColor: Colors.white,
                size: 60, // adjust size if needed
                iconSize: 26,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<ImeiSerialReportBloc, ImeiSerialReportState>(
            listener: (context, state) {
              if (state is ImeiSerialLoadFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              if (state is ImeiSerialLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ImeiSerialLoadSuccess) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _filtersSection(),
                      const Divider(height: 32),
                      const Text(
                        'IMEI/Serial History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildGroupedTable(state.groupedRecords),
                    ],
                  ),
                );
              } else if (state is ImeiSerialLoadFailure) {
                return Center(child: Text('Error: ${state.error}'));
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _filtersSection(),
                      const SizedBox(height: 18),
                      const Divider(),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text('Fill filters and press Report'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customerCtrl.dispose();
    _vendorCtrl.dispose();
    _productCtrl.dispose();
    _brandCtrl.dispose();
    _imeiCtrl.dispose();
    _conditionCtrl.dispose();
    super.dispose();
  }
}
