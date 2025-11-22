
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../repository/profit_loss_account_report_repository.dart';
import 'profit_loss_account_report_event.dart';
import 'profit_loss_account_report_state.dart';


class ProfitLossReportBloc extends Bloc<ProfitLossReportEvent, ProfitLossReportState> {
  final ProfitLossReportRepository repository;

  String ? _lastStartDate;
  String ? _lastEndDate;

  ProfitLossReportBloc({
    required GlobalKey<NavigatorState>navigatorKey
  })  : repository =ProfitLossReportRepository(
        apiClient: ApiClient(navigatorKey: navigatorKey),
      ),
        super(ProfitLossReportInitial()) {
    on<FetchProfitLossReportEvent>(_onFetchProfitLoss);
  }

  Future<void> _onFetchProfitLoss(
      FetchProfitLossReportEvent event,
      Emitter<ProfitLossReportState> emit) async {


    final bool isSameRequest=event.startDate == _lastStartDate && event.endDate == _lastEndDate;

    if(isSameRequest && !event.forceRefresh){
      final currentSate=state;
      if(currentSate is ProfitLossReportLoaded)return;
    }
    emit(ProfitLossReportLoading());
    try {
      final reportData = await repository.fetchProfitLossReport(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      _lastEndDate=event.endDate;
      _lastStartDate=event.startDate;
      emit(ProfitLossReportLoaded(report: reportData));
    } catch (e) {
      emit(ProfitLossReportError(e.toString()));
    }
  }
}