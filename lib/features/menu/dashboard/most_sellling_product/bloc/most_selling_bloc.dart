import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/most_selling_model.dart';
import '../repository/most_selling_repository.dart';
import 'most_selling_event.dart';
import 'most_selling_state.dart';

class MostSellingBloc extends Bloc<MostSellingEvent, MostSellingState> {
  final MostSellingRepository repository;
  List<MostSellingProduct> _allProducts = [];

  MostSellingBloc(this.repository) : super(MostSellingInitial()) {
    on<FetchMostSellingProducts>(_onFetch);
    on<RefreshMostSellingProducts>(_onRefresh);
    on<SearchMostSellingProducts>(_onSearch);
  }

  Future<void> _onFetch(
      FetchMostSellingProducts event, Emitter<MostSellingState> emit) async {
    emit(MostSellingLoading());
    try {
      final products = await repository.fetchMostSellingProducts();
      _allProducts = products;
      emit(MostSellingLoaded(products, products));
    } catch (e) {
      emit(MostSellingError(e.toString()));
    }
  }

  Future<void> _onRefresh(
      RefreshMostSellingProducts event, Emitter<MostSellingState> emit) async {
    try {
      final products = await repository.fetchMostSellingProducts();
      _allProducts = products;
      emit(MostSellingLoaded(products, products));
    } catch (e) {
      emit(MostSellingError('Failed to refresh: $e'));
    }
  }

  void _onSearch(
      SearchMostSellingProducts event, Emitter<MostSellingState> emit) {
    if (state is MostSellingLoaded) {
      final current = state as MostSellingLoaded;
      final filtered = _allProducts
          .where((p) =>
          p.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(MostSellingLoaded(current.allProducts, filtered));
    }
  }
}
