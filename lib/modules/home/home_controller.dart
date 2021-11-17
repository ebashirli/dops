import '../../enum.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<HomeStates> _homeStates = HomeStates.ActivityState.obs;

  HomeStates get homeStates => _homeStates.value;
  set homeStates(HomeStates homeState) {
    _homeStates.value = homeState;
  }
}
