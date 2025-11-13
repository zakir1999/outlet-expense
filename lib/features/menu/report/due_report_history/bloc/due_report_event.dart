import 'package:equatable/equatable.dart';

abstract class DueReportEvent extends Equatable {
  const DueReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchDueReportEvent extends DueReportEvent {
  final String startDate;
  final String endDate;
  final String due;

  const FetchDueReportEvent({
    required this.startDate,
    required this.endDate,
    required this.due,
  });

  @override
  List<Object?> get props => [startDate, endDate,due];
}
