import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api/api_client.dart';
import 'sales_register_event.dart';
import 'sales_register_state.dart';
import '../repository/sales_register_details_repository.dart';

class SalesRegisterBloc extends Bloc<SalesRegisterEvent, SalesRegisterState> {
  final SalesRegisterRepository repository;
  String? _lastStartDate;
  String? _lastEndDate;

  SalesRegisterBloc({required GlobalKey<NavigatorState> navigatorKey})
      : repository = SalesRegisterRepository(
    apiClient: ApiClient(navigatorKey: navigatorKey),
  ),  super(SalesRegisterInitial()) {
    on<FetchSalesRegister>(_onFetchSalesRegister);
  }

  Future<void> _onFetchSalesRegister(
      FetchSalesRegister event,
      Emitter<SalesRegisterState> emit) async {

    final bool isSameRequest = event.startDate == _lastStartDate && event.endDate == _lastEndDate ;
    if(isSameRequest && !event.forceRefresh){
      final currentState=state;
      if(currentState is SalesRegisterLoaded)return;
    }
    emit(SalesRegisterLoading());
    try {
      final response = await repository.fetchSalesRegister(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      _lastStartDate=event.startDate;
      _lastEndDate=event.endDate;
      emit(SalesRegisterLoaded(response));
    } catch (e) {
      emit(SalesRegisterError(e.toString()));
    }
  }
}


