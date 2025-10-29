import 'package:flutter/material.dart';

@immutable
abstract class ReportState {
  const ReportState();
}

// The initial state, or when no action is currently pending.
class ReportInitial extends ReportState {}

// State emitted to tell the UI (BlocListener) to perform a navigation.
class ReportNavigationRequested extends ReportState {
  final String title;

  const ReportNavigationRequested({required this.title});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReportNavigationRequested && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}
