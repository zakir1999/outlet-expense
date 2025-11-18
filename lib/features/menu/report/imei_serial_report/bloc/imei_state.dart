
import 'package:flutter/foundation.dart';
import '../model/imei_model.dart';

@immutable
abstract class ImeiSerialReportState {
  const ImeiSerialReportState();
}

class ImeiSerialInitial extends ImeiSerialReportState {}
class ImeiSerialLoading extends ImeiSerialReportState {}

class ImeiSerialLoaded extends ImeiSerialReportState {

  final Map<String, List<ImeiSerialRecord>> groupedRecords;

  final int customerPage;
  final bool hasMoreCustomers;
  final bool loadingCustomers;
  final List<String> customerOptions;



  final List<String> vendorOptions;
  final int vendorPage;
  final bool hasMoreVendors;
  final bool loadingVendors;

  final List<String> productOptions;
  final int productPage;
  final bool hasMoreProducts;
  final bool loadingProducts;

  final List<String> brandOptions;
  final int brandPage;
  final bool hasMoreBrands;
  final bool loadingBrands;


  final bool dateSelectionEnabled;
  final DateTime? startDate;
  final DateTime? endDate;
  final String brandName;
  final String productName;
  final String imei;
  final String productCondition;
  final String customerName;
  final String vendorName;
  final String stockType;


  const ImeiSerialLoaded({

    required this.groupedRecords,
    this.dateSelectionEnabled = false,
    this.startDate,
    this.endDate,
    this.brandName = '',
    this.productName = '',
    this.imei = '',
    this.productCondition = '',
    this.customerName = '',
    this.vendorName = '',
    this.stockType = '',
    this.customerOptions = const [],
    this.vendorOptions = const [],
    this.productOptions = const [],
    this.brandOptions = const [],
    this.customerPage = 1,
    this.hasMoreCustomers = true,
    this.loadingCustomers = false,
    this.vendorPage = 1,
    this.hasMoreVendors = true,
    this.loadingVendors = false,
    this.productPage = 1,
    this.hasMoreProducts = true,
    this.loadingProducts = false,
    this.brandPage = 1,
    this.hasMoreBrands = true,
    this.loadingBrands = false,
  });

  ImeiSerialLoaded copyWith({
    Map<String, List<ImeiSerialRecord>>? groupedRecords,
    bool? dateSelectionEnabled,
    DateTime? startDate,
    DateTime? endDate,
    String? brandName,
    String? productName,
    String? imei,
    String? productCondition,
    String? customerName,
    String? vendorName,
    String? stockType,
    List<String>? customerOptions,
    List<String>? vendorOptions,
    List<String>? productOptions,
    List<String>? brandOptions,
    int? customerPage,
    bool? hasMoreCustomers,
    bool? loadingCustomers,
    int? vendorPage,
    bool? hasMoreVendors,
    bool? loadingVendors,
    int? productPage,
    bool? hasMoreProducts,
    bool? loadingProducts,
    int? brandPage,
    bool? hasMoreBrands,
    bool? loadingBrands,
  }) {
    return ImeiSerialLoaded(
      groupedRecords: groupedRecords ?? this.groupedRecords,
      dateSelectionEnabled: dateSelectionEnabled ?? this.dateSelectionEnabled,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      brandName: brandName ?? this.brandName,
      productName: productName ?? this.productName,
      imei: imei ?? this.imei,
      productCondition: productCondition ?? this.productCondition,
      customerName: customerName ?? this.customerName,
      vendorName: vendorName ?? this.vendorName,
      stockType: stockType ?? this.stockType,
      customerOptions: customerOptions ?? this.customerOptions,
      vendorOptions: vendorOptions ?? this.vendorOptions,
      productOptions: productOptions ?? this.productOptions,
      brandOptions: brandOptions ?? this.brandOptions,
      customerPage: customerPage ?? this.customerPage,
      hasMoreCustomers: hasMoreCustomers ?? this.hasMoreCustomers,
      loadingCustomers: loadingCustomers ?? this.loadingCustomers,
      vendorPage: vendorPage ?? this.vendorPage,
      hasMoreVendors: hasMoreVendors ?? this.hasMoreVendors,
      loadingVendors: loadingVendors ?? this.loadingVendors,
      productPage: productPage ?? this.productPage,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      loadingProducts: loadingProducts ?? this.loadingProducts,
      brandPage: brandPage ?? this.brandPage,
      hasMoreBrands: hasMoreBrands ?? this.hasMoreBrands,
      loadingBrands: loadingBrands ?? this.loadingBrands,
    );
  }
}

class ImeiSerialLoadFailure extends ImeiSerialReportState {
  final String error;
  const ImeiSerialLoadFailure(this.error);
}
