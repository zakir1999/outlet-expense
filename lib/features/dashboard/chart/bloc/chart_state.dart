part of 'chart_bloc.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final Map<String, dynamic> data;

  const ChartLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ChartError extends ChartState {
  final String message;

  const ChartError(this.message);

  @override
  List<Object> get props => [message];
}
