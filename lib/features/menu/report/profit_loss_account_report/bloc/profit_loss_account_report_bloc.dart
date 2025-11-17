
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../repository/profit_loss_account_report_repository.dart';
import 'profit_loss_account_report_event.dart';
import 'profit_loss_account_report_state.dart';


class ProfitLossReportBloc extends Bloc<ProfitLossReportEvent, ProfitLossReportState> {
  final GlobalKey<NavigatorState>? navigatorKey;
  final ProfitLossReportRepository repository;

  ProfitLossReportBloc({
    this.navigatorKey,
    ProfitLossReportRepository? repository,
  })  : repository = repository ??
      ProfitLossReportRepository(
        apiClient: ApiClient(navigatorKey: navigatorKey),
      ),
        super(ProfitLossReportInitial()) {
    on<FetchProfitLossReportEvent>(_onFetchReport);
  }

  Future<void> _onFetchReport(
      FetchProfitLossReportEvent event,
      Emitter<ProfitLossReportState> emit) async {
    emit(ProfitLossReportLoading());
    try {
      final reportData = await repository.fetchProfitLossReport(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(ProfitLossReportLoaded(report: reportData));
    } catch (e) {
      emit(ProfitLossReportError(e.toString()));
    }
  }
}