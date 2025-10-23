import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/chart_model.dart';
import '../repository/chart_repository.dart';


part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  ChartBloc({required this.chartRepository}) : super(ChartInitial()) {
    on<FetchChartData>(_onFetchChartData);
  }

  Future<void> _onFetchChartData(
      FetchChartData event,
      Emitter<ChartState> emit,
      ) async {
    emit(ChartLoading());
    try {
      final chartData = await chartRepository.fetchChartData(event.interval);
      emit(ChartLoaded(chartData: chartData));
    } catch (e) {
      emit(ChartError(e.toString()));
    }
  }
}
