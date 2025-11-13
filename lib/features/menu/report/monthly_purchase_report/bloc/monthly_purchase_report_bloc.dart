import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/monthly_purchase_report_model.dart';
import '../repository/monthly_purchase_repository.dart';
import 'monthly_purchase_report_event.dart';
import 'monthly_purchase_report_state.dart';


class MonthlyPurchaseReportBloc extends Bloc<MonthlyPurchaseEvent, MonthlyPurchaseState> {
  final MonthlyPurchaseRepository repository;

  MonthlyPurchaseReportBloc({required this.repository}) : super(MonthlyPurchaseInitial()) {
    on<FetchMonthlyPurchaseEvent>(_onFetchMonthlyPurchase);
  }

  Future<void> _onFetchMonthlyPurchase(
      FetchMonthlyPurchaseEvent event,
      Emitter<MonthlyPurchaseState> emit,
      ) async {
    emit(const MonthlyPurchaseLoading());
    try {
      final resp = await repository.fetchMonthlyPurchase(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      // Clone the list to ensure a new reference
      final clonedData = List<MonthlyPurchaseItem>.from(resp.data);

      emit(MonthlyPurchaseLoaded(
        data: clonedData,
        daysCount: resp.daysCount,
        grandTotal: resp.grandTotal,
      ));

    } catch (e) {
      emit(MonthlyPurchaseError(e.toString()));
    }
  }

}
