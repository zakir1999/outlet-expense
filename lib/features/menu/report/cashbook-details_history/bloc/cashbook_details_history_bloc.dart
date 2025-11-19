import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/cashbook_details_model.dart';
import '../repository/cashbook_repository.dart';
import 'cashbook_details_history_event.dart';
import 'cashbook_details_history_state.dart';


class CashbookDetailsBloc
    extends Bloc<CashbookDetailsEvent, CashbookDetailsState> {
  final CashbookDetailsRepository repository;

  CashbookDetailsBloc({required this.repository})
      : super(CashbookDetailsInitial()) {
    on<FetchPaymentTypeOptions>(_onFetchPaymentTypes);
    on<UpdatePaymentTypeSelection>(_onUpdatePaymentType);
    on<UpdateCashbookDateRange>(_onUpdateDates);
    on<UpdateOrderType>(_onUpdateOrderType);
    on<FetchCashbookDetailsReport>(_onFetchReport);
  }



  Future<void> _onFetchPaymentTypes(FetchPaymentTypeOptions event,
      Emitter<CashbookDetailsState> emit) async {
    emit(CashbookDetailsLoading());
    try {
      final types = await repository.fetchPaymentTypes();

      emit(CashbookDetailsLoaded(
        data: [],
        paymentTypes: types,
        paymentTypeName: null,
        paymentTypeId: null,
        startDate: null,
        endDate: null,
        orderType: "asc",
        totalAmount: 0,
        openingBalance: 0.0,
        currentTotalCredit: 0.0,
        currentTotalDebit: 0.0,
        closingBalance: 0.0,
      ));
    } catch (e) {
      emit(CashbookDetailsError(e.toString()));
    }
  }

  Future<void> _onFetchReport(FetchCashbookDetailsReport event,
      Emitter<CashbookDetailsState> emit) async {
    if (state is! CashbookDetailsLoaded) return;
    final s = state as CashbookDetailsLoaded;

    emit(CashbookDetailsLoading());
    try {
      final res = await repository.fetchCashbookDetailsReport(
        startDate: event.startDate,
        endDate: event.endDate,
        paymentTypeId: event.paymentTypeId,
        orderType: event.orderType,
      );

      emit(s.copyWith(
        data: res["data"] as List<TransactionItem>,
        openingBalance: res["opening_balance"] as double,
        currentTotalCredit: res["current_total_credit"] as double,
        currentTotalDebit: res["current_total_debit"] as double,
        closingBalance: res["closing_balance"] as double,
      ));
    } catch (e) {
      emit(CashbookDetailsError(e.toString()));
    }
  }



  void _onUpdatePaymentType(UpdatePaymentTypeSelection event,
      Emitter<CashbookDetailsState> emit) {
    if (state is CashbookDetailsLoaded) {
      final s = state as CashbookDetailsLoaded;
      emit(s.copyWith(
        paymentTypeId: event.id,
        paymentTypeName: event.name,
      ));
    }
  }

  void _onUpdateDates(UpdateCashbookDateRange event,
      Emitter<CashbookDetailsState> emit) {
    if (state is CashbookDetailsLoaded) {
      final s = state as CashbookDetailsLoaded;
      emit(s.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    }
  }

  void _onUpdateOrderType(UpdateOrderType event,
      Emitter<CashbookDetailsState> emit) {
    if (state is CashbookDetailsLoaded) {
      final s = state as CashbookDetailsLoaded;
      emit(s.copyWith(orderType: event.orderType));
    }
  }


}
