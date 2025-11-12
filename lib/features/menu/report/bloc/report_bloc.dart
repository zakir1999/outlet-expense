
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
      case 'Sales Register Report':
        return '/sales-register-report';
      case 'Product Stock Report':
        return '/product-stock-report';
      case 'Monthly Sales Day Count Report':
        return '/monthly-sales-day-count-report';
      case 'Monthly Purchase Day Count Report':
        return '/monthly-purchase-day-count-report';
      case 'Category Stock Report':
        return '/category-stock-report';
      case 'Accounting History Report':
        return '/accounting-history-report';
      default:
        return null;
    }
  }
}
