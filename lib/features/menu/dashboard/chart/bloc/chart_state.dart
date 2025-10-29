part of 'chart_bloc.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final ChartData chartData;

  const ChartLoaded({required this.chartData});

  @override
  List<Object> get props => [chartData];
}

class ChartError extends ChartState {
  final String message;

  const ChartError(this.message);

  @override
  List<Object> get props => [message];
}
