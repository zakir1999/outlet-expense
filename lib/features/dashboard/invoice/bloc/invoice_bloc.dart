import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/invoice_model.dart';
import '../repository/invoice_repository.dart';
import 'invoice_event.dart';

/// -------------------- States --------------------
abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final List<Invoice> invoices;
  final String activeType;
  final String searchQuery;

  InvoiceLoaded({
    required this.invoices,
    this.activeType = 'Inv',
    this.searchQuery = '',
  });

  /// Filtered list based on active type and search
  List<Invoice> get visibleInvoices {
    var filtered = invoices.where((e) => e.type == activeType).toList();
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((e) =>
      e.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (e.customerName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false))
          .toList();
    }
    return filtered;
  }

  InvoiceLoaded copyWith({
    List<Invoice>? invoices,
    String? activeType,
    String? searchQuery,
  }) {
    return InvoiceLoaded(
      invoices: invoices ?? this.invoices,
      activeType: activeType ?? this.activeType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class InvoiceError extends InvoiceState {
  final String message;
  InvoiceError(this.message);
}

/// -------------------- BLoC --------------------
class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepository repository;

  InvoiceBloc({required this.repository}) : super(InvoiceInitial()) {
    on<FetchInvoices>(_onFetchInvoices);
    on<ChangeTypeFilter>(_onChangeTypeFilter);
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onFetchInvoices(
      FetchInvoices event, Emitter<InvoiceState> emit) async {
    emit(InvoiceLoading());
    try {
      final invoices = await repository.fetchInvoice(page: 1,limit: 10);
      emit(InvoiceLoaded(invoices: invoices));
    } catch (e) {
      emit(InvoiceError("Error fetching invoices: $e"));
    }
  }

  void _onChangeTypeFilter(
      ChangeTypeFilter event, Emitter<InvoiceState> emit) {
    if (state is InvoiceLoaded) {
      final current = state as InvoiceLoaded;
      emit(current.copyWith(activeType: event.type));
    }
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<InvoiceState> emit) {
    if (state is InvoiceLoaded) {
      final current = state as InvoiceLoaded;
      emit(current.copyWith(searchQuery: event.query));
    }
  }
}
