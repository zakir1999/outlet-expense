
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:outlet_expense/features/menu/report/sales_register_details_report/bloc/sales_register_details_event.dart';
import 'package:outlet_expense/features/menu/report/sales_register_details_report/bloc/sales_register_details_state.dart';
import '../../../../../core/api/api_client.dart';
import '../repository/sales_register_details_repository.dart';


class SalesRegisterDetailsBloc extends Bloc<SalesRegisterDetailsEvent, SalesRegisterDetailsState> {
  final GlobalKey<NavigatorState>? navigatorKey;
  final SalesRegisterDetailsRepository repository;

  SalesRegisterDetailsBloc({
    this.navigatorKey,
    SalesRegisterDetailsRepository? repository,
  })  : repository = repository ??
      SalesRegisterDetailsRepository(
        apiClient: ApiClient(navigatorKey: navigatorKey),
      ),
        super(SalesRegisterDetailsInitial()) {
    on<FetchSalesRegisterDetailsEvent>(_onFetchSalesDetails);
  }

  Future<void> _onFetchSalesDetails(
      FetchSalesRegisterDetailsEvent event,
      Emitter<SalesRegisterDetailsState> emit) async {
    emit(SalesRegisterDetailsLoading());
    try {
      final res = await repository.fetchSalesRegisterDetails(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(SalesRegisterDetailsLoaded(response: res));
    } catch (e) {
      emit(SalesRegisterDetailsError(e.toString()));
    }
  }
}