import 'package:equatable/equatable.dart';

import '../model/due_report_model.dart';

abstract class DueReportState extends Equatable {
  const DueReportState();

  @override
  List<Object?> get props => [];
}

class DueReportInitial extends DueReportState {
  const DueReportInitial();
}

class DueReportLoading extends DueReportState {
  const DueReportLoading();
}

class DueReportLoaded extends DueReportState {
  final List<DueReportData> data;
  final num totalDue;


  const DueReportLoaded({
    required this.data,
    required this.totalDue,
  });

  @override
  List<Object?> get props => [data, totalDue];
}

class DueReportError extends DueReportState {
  final String message;

  const DueReportError(this.message);

  @override
  List<Object?> get props => [message];
}
