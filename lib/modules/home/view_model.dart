import 'package:dops/models/base_table_view_controller.dart';

class ViewModel {
  final String title;
  final String? itemName;
  final BaseViewController? controller;
  final bool isTableView;
  final List<String?>? columns;

  ViewModel({
    required this.title,
    this.itemName,
    this.controller,
    required this.isTableView,
    this.columns,
  });

  String get tableName => itemName!;
  bool get isTaskView => itemName == 'task' && title != 'My Tasks';
  bool get isMyTasks => title == 'My Tasks';
  bool get isDrawings => title == 'Drawings';
  bool get isMonitoring => title == 'Monitoring';
}
