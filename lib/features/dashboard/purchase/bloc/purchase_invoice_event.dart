import 'package:equatable/equatable.dart';

abstract class PurchaseInvoiceEvent extends Equatable {
  const PurchaseInvoiceEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch purchase invoices from API
class FetchPurchaseInvoices extends PurchaseInvoiceEvent {}

/// Change active invoice type (e.g., "Inv", "Bill", etc.)
class ChangeTypeFilter extends PurchaseInvoiceEvent {
  final String type;
  const ChangeTypeFilter(this.type);

  @override
  List<Object?> get props => [type];
}

/// Change search query
class SearchQueryChanged extends PurchaseInvoiceEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}
