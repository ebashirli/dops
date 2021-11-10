import 'package:dops/enum.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<HomeStates> _homeStates = HomeStates.StaffListState.obs;
  HomeStates get homeStates => _homeStates.value;
  set homeStates(HomeStates homeState) {
    _homeStates.value = homeState;
  }
}
