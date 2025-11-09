
import 'package:flutter_bloc/flutter_bloc.dart';
import 'imei_event.dart';
import 'imei_state.dart';
import '../repository/imei_report_repository.dart';

class ImeiSerialReportBloc extends Bloc<ImeiSerialReportEvent, ImeiSerialReportState> {
  final ImeiSerialReportRepository repository;

  bool _dateSelectionEnabled = false;
  DateTime? _startDate;
  DateTime? _endDate;
  String _brandName = '';
  String _productName = '';
  String _imei = '';
  String _productCondition = '';
  String _customerName = '';
  String _vendorName = '';
  String _stockType = '';

  List<String> _customerOptions = [];
  List<String> _vendorOptions = [];
  List<String> _productOptions = [];
  List<String> _brandOptions = [];

  ImeiSerialReportBloc({required this.repository}) : super(ImeiSerialInitial()) {
    on<ImeiSerialToggleDateSelection>(_onToggleDateSelection);
    on<ImeiSerialReportUpdateFilters>(_onUpdateFilters);
    on<ImeiSerialReportUpdateDates>(_onUpdateDates);
    on<ImeiSerialFetchRequested>(_onFetchRequested);

    on<FetchAllDropdownOptions>(_fetchAllDropdownOptions);

  }

  Future<void> _fetchAllDropdownOptions(
      FetchAllDropdownOptions event,
      Emitter<ImeiSerialReportState> emit,
      ) async {
    // Prevent re-fetching if all lists already loaded
    if (_customerOptions.isNotEmpty &&
        _vendorOptions.isNotEmpty &&
        _productOptions.isNotEmpty &&
        _brandOptions.isNotEmpty) {
      return;
    }

    try {
      emit(ImeiSerialLoading()); // optional: show loading state once

      final results = await Future.wait([
        repository.fetchCustomerList(),
        repository.fetchVendorList(),
        repository.fetchProductList(),
        repository.fetchBrandList(),
      ]);

      _customerOptions = results[0];
      _vendorOptions = results[1];
      _productOptions = results[2];
      _brandOptions = results[3];

      _emitCurrentState(emit);
    } catch (e) {
      emit(ImeiSerialLoadFailure('Failed to load dropdown options: $e'));
    }
  }


  // ---------- Other Existing Handlers ----------
  void _onToggleDateSelection(
      ImeiSerialToggleDateSelection event, Emitter<ImeiSerialReportState> emit) {
    _dateSelectionEnabled = event.enabled;
    _emitCurrentState(emit);
  }

  void _onUpdateFilters(
      ImeiSerialReportUpdateFilters event, Emitter<ImeiSerialReportState> emit) {
    _brandName = event.brandName;
    _productName = event.productName;
    _imei = event.imei;
    _productCondition = event.productCondition;
    _customerName = event.customerName;
    _vendorName = event.vendorName;
    _stockType = event.stockType;
    _emitCurrentState(emit);
  }

  void _onUpdateDates(
      ImeiSerialReportUpdateDates event, Emitter<ImeiSerialReportState> emit) {
    _startDate = event.startDate;
    _endDate = event.endDate;
    _emitCurrentState(emit);
  }

  Future<void> _onFetchRequested(
      ImeiSerialFetchRequested event, Emitter<ImeiSerialReportState> emit) async {
    emit(ImeiSerialLoading());
    try {
      final payload = {
        'stock_type': _stockType,
        'start_date': _startDate?.toUtc().toIso8601String() ?? '',
        'end_date': _endDate?.toUtc().toIso8601String() ?? '',
        'brand_name': _brandName,
        'product_name': _productName,
        'imei': _imei,
        'product_condition': _productCondition,
        'customer_name': _customerName,
        'vendor_name': _vendorName,
      };

      final grouped = await repository.fetchImeiReport(payload);
      emit(ImeiSerialLoadSuccess(
        groupedRecords: grouped,
        dateSelectionEnabled: _dateSelectionEnabled,
        startDate: _startDate,
        endDate: _endDate,
        brandName: _brandName,
        productName: _productName,
        imei: _imei,
        productCondition: _productCondition,
        customerName: _customerName,
        vendorName: _vendorName,
        stockType: _stockType,
        customerOptions: _customerOptions,
        vendorOptions: _vendorOptions,
        productOptions: _productOptions,
        brandOptions: _brandOptions,
      ));
    } catch (e) {
      emit(ImeiSerialLoadFailure(e.toString()));
    }
  }

  // ---------- Helper ----------
  void _emitCurrentState(Emitter<ImeiSerialReportState> emit) {
    final currentState =
    state is ImeiSerialLoadSuccess ? state as ImeiSerialLoadSuccess : null;

    emit(ImeiSerialLoadSuccess(
      groupedRecords: currentState?.groupedRecords ?? {},
      dateSelectionEnabled: _dateSelectionEnabled,
      startDate: _startDate,
      endDate: _endDate,
      brandName: _brandName,
      productName: _productName,
      imei: _imei,
      productCondition: _productCondition,
      customerName: _customerName,
      vendorName: _vendorName,
      stockType: _stockType,
      customerOptions: _customerOptions,
      vendorOptions: _vendorOptions,
      productOptions: _productOptions,
      brandOptions: _brandOptions,
    ));
  }
}

