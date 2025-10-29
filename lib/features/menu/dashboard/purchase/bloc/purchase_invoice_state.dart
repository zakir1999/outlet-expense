import 'package:equatable/equatable.dart';
import '../model/purchase_invoice_model.dart';

abstract class PurchaseInvoiceState extends Equatable {
  const PurchaseInvoiceState();

  @override
  List<Object?> get props => [];
}

/// Initial state — before anything loads
class PurchaseInvoiceInitial extends PurchaseInvoiceState {}

/// Loading state — API call in progress
class PurchaseInvoiceLoading extends PurchaseInvoiceState {}

/// Loaded state — data fetched and visible
class PurchaseInvoiceLoaded extends PurchaseInvoiceState {
  final List<PurchaseInvoice> allInvoices;
  final String activeType;
  final String searchQuery;
  final int page;
  final bool hasMore;

  const PurchaseInvoiceLoaded({
    required this.allInvoices,
    this.activeType = 'Pur',
    this.searchQuery = '',
    this.page = 1,
    this.hasMore = true,
  });

  /// Computed list based on active type & search query
  List<PurchaseInvoice> get visibleInvoices {
    var filtered = allInvoices;

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((e) =>
      e.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
          e.customerName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }


  PurchaseInvoiceLoaded copyWith({
    List<PurchaseInvoice>? allInvoices,
    String? activeType,
    String? searchQuery,
    int? page,
    bool? hasMore,
  }) {
    return PurchaseInvoiceLoaded(
      allInvoices: allInvoices ?? this.allInvoices,
      activeType: activeType ?? this.activeType,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [allInvoices, activeType, searchQuery,page, hasMore];
}

/// Error state — when API call fails
class PurchaseInvoiceError extends PurchaseInvoiceState {
  final String message;
  const PurchaseInvoiceError(this.message);

  @override
  List<Object?> get props => [message];
}
