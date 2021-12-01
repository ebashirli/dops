import 'package:dops/modules/drawing/drawing_controller.dart';
import 'package:dops/modules/login/login_controller.dart';

import '../modules/activity/activity_controller.dart';
import 'package:dops/modules/staff/staff_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:get/get.dart';

import '../../modules/dropdown_source/dropdown_sources_controller.dart';
import '../../modules/reference_document/reference_document_controller.dart';
import '../../modules/home/home_controller.dart';
import '../../modules/stages/stages_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ActivityController>(
      () => ActivityController(),
    );
    Get.lazyPut<ReferenceDocumentController>(
      () => ReferenceDocumentController(),
    );
    Get.lazyPut<StaffController>(
      () => StaffController(),
    );
    Get.lazyPut<TaskController>(
      () => TaskController(),
    );

    Get.lazyPut<DrawingController>(
      () => DrawingController(),
    );

    Get.lazyPut<DropdownSourcesController>(
      () => DropdownSourcesController(),
    );

    Get.lazyPut<StagesController>(
      () => StagesController(),
    );
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
