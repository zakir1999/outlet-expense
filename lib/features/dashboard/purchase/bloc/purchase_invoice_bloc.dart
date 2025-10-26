import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/purchase_invoice_model.dart';
import 'purchase_invoice_event.dart';
import 'purchase_invoice_state.dart';
import '../repository/purchase_repository.dart';

class PurchaseInvoiceBloc extends Bloc<PurchaseInvoiceEvent, PurchaseInvoiceState> {
  final PurchaseInvoiceRepository repository;

  PurchaseInvoiceBloc({required this.repository})
      : super(PurchaseInvoiceInitial()) {
    on<FetchPurchaseInvoices>(_onFetchPurchaseInvoices);
    on<ChangeTypeFilter>(_onChangeTypeFilter);
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  /// Fetch data from API
  Future<void> _onFetchPurchaseInvoices(
      FetchPurchaseInvoices event,
      Emitter<PurchaseInvoiceState> emit,
      ) async {
    emit(PurchaseInvoiceLoading());
    try {
      final invoices = await repository.fetchPurchaseInvoice(page: 1, limit: 10);
      emit(PurchaseInvoiceLoaded(allInvoices:  invoices));
    } catch (e) {
      emit(PurchaseInvoiceError("Failed to fetch invoices: $e"));
    }
  }

  /// Change active type (e.g., Inv → Bill)
  void _onChangeTypeFilter(
      ChangeTypeFilter event,
      Emitter<PurchaseInvoiceState> emit,
      ) {
    final currentState = state;
    if (currentState is PurchaseInvoiceLoaded) {
      emit(currentState.copyWith(activeType: event.type));
    }
  }

  /// Change search query and update visible invoices
  void _onSearchQueryChanged(
      SearchQueryChanged event,
      Emitter<PurchaseInvoiceState> emit,
      ) {
    final currentState = state;
    if (currentState is PurchaseInvoiceLoaded) {
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }
}
