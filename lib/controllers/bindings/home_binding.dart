import 'package:get/get.dart';

import '../user_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(),
    );
  }
}
