import 'package:dops/modules/drawing/drawing_controller.dart';
import 'package:dops/modules/issue/issue_controller.dart';
import 'package:dops/modules/list/lists_controller.dart';
import 'package:dops/modules/values/value_controller.dart';

import '../modules/activity/activity_controller.dart';
import 'package:dops/modules/staff/staff_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:get/get.dart';

import '../../modules/reference_document/reference_document_controller.dart';
import '../../modules/home/home_controller.dart';
import '../modules/stages/stage_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());

    Get.lazyPut<ActivityController>(() => ActivityController());

    Get.lazyPut<ReferenceDocumentController>(
        () => ReferenceDocumentController());

    Get.lazyPut<StaffController>(() => StaffController());

    Get.lazyPut<TaskController>(() => TaskController());

    Get.lazyPut<DrawingController>(() => DrawingController());

    Get.lazyPut<ListsController>(() => ListsController());

    Get.lazyPut<StageController>(() => StageController());

    Get.lazyPut<ValueController>(() => ValueController());

    Get.lazyPut<IssueController>(() => IssueController());
  }
}

// class LoginBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => AuthManager());
//   }
// }
