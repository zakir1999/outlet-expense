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
  final List<Invoice> visibleInvoices;
  final String activeType;
  final String searchQuery;

  const InvoiceLoaded({
    required this.allInvoices,
    required this.visibleInvoices,
    required this.activeType,
    required this.searchQuery,
  });

  InvoiceLoaded copyWith({
    List<Invoice>? allInvoices,
    List<Invoice>? visibleInvoices,
    String? activeType,
    String? searchQuery,
  }) {
    return InvoiceLoaded(
      allInvoices: allInvoices ?? this.allInvoices,
      visibleInvoices: visibleInvoices ?? this.visibleInvoices,
      activeType: activeType ?? this.activeType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allInvoices, visibleInvoices, activeType, searchQuery];
}

class InvoiceError extends InvoiceState {
  final String message;
  const InvoiceError(this.message);
  @override
  List<Object?> get props => [message];
}
