import 'package:equatable/equatable.dart';
import '../model/invoice_model.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object?> get props => [];
}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final List<Invoice> allInvoices;
  final String activeType;
  final String searchQuery;

  /// ✅ Pagination fields
  final int page;
  final bool hasMore;

  const InvoiceLoaded({
    required this.allInvoices,
    this.activeType = 'Inv',
    this.searchQuery = '',
    this.page = 1,
    this.hasMore = true,
  });

  /// Filter visible invoices based on type and search query
  List<Invoice> get visibleInvoices {
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


  InvoiceLoaded copyWith({
    List<Invoice>? allInvoices,
    String? activeType,
    String? searchQuery,
    int? page,
    bool? hasMore,
  }) {
    return InvoiceLoaded(
      allInvoices: allInvoices ?? this.allInvoices,
      activeType: activeType ?? this.activeType,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props =>
      [allInvoices, activeType, searchQuery, page, hasMore];
}

class InvoiceError extends InvoiceState {
  final String message;
  const InvoiceError(this.message);

  @override
  List<Object?> get props => [message];
}
