import 'package:dops/components/filter_columns_widget.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/modules/activity/widgets/activity_form_widget.dart';
import 'package:dops/modules/drawing/widgets/drawing_form_widget.dart';
import 'package:dops/modules/home/view_model.dart';
import 'package:dops/modules/list/widgets/lists_form_widget.dart';
import 'package:dops/modules/reference_document/widgets/ref_doc_add_update_form_widget.dart';
import 'package:dops/modules/staff/widgets/staff_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:quick_notify/quick_notify.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:get/get.dart';

class HomeController extends GetxService {
  static HomeController instance = Get.find();
  final RxInt selectedIndex = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    selectedIndex.value = cacheManager.getIndex ?? 0;
    columns.value = currentViewModel.value.columns!
        .sublist(currentViewModel.value.isDrawings ||
                currentViewModel.value.isMyTasks
            ? 2
            : 1)
        .map((e) => CheckBoxState(title: e!, value: true.obs))
        .toList();
    columnNames.value = currentViewModel.value.columns!;
  }

  ViewModel generateViewModel({int? index}) {
    var map = viewProperties[index ?? selectedIndex.value];
    return ViewModel(
      title: map['title'],
      itemName: map['itemName'],
      controller: map['controller'],
      columns: map['columns'],
      isTableView: map['isTableView'] ?? true,
    );
  }

  Rx<ViewModel> get currentViewModel => generateViewModel().obs;

  final Rx<CheckBoxState> allColumns =
      CheckBoxState(title: 'All columns', value: true.obs).obs;
  final RxList<CheckBoxState> columns =
      RxList<CheckBoxState>(<CheckBoxState>[]);

  final RxList<String?> columnNames = RxList([]);

  final Rx<DataGridController> dataGridController = DataGridController().obs;

  String? get selectedId =>
      dataGridController.value.selectedRow!.getCells().first.value;

  String? get drawingdId => currentViewModel.value.isDrawings
      ? dataGridController.value.selectedRow!.getCells()[1].value
      : null;

  List<Map<String, dynamic>> viewProperties = [
    {
      'title': 'My Tasks',
      'controller': taskController,
      'itemName': 'task',
      'columns': tableColNames['task'],
    },
    {
      'title': 'Drawings',
      'itemName': 'task',
      'controller': taskController,
      'formWidget': DrawingFormWidget,
      'columns': tableColNames['task'],
    },
    {
      'title': 'Activity Code',
      'itemName': 'activity',
      'controller': activityController,
      'formWidget': ActivityFormWidget,
      'columns': tableColNames['activity'],
    },
    {
      'title': 'Reference Documents',
      'itemName': 'reference document',
      'controller': refDocController,
      'formWidget': RefDocAddUpdateFormWidget,
      'columns': tableColNames['reference document'],
    },
    {
      'title': 'Monitoring',
      'itemName': 'monitoring',
      'controller': monitoringController,
      'formWidget': SizedBox(),
      'columns': [
        ...tableColNames['staff']!.sublist(0, 3),
        'Count',
        ...stageDetailsList.map<String>((e) => e['name']).toList(),
      ],
    },
    {
      'title': 'Staff',
      'itemName': 'staff',
      'controller': staffController,
      'formWidget': StaffFormWidget,
      'columns': tableColNames['staff'],
    },
    {
      'title': 'Lists',
      'itemName': 'list',
      'controller': listsController,
      'formWidget': ListsFormWidget,
      'isTableView': false,
    },
  ];

  List<String> get mapPropNames => currentViewModel.value.columns!
      .map((colName) => ReCase(colName!).camelCase)
      .toList();

  void getDialog({required String title, Widget? content}) {
    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: title,
      content: content,
    );
  }

  bool get isAddButtonVisibile =>
      staffController.isCoordinator && !currentViewModel.value.isMyTasks;

  bool get isAddTaskButtonVisibile =>
      staffController.isCoordinator && currentViewModel.value.isTaskView;

  void onDrawerMenuItemPressed(int index) {
    selectedIndex.value = index;
    if (index != 5) {
      columns.value = currentViewModel.value.columns!
          .map((e) => CheckBoxState(title: e!, value: true.obs))
          .toList();
      columnNames.value = currentViewModel.value.columns!;
    } else {
      columns.value = [];
      columnNames.value = [];
    }
    cacheManager.saveSelectedIndex(index);
    Get.back();
  }

  requestNotificationPermission() async {
    await QuickNotify.requestPermission();
  }

  Map<String, dynamic>? getTableMap(Map<String, dynamic> map) {
    Iterable<String?> camelCasedColumnNames =
        columnNames.map((e) => ReCase(e!).camelCase);
    map.keys.toSet().difference(camelCasedColumnNames.toSet()).forEach((e) {
      map.remove(e);
    });
    return map;
  }
}
