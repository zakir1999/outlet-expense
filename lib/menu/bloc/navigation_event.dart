
import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigateTo extends NavigationEvent {
  final int index;

  const NavigateTo(this.index);

  @override
  List<Object> get props => [index];
}
