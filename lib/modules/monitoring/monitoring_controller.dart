import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/models/base_table_view_controller.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';

class MonitoringController extends BaseViewController {
  static MonitoringController instance = Get.find();

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  @override
  List<Map<String, dynamic>?> get tableData {
    return staffController.documents.map((staff) {
      Map<String, dynamic> map = {};
      homeController.currentViewModel.value.columns!.forEach((column) {
        map = {
          'id': staff.id!,
          'fullName': '${staff.name} ${staff.surname}',
          'initial': '${staff.initial}',
          'count': valueController.documents
              .where(
                  (e) => e?.employeeId == staff.id && e?.submitDateTime == null)
              .length,
        };
        final List<String> stageNames = stageDetailsList
            .map<String>((e) => ReCase(e['name'].toString()).camelCase)
            .toList();

        for (var i = 0; i < stageNames.length; i++) {
          map[stageNames[i]] = taskController
              .getTaskNamesByEmpoyeeIdAndIndex(employeeId: staff.id!, index: i)
              .join(', ');
        }
      });

      return homeController.getTableMap(map);
    }).toList();
  }

  @override
  List get documents {
    return staffController.documents;
  }

  @override
  bool get loading {
    return staffController.loading &&
        drawingController.loading &&
        taskController.loading &&
        stageController.loading &&
        valueController.loading;
  }

  @override
  void onInit() => super.onInit();
  @override
  buildAddForm({String? parentId}) {}
  @override
  buildUpdateForm({required String id}) {}
}
