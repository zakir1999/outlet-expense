import 'package:flutter/material.dart';

@immutable
abstract class ReportEvent {
  const ReportEvent();
}

// Event triggered when a user taps on any ReportCard.
class ReportCardTapped extends ReportEvent {
  final String title;

  const ReportCardTapped({required this.title});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReportCardTapped && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}
