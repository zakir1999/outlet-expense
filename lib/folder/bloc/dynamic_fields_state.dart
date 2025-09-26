import 'package:equatable/equatable.dart';

class DynamicFieldsState extends Equatable {
  final List<String> fields;

  const DynamicFieldsState({this.fields = const [""]});

  DynamicFieldsState copyWith({List<String>? fields}) {
    return DynamicFieldsState(fields: fields ?? this.fields);
  }

  @override
  List<Object?> get props => [fields];
}
