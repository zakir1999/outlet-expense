part of 'chart_bloc.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class FetchChartData extends ChartEvent {
  final String interval;

  const FetchChartData(this.interval);

  @override
  List<Object> get props => [interval];
}
