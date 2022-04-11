import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../enum.dart';
import 'package:get/get.dart';

class HomeController extends GetxService {
  Rx<HomeStates> _homeStates = HomeStates.TaskState.obs;
  static HomeController instance = Get.find();

  HomeStates get homeStates => _homeStates.value;
  set homeStates(HomeStates homeState) {
    _homeStates.value = homeState;
  }

  final Rx<DataGridController> dataGridController = DataGridController().obs;

  void onEditPressed() {
    DataGridRow? selectedRow = dataGridController.value.selectedRow;
    if (selectedRow == null) {
      selectItemSnackbar();
    } else {
      String? id = selectedRow.getCells()[0].value;
      (id != null && !taskController.isTaskCompleted)
          ? selectItemSnackbar(
              title: 'Task completion',
              message: 'Current task has not been completed yet',
            )
          : taskController.buildAddForm(
              parentId: selectedRow.getCells()[1].value,
            );
    }
  }

  String? getSelectedId() =>
      dataGridController.value.selectedRow!.getCells().first.value;
}
