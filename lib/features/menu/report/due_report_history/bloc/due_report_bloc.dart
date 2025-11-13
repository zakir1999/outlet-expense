import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/due_report_model.dart';
import '../repository/due_report_repository.dart';
import 'due_report_event.dart';
import 'due_report_state.dart';



class DueReportBloc extends Bloc<DueReportEvent, DueReportState> {
  final DueReportRepository repository;

  DueReportBloc({required this.repository}) : super(DueReportInitial()) {
    on<FetchDueReportEvent>(_onFetchDueReport);
  }

  Future<void> _onFetchDueReport(
      FetchDueReportEvent event,
      Emitter<DueReportState> emit,
      ) async {
    emit(const DueReportLoading());
    try {
      final res = await repository.fetchDueReport(
        startDate: event.startDate,
        endDate: event.endDate,
        dueType: event.due,
      );

      // Clone the list to ensure a new reference
      final clonedData = List<DueReportData>.from(res.data);

      emit(DueReportLoaded(
        data: clonedData,
        totalDue: res.totalDue,
      ));
    } catch (e) {
      emit(DueReportError(e.toString()));
    }
  }

}
