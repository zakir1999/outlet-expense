import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/features/menu/report/category_sales_report/bloc/category_sale_report_event.dart';
import 'package:outlet_expense/features/menu/report/category_sales_report/bloc/category_sale_report_state.dart';
import '../repository/category_sale_repository.dart';
import '../../../../../core/api/api_client.dart';

class CategoryReportBloc extends Bloc<CategorySaleReportEvent, CategorySaleReportState> {
  final CategorySaleRepository repository;

  String? _lastStartDate;
  String? _lastEndDate;
  String? _lastFilter;
  String? _lastBrand;

  CategoryReportBloc({required GlobalKey<NavigatorState> navigatorKey})
      : repository = CategorySaleRepository(
    apiClient: ApiClient(navigatorKey: navigatorKey),
  ),
        super(CategorySaleInitial()) {
    on<FetchCategorySaleEvent>(_onCategorySaleReport);
  }

  Future<void> _onCategorySaleReport(
      FetchCategorySaleEvent event, Emitter<CategorySaleReportState> emit) async {
     final bool isSameRequest = event.startDate == _lastStartDate && event.endDate == _lastEndDate && event.filter == _lastFilter && event.brandId == _lastBrand;
    if(isSameRequest && !event.forceRefresh){
      final currentState=state;
      if(currentState is CategorySaleLoaded)return;
    }
    emit(CategorySaleLoading());
    try {
      final reportResponse = await repository.fetchCategorySaleResponse(
        startDate: event.startDate,
        endDate: event.endDate,
        filter: event.filter,
        brandId: event.brandId,
      );


      _lastBrand=event.brandId;
      _lastFilter=event.filter;
      _lastEndDate=event.endDate;
      _lastStartDate=event.startDate;
      emit(CategorySaleLoaded(reportResponse));
    } catch (e) {
      emit(CategorySaleError(e.toString()));
    }
  }
}
