// lib/features/reports/sales_register/bloc/sales_register_details_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sales_register_details_event.dart';
import 'sales_register_details_state.dart';
import '../repository/sales_register_details_repository.dart';

class SalesRegisterBloc
    extends Bloc<SalesRegisterDetailsEvent, SalesRegisterDetailsState> {
  final SalesRegisterRepository repository;

  SalesRegisterBloc({required this.repository})
      : super(SalesRegisterInitial()) {
    on<FetchSalesRegisterDetails>(_onFetchSalesRegisterDetails);
  }

  Future<void> _onFetchSalesRegisterDetails(
      FetchSalesRegisterDetails event,
      Emitter<SalesRegisterDetailsState> emit) async {
    emit(SalesRegisterLoading());
    try {
      final response = await repository.fetchSalesRegister(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(SalesRegisterLoaded(response));
    } catch (e) {
      emit(SalesRegisterError(e.toString()));
    }
  }
}
