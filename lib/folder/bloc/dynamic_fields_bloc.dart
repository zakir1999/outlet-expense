import 'package:flutter_bloc/flutter_bloc.dart';
import 'dynamic_fields_event.dart';
import 'dynamic_fields_state.dart';

class DynamicFieldsBloc extends Bloc<DynamicFieldsEvent, DynamicFieldsState> {
  DynamicFieldsBloc() : super(const DynamicFieldsState()) {
    on<AddFieldEvent>((event, emit) {
      final updatedFields = List<String>.from(state.fields)..add("");
      emit(state.copyWith(fields: updatedFields));
    });

    on<RemoveFieldEvent>((event, emit) {
      final updatedFields = List<String>.from(state.fields)
        ..removeAt(event.index);
      emit(state.copyWith(fields: updatedFields));
    });

    on<UpdateFieldValueEvent>((event, emit) {
      final updatedFields = List<String>.from(state.fields);
      updatedFields[event.index] = event.value;
      emit(state.copyWith(fields: updatedFields));
    });
  }
}
