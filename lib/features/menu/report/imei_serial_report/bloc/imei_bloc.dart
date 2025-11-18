import 'package:flutter_bloc/flutter_bloc.dart';

import 'imei_event.dart';

import '../repository/imei_report_repository.dart';
import '../model/imei_model.dart';
import 'imei_state.dart';

class ImeiSerialReportBloc
    extends Bloc<ImeiSerialReportEvent, ImeiSerialReportState> {
  final ImeiSerialReportRepository repository;

  ImeiSerialReportBloc({required this.repository}) : super(ImeiSerialInitial()) {
    on<FetchAllDropdownOptions>(_onFetchAllDropdownOptions);
    on<FetchDropdownPage>(_onFetchDropdownPage);
    on<UpdateCustomerName>(_onUpdateCustomerName);
    on<UpdateVendorName>(_onUpdateVendorName);
    on<UpdateProductName>(_onUpdateProductName);
    on<UpdateBrandName>(_onUpdateBrandName);
    on<ImeiSerialReportUpdateFilters>(_onUpdateFilters);
    on<ImeiSerialReportUpdateDates>(_onUpdateDates);
    on<ImeiSerialToggleDateSelection>(_onToggleDateSelection);
    on<ImeiSerialFetchRequested>(_onFetchReport);
  }

  Future<void> _onFetchAllDropdownOptions(
      FetchAllDropdownOptions event, Emitter<ImeiSerialReportState> emit) async {
    emit(ImeiSerialLoading());
    try {
      final customers = await repository.fetchCustomers();
      final vendors = await repository.fetchVendors();
      final products = await repository.fetchProducts();
      final brands = await repository.fetchBrands();

      emit(ImeiSerialLoaded(
        groupedRecords: {},
        customerOptions: customers,
        vendorOptions: vendors,
        productOptions: products,
        brandOptions: brands,
      ));
    } catch (e) {
      emit(ImeiSerialLoadFailure(e.toString()));
    }
  }

  Future<void> _onFetchDropdownPage(
      FetchDropdownPage event, Emitter<ImeiSerialReportState> emit) async {
    if (state is! ImeiSerialLoaded) return;
    final s = state as ImeiSerialLoaded;
    if ((event.type == 'customer' && s.loadingCustomers) ||
        (event.type == 'vendor' && s.loadingVendors) ||
        (event.type == 'product' && s.loadingProducts) ||
        (event.type == 'brand' && s.loadingBrands)) {
      return;
    }

    try {

      switch (event.type) {
        case 'customer':
          emit(s.copyWith(loadingCustomers: true));
          break;
        case 'vendor':
          emit(s.copyWith(loadingVendors: true));
          break;
        case 'product':
          emit(s.copyWith(loadingProducts: true));
          break;
        case 'brand':
          emit(s.copyWith(loadingBrands: true));
          break;
      }
      List<String> newItems = [];
      switch (event.type) {
        case 'customer':
          newItems = await repository.fetchCustomers(page: event.page, limit: event.limit);
          emit(s.copyWith(
            customerOptions: event.append ? [...s.customerOptions, ...newItems] : newItems,
            customerPage: event.page,
            hasMoreCustomers: newItems.length == event.limit,
            loadingCustomers: false,
          ));
          break;

        case 'vendor':
          newItems = await repository.fetchVendors(page: event.page, limit: event.limit);
          emit(s.copyWith(
            vendorOptions: event.append ? [...s.vendorOptions, ...newItems] : newItems,
            vendorPage: event.page,
            hasMoreVendors: newItems.length == event.limit,
            loadingVendors: false,
          ));
          break;

        case 'product':
          newItems = await repository.fetchProducts(page: event.page, limit: event.limit);
          emit(s.copyWith(
            productOptions: event.append ? [...s.productOptions, ...newItems] : newItems,
            productPage: event.page,
            hasMoreProducts: newItems.length == event.limit,
            loadingProducts: false,
          ));
          break;

        case 'brand':
          newItems = await repository.fetchBrands(page: event.page, limit: event.limit);
          emit(s.copyWith(
            brandOptions: event.append ? [...s.brandOptions, ...newItems] : newItems,
            brandPage: event.page,
            hasMoreBrands: newItems.length == event.limit,
            loadingBrands: false,
          ));
          break;
      }
    } catch (e) {

      switch (event.type) {
        case 'customer':
          emit(s.copyWith(loadingCustomers: false));
          break;
        case 'vendor':
          emit(s.copyWith(loadingVendors: false));
          break;
        case 'product':
          emit(s.copyWith(loadingProducts: false));
          break;
        case 'brand':
          emit(s.copyWith(loadingBrands: false));
          break;
      }
    }
  }


  void _onUpdateCustomerName(UpdateCustomerName event, Emitter<ImeiSerialReportState> emit) {
    if (state is ImeiSerialLoaded) {
      final s = state as ImeiSerialLoaded;
      emit(s.copyWith(customerName: event.customerName));
    }
  }

  void _onUpdateVendorName(UpdateVendorName event, Emitter<ImeiSerialReportState> emit) {
    if (state is ImeiSerialLoaded) {
      final s = state as ImeiSerialLoaded;
      emit(s.copyWith(vendorName: event.vendorName));
    }
  }

  void _onUpdateProductName(UpdateProductName event, Emitter<ImeiSerialReportState> emit) {
    if (state is ImeiSerialLoaded) {
      final s = state as ImeiSerialLoaded;
      emit(s.copyWith(productName: event.productName));
    }
  }

  void _onUpdateBrandName(UpdateBrandName event, Emitter<ImeiSerialReportState> emit) {
    if (state is ImeiSerialLoaded) {
      final s = state as ImeiSerialLoaded;
      emit(s.copyWith(brandName: event.brandName));
    }
  }

  void _onUpdateFilters(ImeiSerialReportUpdateFilters event, Emitter<ImeiSerialReportState> emit) {
    if (state is ImeiSerialLoaded) {
      final s = state as ImeiSerialLoaded;
      emit(s.copyWith(
        brandName: event.brandName,
        productName: event.productName,
        imei: event.imei,
        productCondition: event.productCondition,
        customerName: event.customerName,
        vendorName: event.vendorName,
        stockType: event.stockType,
      ));
    }
  }

  void _onUpdateDates(ImeiSerialReportUpdateDates event, Emitter<ImeiSerialReportState> emit) {
    if (state is ImeiSerialLoaded) {
      final s = state as ImeiSerialLoaded;
      emit(s.copyWith(startDate: event.startDate, endDate: event.endDate));
    }
  }

  void _onToggleDateSelection(ImeiSerialToggleDateSelection event, Emitter<ImeiSerialReportState> emit) {
    if (state is ImeiSerialLoaded) {
      final s = state as ImeiSerialLoaded;
      emit(s.copyWith(dateSelectionEnabled: event.enabled));
    }
  }

  Future<void> _onFetchReport(ImeiSerialFetchRequested event, Emitter<ImeiSerialReportState> emit) async {
    if (state is! ImeiSerialLoaded) return;
    final s = state as ImeiSerialLoaded;
    emit(ImeiSerialLoading());
    try {
      final records = await repository.fetchReport(
        brandName: s.brandName,
        productName: s.productName,
        imei: s.imei,
        productCondition: s.productCondition,
        customerName: s.customerName,
        vendorName: s.vendorName,
        stockType: s.stockType,
        startDate: s.startDate,
        endDate: s.endDate,
      );

      final Map<String, List<ImeiSerialRecord>> grouped = {};

      for (var list in records.values) {
        for (var r in list) {
          final key = r.productName;
          grouped[key] = grouped[key] ?? [];
          grouped[key]!.add(r);
        }
      }




      emit(s.copyWith(groupedRecords: grouped));
    } catch (e) {
      emit(ImeiSerialLoadFailure(e.toString()));
    }
  }
}
