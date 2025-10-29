import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/features/menu/report/sales_report/bloc/sales_report_event.dart';
import 'package:outlet_expense/features/menu/report/sales_report/bloc/sales_report_state.dart';
import '../sales_repository/sales_repository.dart';
import '../../../../../core/api/api_client.dart'; // adjust import path if needed

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  // ✅ Constructor now accepts navigatorKey
  ReportBloc({required GlobalKey<NavigatorState> navigatorKey})
      : repository = ReportRepository(
    apiClient: ApiClient(navigatorKey: navigatorKey),
  ),
        super(ReportInitial()) {
    on<FetchReportEvent>(_onFetchReport);
  }

  Future<void> _onFetchReport(
      FetchReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final reports = await repository.fetchReportData(
        startDate: event.startDate,
        endDate: event.endDate,
        filter: event.filter,
        brandId: event.brandId,
      );
      emit(ReportLoaded(reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}
