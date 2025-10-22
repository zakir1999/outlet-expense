import 'package:equatable/equatable.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();
  @override
  List<Object?> get props => [];
}

class FetchInvoices extends InvoiceEvent {}

class ChangeTypeFilter extends InvoiceEvent {
  final String type;
  const ChangeTypeFilter(this.type);
  @override
  List<Object?> get props => [type];
}

class SearchQueryChanged extends InvoiceEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}
