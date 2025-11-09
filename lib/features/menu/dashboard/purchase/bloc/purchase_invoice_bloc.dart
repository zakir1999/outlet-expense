import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'purchase_invoice_event.dart';
import 'purchase_invoice_state.dart';
import '../repository/purchase_repository.dart';
import 'package:stream_transform/stream_transform.dart';

class PurchaseInvoiceBloc extends Bloc<PurchaseInvoiceEvent, PurchaseInvoiceState> {
  final PurchaseInvoiceRepository repository;
  int purchase_api_call=0;

  PurchaseInvoiceBloc({required this.repository})
      : super(PurchaseInvoiceInitial()) {
    on<FetchPurchaseInvoices>(_onFetchPurchaseInvoices);
    on<ChangeTypeFilter>(_onChangeTypeFilter);
    on<FetchMorePurchaseInvoices>(_onFetchMorePurchaseInvoices);

    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: (events, mapper) =>
          events.debounce(const Duration(milliseconds: 500)).switchMap(mapper),
    );
  }

  /// Fetch data from API
  Future<void> _onFetchPurchaseInvoices(
      FetchPurchaseInvoices event,
      Emitter<PurchaseInvoiceState> emit,
      ) async {
    emit(PurchaseInvoiceLoading());
    try {
      final invoices = await repository.fetchPurchaseInvoice(page: 1, limit: 10,type: 'Pur');
      emit(PurchaseInvoiceLoaded(allInvoices:  invoices));
    } catch (e) {
      emit(PurchaseInvoiceError("Failed to fetch invoices: $e"));
    }
  }


  /// 🔹 Pagination (load next page)
  Future<void> _onFetchMorePurchaseInvoices(
      FetchMorePurchaseInvoices event,
      Emitter<PurchaseInvoiceState> emit,
      ) async {
    if (state is PurchaseInvoiceLoaded) {
      final current = state as PurchaseInvoiceLoaded;
      if (!current.hasMore) return;

      try {
        final nextPage = current.page + 1;
        final newInvoices =
        await repository.fetchPurchaseInvoice(page: nextPage, limit: 10,type: current.activeType);
        purchase_api_call++;
        print("purchase api call ${purchase_api_call}");

        final allInvoices = [...current.allInvoices, ...newInvoices];
        final hasMore = newInvoices.length == 10;

        emit(current.copyWith(
          allInvoices: allInvoices,
          page: nextPage,
          hasMore: hasMore,
        ));
      } catch (e) {
        emit(PurchaseInvoiceError("Error loading more invoices: $e"));
      }
    }
  }

  /// 🔹 Filter change resets pagination
  Future<void> _onChangeTypeFilter(
      ChangeTypeFilter event,
      Emitter<PurchaseInvoiceState> emit,
      ) async {
    emit(PurchaseInvoiceLoading());
    try {
      final invoices = await repository.fetchPurchaseInvoice(page: 1, limit: 10,type:event.type);
      emit(PurchaseInvoiceLoaded(
        allInvoices: invoices,
        activeType: event.type,
        page: 1,
        hasMore: invoices.length == 10,
      ));
    } catch (e) {
      emit(PurchaseInvoiceError("Error filtering invoices: $e"));
    }
  }




/// 🔹 Debounced Search (no flicker)
Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<PurchaseInvoiceState> emit,
    ) async {
  if (state is PurchaseInvoiceLoaded) {
    final current = state as PurchaseInvoiceLoaded;

    try {
      // 🧭 Reset to page 1 for a new search
      final invoices = await repository.fetchPurchaseInvoice(page: 1, limit: 10,type: current.activeType);

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
    emit(PurchaseInvoiceLoading());
    try {
      final invoices = await repository.fetchPurchaseInvoice(page: 1, limit: 10,type: 'Pur');
      emit(PurchaseInvoiceLoaded(
        allInvoices: invoices,
        searchQuery: event.query,
        page: 1,
        hasMore: invoices.length == 10,
      ));
    } catch (e) {
      emit(PurchaseInvoiceError("Error searching invoices: $e"));
    }
  }
}
}