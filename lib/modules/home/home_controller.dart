import 'package:dops/constants/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

import '../../enum.dart';
import 'package:get/get.dart';

class HomeController extends GetxService {
  static HomeController instance = Get.find();
  final Rx<HomeStates?> _homeStates = HomeStates.MyTasksState.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    _homeStates.value = HomeStates.values.firstWhereOrNull(
            (e) => e.toString() == cacheManager.getHomeState()) ??
        HomeStates.MyTasksState;
  }

  HomeStates get homeState => _homeStates.value ?? HomeStates.MyTasksState;

  set homeState(HomeStates homeState) {
    _homeStates.value = homeState;
  }

  final Rx<DataGridController> dataGridController = DataGridController().obs;

  String? getSelectedId() =>
      dataGridController.value.selectedRow!.getCells().first.value;
}
