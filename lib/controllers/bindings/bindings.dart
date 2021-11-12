import 'package:dops/controllers/activity_controller.dart';
import 'package:dops/controllers/staff_controller.dart';
import 'package:dops/controllers/task_controller.dart';
import 'package:get/get.dart';

import '../dropdown_source_lists_controller.dart';
import '../reference_document_controller.dart';
import '../home_controller.dart';

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
  }
}

class ActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityController>(
      () => ActivityController(),
    );
  }
}

class DropdownSourceListsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DropdownSourceListsController>(
      () => DropdownSourceListsController(),
    );
  }
}

class ReferenceDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferenceDocumentController>(
      () => ReferenceDocumentController(),
    );
  }
}

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffController>(
      () => StaffController(),
    );
  }
}

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(
      () => TaskController(),
    );
  }
}
