import 'package:dops/controllers/activity_code_controller.dart';
import 'package:get/get.dart';

class ActivityCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityCodeController>(
      () => ActivityCodeController(),
    );
  }
}

