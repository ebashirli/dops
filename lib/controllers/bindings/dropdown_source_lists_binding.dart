import 'package:dops/controllers/dropdown_source_lists_controller.dart';
import 'package:get/get.dart';

class DropdownSourceListsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DropdownSourceListsController>(
      () => DropdownSourceListsController(),
    );
  }
}
