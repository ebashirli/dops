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

  void onEditPressed({bool? newRev = false}) {
    if (dataGridController.value.selectedRow == null) {
      selectItemSnackbar();
    } else {
      String? id = dataGridController.value.selectedRow!.getCells()[0].value;

      taskController.buildAddEdit(id: id, newRev: true);
    }
  }
}
