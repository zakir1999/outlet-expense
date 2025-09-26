import 'package:equatable/equatable.dart';

abstract class DynamicFieldsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddFieldEvent extends DynamicFieldsEvent {}

class RemoveFieldEvent extends DynamicFieldsEvent {
  final int index;

  RemoveFieldEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateFieldValueEvent extends DynamicFieldsEvent {
  final int index;
  final String value;

  UpdateFieldValueEvent(this.index, this.value);

  @override
  List<Object?> get props => [index, value];
}
