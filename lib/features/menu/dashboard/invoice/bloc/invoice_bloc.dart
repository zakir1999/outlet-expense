import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/invoice_repository.dart';
import 'package:stream_transform/stream_transform.dart';

import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepository repository;

  InvoiceBloc({required this.repository}) : super(InvoiceInitial()) {
    on<FetchInvoices>(_onFetchInvoices);
    on<FetchMoreInvoices>(_onFetchMoreInvoices);
    on<ChangeTypeFilter>(_onChangeTypeFilter);

    // ✅ Debounced search input handler
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: (events, mapper) =>
          events.debounce(const Duration(milliseconds: 500)).switchMap(mapper),
    );
  }

  /// 🔹 Initial Fetch (page 1)
  Future<void> _onFetchInvoices(
      FetchInvoices event,
      Emitter<InvoiceState> emit,
      ) async {
    emit(InvoiceLoading());
    try {
      final invoices = await repository.fetchInvoice(page: 1, limit: 10,type: 'Inv');
      emit(InvoiceLoaded(
        allInvoices: invoices,
        page: 1,
        hasMore: invoices.length == 10,
      ));
    } catch (e) {
      emit(InvoiceError("Error fetching invoices: $e"));
    }
  }

  /// 🔹 Pagination (load next page)
  Future<void> _onFetchMoreInvoices(
      FetchMoreInvoices event,
      Emitter<InvoiceState> emit,
      ) async {
    if (state is InvoiceLoaded) {
      final current = state as InvoiceLoaded;
      if (!current.hasMore) return;

      try {
        final nextPage = current.page + 1;
        final newInvoices =
        await repository.fetchInvoice(page: nextPage, limit: 10,type: current.activeType);

        final allInvoices = [...current.allInvoices, ...newInvoices];
        final hasMore = newInvoices.length == 10;

        emit(current.copyWith(
          allInvoices: allInvoices,
          page: nextPage,
          hasMore: hasMore,
        ));
      } catch (e) {
        emit(InvoiceError("Error loading more invoices: $e"));
      }
    }
  }

  /// 🔹 Filter change resets pagination
  Future<void> _onChangeTypeFilter(
      ChangeTypeFilter event,
      Emitter<InvoiceState> emit,
      ) async {
    emit(InvoiceLoading());
    try {
      final invoices = await repository.fetchInvoice(page: 1, limit: 10,type: event.type);
      emit(InvoiceLoaded(
        allInvoices: invoices,
        activeType: event.type,
        page: 1,
        hasMore: invoices.length == 10,
      ));
    } catch (e) {
      emit(InvoiceError("Error filtering invoices: $e"));
    }
  }

  /// 🔹 Debounced Search (no flicker)
  Future<void> _onSearchQueryChanged(
      SearchQueryChanged event,
      Emitter<InvoiceState> emit,
      ) async {
    if (state is InvoiceLoaded) {
      final current = state as InvoiceLoaded;

      try {
        // 🧭 Reset to page 1 for a new search
        final invoices = await repository.fetchInvoice(page: 1, limit: 10,type:current.activeType);

        emit(current.copyWith(
          allInvoices: invoices,
          searchQuery: event.query,
          page: 1,
          hasMore: invoices.length == 10,
        ));
      } catch (e) {
        // Keep previous data visible even if API fails
        emit(current.copyWith(searchQuery: event.query));
      }
    } else {
      // If no previous data, do a normal loading fetch
      emit(InvoiceLoading());
      try {
        final invoices = await repository.fetchInvoice(page: 1, limit: 10,type: 'Inv');
        emit(InvoiceLoaded(
          allInvoices: invoices,
          searchQuery: event.query,
          page: 1,
          hasMore: invoices.length == 10,
        ));
      } catch (e) {
        emit(InvoiceError("Error searching invoices: $e"));
      }
    }
  }
}
