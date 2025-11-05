// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
//
// // Import the separated event and state files
// import 'report_event.dart';
// import 'report_state.dart';
//
// class ReportBloc extends Bloc<ReportEvent, ReportState> {
//   ReportBloc() : super(ReportInitial()) {
//     // Register the event handler
//     on<ReportCardTapped>(_onReportCardTapped);
//   }
//
//   void _onReportCardTapped(
//       ReportCardTapped event,
//       Emitter<ReportState> emit,
//       ) {
//     // 1. Request navigation, carrying the report title.
//     emit(ReportNavigationRequested(title: event.title));
//
//     // 2. Immediately reset to the initial state to prepare for the next tap.
//     emit(ReportInitial());
//   }
// }


import 'package:bloc/bloc.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial()) {
    on<ReportCardTapped>(_onReportCardTapped);
  }

  void _onReportCardTapped(
      ReportCardTapped event,
      Emitter<ReportState> emit,
      ) {
    final route = _mapTitleToRoute(event.title);

    if (route != null) {
      emit(ReportNavigationRequested(routeName: route));
    }

    // Reset to initial after navigation
    emit(ReportInitial());
  }

  /// Maps report titles to specific routes.
  String? _mapTitleToRoute(String title) {
    switch (title) {
      case 'Category Sale Report':
        return '/category-sale-report';
      case 'IMEI/Serial Report':
        return '/imei-serial-report';
      case 'Product Sale Report':
        return '/product-sale-report';
      case 'Product Stock Report':
        return '/product-stock-report';
      case 'Balance History':
        return '/balance-history';
      case 'Category Stock Report':
        return '/category-stock-report';
      case 'Accounting History Report':
        return '/accounting-history-report';
      default:
        return null;
    }
  }
}
