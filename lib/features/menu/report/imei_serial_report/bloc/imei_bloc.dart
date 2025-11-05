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

  ImeiSerialReportBloc({required this.repository})
    : super(ImeiSerialInitial()) {
    on<ImeiSerialToggleDateSelection>(_onToggleDateSelection);
    on<ImeiSerialReportUpdateFilters>(_onUpdateFilters);
    on<ImeiSerialReportUpdateDates>(_onUpdateDates);
    on<ImeiSerialFetchRequested>(_onFetchRequested);
    on<CustomerOption>(_fetchCustomerList);
  }


  Future<void> _fetchCustomerList(
      CustomerOption event,
      Emitter<ImeiSerialReportState> emit,
      ) async {
    emit(ImeiSerialLoading());
    try {
      final customerList = await repository.fetchCustomerList();
      _customerOptions = customerList;

      final currentState = state is ImeiSerialLoadSuccess
          ? state as ImeiSerialLoadSuccess
          : null;

      emit(
        ImeiSerialLoadSuccess(
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
        ),
      );
    } catch (e) {
      emit(ImeiSerialLoadFailure('Failed to fetch customer options: $e'));
    }
  }



  void _onToggleDateSelection(
    ImeiSerialToggleDateSelection event,
    Emitter<ImeiSerialReportState> emit,
  ) {
    _dateSelectionEnabled = event.enabled;

    final currentState = state is ImeiSerialLoadSuccess
        ? state as ImeiSerialLoadSuccess
        : null;
    emit(
      ImeiSerialLoadSuccess(
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
      ),
    );
  }

  /// Update filter parameters
  void _onUpdateFilters(
    ImeiSerialReportUpdateFilters event,
    Emitter<ImeiSerialReportState> emit,
  ) {
    _brandName = event.brandName;
    _productName = event.productName;
    _imei = event.imei;
    _productCondition = event.productCondition;
    _customerName = event.customerName;
    _vendorName = event.vendorName;
    _stockType = event.stockType;

    final currentState = state is ImeiSerialLoadSuccess
        ? state as ImeiSerialLoadSuccess
        : null;
    emit(
      ImeiSerialLoadSuccess(
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
      ),
    );
  }

  /// Update selected date range

  void _onUpdateDates(
    ImeiSerialReportUpdateDates event,
    Emitter<ImeiSerialReportState> emit,
  ) {
    _startDate = event.startDate;
    _endDate = event.endDate;

    final currentState = state is ImeiSerialLoadSuccess
        ? state as ImeiSerialLoadSuccess
        : null;
    emit(
      ImeiSerialLoadSuccess(
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
      ),
    );
  }

  /// Fetch report data from repository
  Future<void> _onFetchRequested(
    ImeiSerialFetchRequested event,
    Emitter<ImeiSerialReportState> emit,
  ) async {
    emit(ImeiSerialLoading());
    try {
      final payload = {
        'stock_type': _stockType,
        'start_date': _startDate != null
            ? _startDate!.toUtc().toIso8601String()
            : '',
        'end_date': _endDate != null ? _endDate!.toUtc().toIso8601String() : '',
        'brand_name': _brandName,
        'product_name': _productName,
        'imei': _imei,
        'product_condition': _productCondition,
        'customer_name': _customerName,
        'vendor_name': _vendorName,
      };

      final grouped = await repository.fetchImeiReport(payload);

      emit(
        ImeiSerialLoadSuccess(
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
        ),
      );
    } catch (e) {
      emit(ImeiSerialLoadFailure(e.toString()));
    }
  }
}
