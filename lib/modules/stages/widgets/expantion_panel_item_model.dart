import 'package:flutter/material.dart';

class ExpantionPanelItemModel {
  ExpantionPanelItemModel({
    required this.expandedValue,
    required this.headerValue,
    required this.coordinatorForm,
    required this.workerForm,
    required this.valueTable,
    required this.index,
    this.isExpanded = false,
  });

  final String expandedValue;
  final String headerValue;
  final Widget coordinatorForm;
  final Widget workerForm;
  final Widget valueTable;
  bool isExpanded;
  int index;
}
