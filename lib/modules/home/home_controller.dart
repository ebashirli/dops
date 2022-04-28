import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../enum.dart';
import 'package:get/get.dart';

class HomeController extends GetxService {
  Rx<HomeStates> _homeStates = HomeStates.HomeState.obs;
  static HomeController instance = Get.find();

  HomeStates get homeStates => _homeStates.value;
  set homeStates(HomeStates homeState) {
    _homeStates.value = homeState;
  }

  final Rx<DataGridController> dataGridController = DataGridController().obs;

  String? getSelectedId() =>
      dataGridController.value.selectedRow!.getCells().first.value;
}
