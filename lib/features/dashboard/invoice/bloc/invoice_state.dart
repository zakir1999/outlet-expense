
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

  const InvoiceLoaded({
    required this.allInvoices,
    this.activeType = 'Inv',
    this.searchQuery = '',
  });

  /// Filter visible invoices based on type and search query
  List<Invoice> get visibleInvoices {
    var filtered = allInvoices.where((e) => e.type == activeType).toList();
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((e) =>
      e.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (e.customerName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
      ).toList();
    }
    return filtered;
  }

  InvoiceLoaded copyWith({
    List<Invoice>? allInvoices,
    String? activeType,
    String? searchQuery,
  }) {
    return InvoiceLoaded(
      allInvoices: allInvoices ?? this.allInvoices,
      activeType: activeType ?? this.activeType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allInvoices, activeType, searchQuery];
}

class InvoiceError extends InvoiceState {
  final String message;
  const InvoiceError(this.message);

  @override
  List<Object?> get props => [message];
}




