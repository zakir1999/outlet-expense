import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

// Import the separated event and state files
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial()) {
    // Register the event handler
    on<ReportCardTapped>(_onReportCardTapped);
  }

  void _onReportCardTapped(
      ReportCardTapped event,
      Emitter<ReportState> emit,
      ) {
    // 1. Request navigation, carrying the report title.
    emit(ReportNavigationRequested(title: event.title));

    // 2. Immediately reset to the initial state to prepare for the next tap.
    emit(ReportInitial());
  }
}
