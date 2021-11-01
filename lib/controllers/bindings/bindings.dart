import 'package:dops/controllers/activity_code_controller.dart';
import 'package:get/get.dart';

import '../dropdown_source_lists_controller.dart';
import '../reference_document_controller.dart';
import '../user_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(),
    );
    Get.lazyPut<ActivityCodeController>(
      () => ActivityCodeController(),
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
