import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../repository/production_stock_repository.dart';
import 'production_stock_event.dart';
import 'production_stock_state.dart';

class ProductionStockBloc extends Bloc<ProductionStockEvent, ProductionStockState> {
  final GlobalKey<NavigatorState>? navigatorKey;
  final ProductionStockRepository repository;

  ProductionStockBloc({
    this.navigatorKey,
    ProductionStockRepository? repository,
  })  : repository = repository ??
      ProductionStockRepository(
        apiClient: ApiClient(navigatorKey: navigatorKey),
      ),
        super(ProductionStockInitial()) {
    on<FetchProductionStockEvent>(_onFetch);
  }

  Future<void> _onFetch(
      FetchProductionStockEvent event,
      Emitter<ProductionStockState> emit,
      ) async {
    emit(ProductionStockLoading());
    try {
      final res = await repository.fetchProductionStock(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(ProductionStockLoaded(response: res));
    } catch (e) {
      emit(ProductionStockError(e.toString()));
    }
  }
}
