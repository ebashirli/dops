import 'package:dops/controllers/activity_code_controller.dart';
import 'package:dops/controllers/staff_list_controller.dart';
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
    Get.lazyPut<ActivityCodeController>(
      () => ActivityCodeController(),
    );
    Get.lazyPut<ReferenceDocumentController>(
      () => ReferenceDocumentController(),
    );
    Get.lazyPut<StaffListController>(
      () => StaffListController(),
    );
  }
}

class ActivityCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityCodeController>(
      () => ActivityCodeController(),
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

class StaffListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffListController>(
      () => StaffListController(),
    );
  }
}
