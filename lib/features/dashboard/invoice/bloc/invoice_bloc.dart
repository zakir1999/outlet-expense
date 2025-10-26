import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/invoice_repository.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepository repository;

  InvoiceBloc({required this.repository}) : super(InvoiceInitial()) {
    on<FetchInvoices>(_onFetchInvoices);
    on<ChangeTypeFilter>(_onChangeTypeFilter);
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onFetchInvoices(
      FetchInvoices event,
      Emitter<InvoiceState> emit,
      ) async {
    emit(InvoiceLoading());
    try {
      final invoices = await repository.fetchInvoice(page: 1, limit: 10);
      emit(InvoiceLoaded(allInvoices: invoices));
    } catch (e) {
      emit(InvoiceError("Error fetching invoices: $e"));
    }
  }

  void _onChangeTypeFilter(
      ChangeTypeFilter event,
      Emitter<InvoiceState> emit,
      ) {
    if (state is InvoiceLoaded) {
      final current = state as InvoiceLoaded;
      emit(current.copyWith(activeType: event.type));
    }
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event,
      Emitter<InvoiceState> emit,
      ) {
    if (state is InvoiceLoaded) {
      final current = state as InvoiceLoaded;
      emit(current.copyWith(searchQuery: event.query));
    }
  }
}
