import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class BaseViewController<T> extends GetxService {
  @override
  void onInit() => super.onInit();
  bool get loading;
  List<Map<String, dynamic>?> get tableData;
  List<T> get documents;
  void buildUpdateForm({required String id});
  void buildAddForm({String? parentId});
  Widget getCellWidget(DataGridCell cell, String? id);
  Color? getRowColor(DataGridRow row);
}
