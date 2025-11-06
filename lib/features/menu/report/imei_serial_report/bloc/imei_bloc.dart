// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'imei_event.dart';
// import 'imei_state.dart';
// import '../repository/imei_report_repository.dart';
//
// class ImeiSerialReportBloc extends Bloc<ImeiSerialReportEvent, ImeiSerialReportState> {
//   final ImeiSerialReportRepository repository;
//
//   bool _dateSelectionEnabled = false;
//   DateTime? _startDate;
//   DateTime? _endDate;
//   String _brandName = '';
//   String _productName = '';
//   String _imei = '';
//   String _productCondition = '';
//   String _customerName = '';
//   String _vendorName = '';
//   String _stockType = '';
//   List<String> _customerOptions = [];
//
//   ImeiSerialReportBloc({required this.repository})
//     : super(ImeiSerialInitial()) {
//     on<ImeiSerialToggleDateSelection>(_onToggleDateSelection);
//     on<ImeiSerialReportUpdateFilters>(_onUpdateFilters);
//     on<ImeiSerialReportUpdateDates>(_onUpdateDates);
//     on<ImeiSerialFetchRequested>(_onFetchRequested);
//     on<CustomerOption>(_fetchCustomerList);
//   }
//
//
//   Future<void> _fetchCustomerList(
//       CustomerOption event,
//       Emitter<ImeiSerialReportState> emit,
//       ) async {
//     emit(ImeiSerialLoading());
//     try {
//       final customerList = await repository.fetchCustomerList();
//       _customerOptions = customerList;
//
//       final currentState = state is ImeiSerialLoadSuccess
//           ? state as ImeiSerialLoadSuccess
//           : null;
//
//       emit(
//         ImeiSerialLoadSuccess(
//           groupedRecords: currentState?.groupedRecords ?? {},
//           dateSelectionEnabled: _dateSelectionEnabled,
//           startDate: _startDate,
//           endDate: _endDate,
//           brandName: _brandName,
//           productName: _productName,
//           imei: _imei,
//           productCondition: _productCondition,
//           customerName: _customerName,
//           vendorName: _vendorName,
//           stockType: _stockType,
//           customerOptions: _customerOptions,
//         ),
//       );
//     } catch (e) {
//       emit(ImeiSerialLoadFailure('Failed to fetch customer options: $e'));
//     }
//   }
//
//
//
//   void _onToggleDateSelection(
//     ImeiSerialToggleDateSelection event,
//     Emitter<ImeiSerialReportState> emit,
//   ) {
//     _dateSelectionEnabled = event.enabled;
//
//     final currentState = state is ImeiSerialLoadSuccess
//         ? state as ImeiSerialLoadSuccess
//         : null;
//     emit(
//       ImeiSerialLoadSuccess(
//         groupedRecords: currentState?.groupedRecords ?? {},
//         dateSelectionEnabled: _dateSelectionEnabled,
//         startDate: _startDate,
//         endDate: _endDate,
//         brandName: _brandName,
//         productName: _productName,
//         imei: _imei,
//         productCondition: _productCondition,
//         customerName: _customerName,
//         vendorName: _vendorName,
//         stockType: _stockType,
//       ),
//     );
//   }
//
//   /// Update filter parameters
//   void _onUpdateFilters(
//     ImeiSerialReportUpdateFilters event,
//     Emitter<ImeiSerialReportState> emit,
//   ) {
//     _brandName = event.brandName;
//     _productName = event.productName;
//     _imei = event.imei;
//     _productCondition = event.productCondition;
//     _customerName = event.customerName;
//     _vendorName = event.vendorName;
//     _stockType = event.stockType;
//
//     final currentState = state is ImeiSerialLoadSuccess
//         ? state as ImeiSerialLoadSuccess
//         : null;
//     emit(
//       ImeiSerialLoadSuccess(
//         groupedRecords: currentState?.groupedRecords ?? {},
//         dateSelectionEnabled: _dateSelectionEnabled,
//         startDate: _startDate,
//         endDate: _endDate,
//         brandName: _brandName,
//         productName: _productName,
//         imei: _imei,
//         productCondition: _productCondition,
//         customerName: _customerName,
//         vendorName: _vendorName,
//         stockType: _stockType,
//       ),
//     );
//   }
//
//   /// Update selected date range
//
//   void _onUpdateDates(
//     ImeiSerialReportUpdateDates event,
//     Emitter<ImeiSerialReportState> emit,
//   ) {
//     _startDate = event.startDate;
//     _endDate = event.endDate;
//
//     final currentState = state is ImeiSerialLoadSuccess
//         ? state as ImeiSerialLoadSuccess
//         : null;
//     emit(
//       ImeiSerialLoadSuccess(
//         groupedRecords: currentState?.groupedRecords ?? {},
//         dateSelectionEnabled: _dateSelectionEnabled,
//         startDate: _startDate,
//         endDate: _endDate,
//         brandName: _brandName,
//         productName: _productName,
//         imei: _imei,
//         productCondition: _productCondition,
//         customerName: _customerName,
//         vendorName: _vendorName,
//         stockType: _stockType,
//       ),
//     );
//   }
//
//   /// Fetch report data from repository
//   Future<void> _onFetchRequested(
//     ImeiSerialFetchRequested event,
//     Emitter<ImeiSerialReportState> emit,
//   ) async {
//     emit(ImeiSerialLoading());
//     try {
//       final payload = {
//         'stock_type': _stockType,
//         'start_date': _startDate != null
//             ? _startDate!.toUtc().toIso8601String()
//             : '',
//         'end_date': _endDate != null ? _endDate!.toUtc().toIso8601String() : '',
//         'brand_name': _brandName,
//         'product_name': _productName,
//         'imei': _imei,
//         'product_condition': _productCondition,
//         'customer_name': _customerName,
//         'vendor_name': _vendorName,
//       };
//
//       final grouped = await repository.fetchImeiReport(payload);
//
//       emit(
//         ImeiSerialLoadSuccess(
//           groupedRecords: grouped,
//           dateSelectionEnabled: _dateSelectionEnabled,
//           startDate: _startDate,
//           endDate: _endDate,
//           brandName: _brandName,
//           productName: _productName,
//           imei: _imei,
//           productCondition: _productCondition,
//           customerName: _customerName,
//           vendorName: _vendorName,
//           stockType: _stockType,
//         ),
//       );
//     } catch (e) {
//       emit(ImeiSerialLoadFailure(e.toString()));
//     }
//   }
// }


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

    // 🆕 Lazy dropdown handlers
    on<FetchCustomerOptions>(_fetchCustomerOptions);
    on<FetchVendorOptions>(_fetchVendorOptions);
    on<FetchProductOptions>(_fetchProductOptions);
    on<FetchBrandOptions>(_fetchBrandOptions);
  }

  // ---------- Lazy Dropdown Loaders ----------
  Future<void> _fetchCustomerOptions(
      FetchCustomerOptions event, Emitter<ImeiSerialReportState> emit) async {
    if (_customerOptions.isNotEmpty) return; // cache
    try {
      final customers = await repository.fetchCustomerList();
      _customerOptions = customers;
      _emitCurrentState(emit);
    } catch (e) {
      emit(ImeiSerialLoadFailure('Failed to load customers: $e'));
    }
  }

  Future<void> _fetchVendorOptions(
      FetchVendorOptions event, Emitter<ImeiSerialReportState> emit) async {
    if (_vendorOptions.isNotEmpty) return;
    try {
      final vendors = await repository.fetchVendorList();
      _vendorOptions = vendors;
      _emitCurrentState(emit);
    } catch (e) {
      emit(ImeiSerialLoadFailure('Failed to load vendors: $e'));
    }
  }

  Future<void> _fetchProductOptions(
      FetchProductOptions event, Emitter<ImeiSerialReportState> emit) async {
    if (_productOptions.isNotEmpty) return;
    try {
      final products = await repository.fetchProductList();
      _productOptions = products;
      _emitCurrentState(emit);
    } catch (e) {
      emit(ImeiSerialLoadFailure('Failed to load products: $e'));
    }
  }

  Future<void> _fetchBrandOptions(
      FetchBrandOptions event, Emitter<ImeiSerialReportState> emit) async {
    if (_brandOptions.isNotEmpty) return;
    try {
      final brands = await repository.fetchBrandList();
      _brandOptions = brands;
      _emitCurrentState(emit);
    } catch (e) {
      emit(ImeiSerialLoadFailure('Failed to load brands: $e'));
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

