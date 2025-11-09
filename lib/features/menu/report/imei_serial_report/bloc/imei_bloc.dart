//
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
//
//   List<String> _customerOptions = [];
//   List<String> _vendorOptions = [];
//   List<String> _productOptions = [];
//   List<String> _brandOptions = [];
//
//   ImeiSerialReportBloc({required this.repository}) : super(ImeiSerialInitial()) {
//     on<ImeiSerialToggleDateSelection>(_onToggleDateSelection);
//     on<ImeiSerialReportUpdateFilters>(_onUpdateFilters);
//     on<ImeiSerialReportUpdateDates>(_onUpdateDates);
//     on<ImeiSerialFetchRequested>(_onFetchRequested);
//
//     on<FetchAllDropdownOptions>(_fetchAllDropdownOptions);
//
//   }
//
//   Future<void> _fetchAllDropdownOptions(
//       FetchAllDropdownOptions event,
//       Emitter<ImeiSerialReportState> emit,
//       ) async {
//     // Prevent re-fetching if all lists already loaded
//
//    final current=state as ImeiSerialLoadSuccess;
//    if(!current.hasMore)return;
//
//     if (_customerOptions.isNotEmpty &&
//         _vendorOptions.isNotEmpty &&
//         _productOptions.isNotEmpty &&
//         _brandOptions.isNotEmpty) {
//       return;
//     }
//
//     try {
//       final nextPage=current.page+1;
//       emit(ImeiSerialLoading());
//
//       final results = await Future.wait([
//         repository.fetchCustomerList(page:nextPage,limit:10),
//         repository.fetchVendorList(page:nextPage,limit:10),
//         repository.fetchProductList(page:nextPage,limit:10),
//         repository.fetchBrandList(page:nextPage,limit:10),
//       ]);
//
//       _customerOptions = results[0];
//       _vendorOptions = results[1];
//       _productOptions = results[2];
//       _brandOptions = results[3];
//
//       _emitCurrentState(emit);
//     } catch (e) {
//       emit(ImeiSerialLoadFailure('Failed to load dropdown options: $e'));
//     }
//   }
//
//
//   // ---------- Other Existing Handlers ----------
//   void _onToggleDateSelection(
//       ImeiSerialToggleDateSelection event, Emitter<ImeiSerialReportState> emit) {
//     _dateSelectionEnabled = event.enabled;
//     _emitCurrentState(emit);
//   }
//
//   void _onUpdateFilters(
//       ImeiSerialReportUpdateFilters event, Emitter<ImeiSerialReportState> emit) {
//     _brandName = event.brandName;
//     _productName = event.productName;
//     _imei = event.imei;
//     _productCondition = event.productCondition;
//     _customerName = event.customerName;
//     _vendorName = event.vendorName;
//     _stockType = event.stockType;
//     _emitCurrentState(emit);
//   }
//
//   void _onUpdateDates(
//       ImeiSerialReportUpdateDates event, Emitter<ImeiSerialReportState> emit) {
//     _startDate = event.startDate;
//     _endDate = event.endDate;
//     _emitCurrentState(emit);
//   }
//
//   Future<void> _onFetchRequested(
//       ImeiSerialFetchRequested event, Emitter<ImeiSerialReportState> emit) async {
//     emit(ImeiSerialLoading());
//     try {
//       final payload = {
//         'stock_type': _stockType,
//         'start_date': _startDate?.toUtc().toIso8601String() ?? '',
//         'end_date': _endDate?.toUtc().toIso8601String() ?? '',
//         'brand_name': _brandName,
//         'product_name': _productName,
//         'imei': _imei,
//         'product_condition': _productCondition,
//         'customer_name': _customerName,
//         'vendor_name': _vendorName,
//       };
//
//       final grouped = await repository.fetchImeiReport(payload);
//       emit(ImeiSerialLoadSuccess(
//         groupedRecords: grouped,
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
//         customerOptions: _customerOptions,
//         vendorOptions: _vendorOptions,
//         productOptions: _productOptions,
//         brandOptions: _brandOptions,
//       ));
//     } catch (e) {
//       emit(ImeiSerialLoadFailure(e.toString()));
//     }
//   }
//
//   // ---------- Helper ----------
//   void _emitCurrentState(Emitter<ImeiSerialReportState> emit) {
//     final currentState =
//     state is ImeiSerialLoadSuccess ? state as ImeiSerialLoadSuccess : null;
//
//     emit(ImeiSerialLoadSuccess(
//       groupedRecords: currentState?.groupedRecords ?? {},
//       dateSelectionEnabled: _dateSelectionEnabled,
//       startDate: _startDate,
//       endDate: _endDate,
//       brandName: _brandName,
//       productName: _productName,
//       imei: _imei,
//       productCondition: _productCondition,
//       customerName: _customerName,
//       vendorName: _vendorName,
//       stockType: _stockType,
//       customerOptions: _customerOptions,
//       vendorOptions: _vendorOptions,
//       productOptions: _productOptions,
//       brandOptions: _brandOptions,
//     ));
//   }
// }
//
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

  // local caches
  List<String> _customerOptions = [];
  List<String> _vendorOptions = [];
  List<String> _productOptions = [];
  List<String> _brandOptions = [];

  static const int _defaultLimit = 10;

  ImeiSerialReportBloc({required this.repository}) : super(ImeiSerialInitial()) {
    on<ImeiSerialToggleDateSelection>(_onToggleDateSelection);
    on<ImeiSerialReportUpdateFilters>(_onUpdateFilters);
    on<ImeiSerialReportUpdateDates>(_onUpdateDates);
    on<ImeiSerialFetchRequested>(_onFetchRequested);

    on<FetchAllDropdownOptions>(_onFetchAllDropdownOptions);
    on<FetchDropdownPage>(_onFetchDropdownPage);

  }

  // ---------- Fetch all first pages (initial load / refresh)
  Future<void> _onFetchAllDropdownOptions(
      FetchAllDropdownOptions event,
      Emitter<ImeiSerialReportState> emit,
      ) async {
    // Avoid duplicate fetch if already success and lists are present
    final current = state is ImeiSerialLoadSuccess ? state as ImeiSerialLoadSuccess : null;


    emit(ImeiSerialLoading());
    try {
      final page = event.page;
      final limit = event.limit;

      final results = await Future.wait([
        repository.fetchCustomerList(page: page, limit: limit),
        repository.fetchVendorList(page: page, limit: limit),
        repository.fetchProductList(page: page, limit: limit),
        repository.fetchBrandList(page: page, limit: limit),
      ]);

      _customerOptions = results[0];
      _vendorOptions = results[1];
      _productOptions = results[2];
      _brandOptions = results[3];

      // build state with pages and hasMore flags based on length < limit
      final hasMoreCustomers = _customerOptions.length >= limit;
      final hasMoreVendors = _vendorOptions.length >= limit;
      final hasMoreProducts = _productOptions.length >= limit;
      final hasMoreBrands = _brandOptions.length >= limit;

      emit(ImeiSerialLoadSuccess(
        groupedRecords: current?.groupedRecords ?? {},
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
        customerPage: page,
        hasMoreCustomers: hasMoreCustomers,
        loadingCustomers: false,
        vendorPage: page,
        hasMoreVendors: hasMoreVendors,
        loadingVendors: false,
        productPage: page,
        hasMoreProducts: hasMoreProducts,
        loadingProducts: false,
        brandPage: page,
        hasMoreBrands: hasMoreBrands,
        loadingBrands: false,
      ));
    } catch (e) {
      emit(ImeiSerialLoadFailure('Failed to load dropdown options: $e'));
    }
  }

  // ---------- Fetch one dropdown page (customer / vendor / product / brand)
  Future<void> _onFetchDropdownPage(
      FetchDropdownPage event,
      Emitter<ImeiSerialReportState> emit,
      ) async {
    final current = state is ImeiSerialLoadSuccess ? state as ImeiSerialLoadSuccess : null;
    // If no current success state, create an empty baseline
    final baselineGrouped = current?.groupedRecords ?? {};

    // decide which list
    final type = event.type.toLowerCase();
    final page = event.page;
    final limit = event.limit;

    // Set loading flag in state immediately
    if (current != null) {
      if (type == 'customer') {
        emit(current.copyWith(loadingCustomers: true));
      } else if (type == 'vendor') {
        emit(current.copyWith(loadingVendors: true));
      } else if (type == 'product') {
        emit(current.copyWith(loadingProducts: true));
      } else if (type == 'brand') {
        emit(current.copyWith(loadingBrands: true));
      }
    } else {
      emit(ImeiSerialLoading());
    }

    try {
      List<String> fetched = [];
      if (type == 'customer') {
        fetched = await repository.fetchCustomerList(page: page, limit: limit);
      } else if (type == 'vendor') {
        fetched = await repository.fetchVendorList(page: page, limit: limit);
      } else if (type == 'product') {
        fetched = await repository.fetchProductList(page: page, limit: limit);
      } else if (type == 'brand') {
        fetched = await repository.fetchBrandList(page: page, limit: limit);
      } else {
        fetched = [];
      }

      // if not append -> replace; if append -> append to existing
      List<String> newCustomer = current?.customerOptions ?? [];
      List<String> newVendor = current?.vendorOptions ?? [];
      List<String> newProduct = current?.productOptions ?? [];
      List<String> newBrand = current?.brandOptions ?? [];

      if (type == 'customer') {
        if (event.append) {
          // append unique items
          newCustomer = List.from(newCustomer)..addAll(fetched.where((x)=>!newCustomer.contains(x)));
        } else {
          newCustomer = fetched;
        }
      } else if (type == 'vendor') {
        if (event.append) {
          newVendor = List.from(newVendor)..addAll(fetched.where((x)=>!newVendor.contains(x)));
        } else {
          newVendor = fetched;
        }
      } else if (type == 'product') {
        if (event.append) {
          newProduct = List.from(newProduct)..addAll(fetched.where((x)=>!newProduct.contains(x)));
        } else {
          newProduct = fetched;
        }
      } else if (type == 'brand') {
        if (event.append) {
          newBrand = List.from(newBrand)..addAll(fetched.where((x)=>!newBrand.contains(x)));
        } else {
          newBrand = fetched;
        }
      }

      // decide hasMore depending on fetched length
      final bool more = fetched.length >= limit;

      // emit updated state with appropriate flags
      emit(ImeiSerialLoadSuccess(
        groupedRecords: baselineGrouped,
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
        customerOptions: newCustomer,
        vendorOptions: newVendor,
        productOptions: newProduct,
        brandOptions: newBrand,
        // pages and flags
        customerPage: type == 'customer' ? page : (current?.customerPage ?? 1),
        hasMoreCustomers: type == 'customer' ? more : (current?.hasMoreCustomers ?? true),
        loadingCustomers: type == 'customer' ? false : (current?.loadingCustomers ?? false),

        vendorPage: type == 'vendor' ? page : (current?.vendorPage ?? 1),
        hasMoreVendors: type == 'vendor' ? more : (current?.hasMoreVendors ?? true),
        loadingVendors: type == 'vendor' ? false : (current?.loadingVendors ?? false),

        productPage: type == 'product' ? page : (current?.productPage ?? 1),
        hasMoreProducts: type == 'product' ? more : (current?.hasMoreProducts ?? true),
        loadingProducts: type == 'product' ? false : (current?.loadingProducts ?? false),

        brandPage: type == 'brand' ? page : (current?.brandPage ?? 1),
        hasMoreBrands: type == 'brand' ? more : (current?.hasMoreBrands ?? true),
        loadingBrands: type == 'brand' ? false : (current?.loadingBrands ?? false),
      ));
    } catch (e) {
      // reset loading flags, keep current lists
      if (current != null) {
        emit(current.copyWith(
          loadingCustomers: false,
          loadingVendors: false,
          loadingProducts: false,
          loadingBrands: false,
        ));
      } else {
        emit(ImeiSerialLoadFailure('Failed to load list: $e'));
      }
    }
  }

  // ---------- Other Existing Handlers ----------
  void _onToggleDateSelection(
      ImeiSerialToggleDateSelection event, Emitter<ImeiSerialReportState> emit) {
    _dateSelectionEnabled = event.enabled;
    final current = state is ImeiSerialLoadSuccess ? state as ImeiSerialLoadSuccess : null;
    emit(current?.copyWith(dateSelectionEnabled: _dateSelectionEnabled) ??
        ImeiSerialLoadSuccess(groupedRecords: {}, dateSelectionEnabled: _dateSelectionEnabled));
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

    final current = state is ImeiSerialLoadSuccess ? state as ImeiSerialLoadSuccess : null;
    emit(current?.copyWith(
      brandName: _brandName,
      productName: _productName,
      imei: _imei,
      productCondition: _productCondition,
      customerName: _customerName,
      vendorName: _vendorName,
      stockType: _stockType,
    ) ?? ImeiSerialLoadSuccess(groupedRecords: {}, brandName: _brandName, productName: _productName));
  }

  void _onUpdateDates(
      ImeiSerialReportUpdateDates event, Emitter<ImeiSerialReportState> emit) {
    _startDate = event.startDate;
    _endDate = event.endDate;
    final current = state is ImeiSerialLoadSuccess ? state as ImeiSerialLoadSuccess : null;
    emit(current?.copyWith(startDate: _startDate, endDate: _endDate) ??
        ImeiSerialLoadSuccess(groupedRecords: {}, startDate: _startDate, endDate: _endDate));
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
      final current = state is ImeiSerialLoadSuccess ? state as ImeiSerialLoadSuccess : null;

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
        customerOptions: current?.customerOptions ?? _customerOptions,
        vendorOptions: current?.vendorOptions ?? _vendorOptions,
        productOptions: current?.productOptions ?? _productOptions,
        brandOptions: current?.brandOptions ?? _brandOptions,
        customerPage: current?.customerPage ?? 1,
        hasMoreCustomers: current?.hasMoreCustomers ?? true,
        vendorPage: current?.vendorPage ?? 1,
        hasMoreVendors: current?.hasMoreVendors ?? true,
        productPage: current?.productPage ?? 1,
        hasMoreProducts: current?.hasMoreProducts ?? true,
        brandPage: current?.brandPage ?? 1,
        hasMoreBrands: current?.hasMoreBrands ?? true,
      ));
    } catch (e) {
      emit(ImeiSerialLoadFailure(e.toString()));
    }
  }
}
