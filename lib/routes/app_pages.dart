import 'package:dops/controllers/bindings/bindings.dart';
import 'package:dops/views/activity_view.dart';
import 'package:dops/views/dropdown_sources_view.dart';
import 'package:dops/views/home_view.dart';
import 'package:dops/views/reference_document_view.dart';
import 'package:dops/views/staff_view.dart';
import 'package:dops/views/task_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REFERENCE_DOCUMENT,
      page: () => ReferenceDocumentView(),
      binding: ReferenceDocumentBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY,
      page: () => ActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.DROPDOWN_SOURCE_LISTS,
      page: () => DropdownSourcesView(),
      binding: DropdownSourceListsBinding(),
    ),
    GetPage(
      name: _Paths.STAFF,
      page: () => StaffView(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: _Paths.TASKS,
      page: () => TaskView(),
      binding: TaskBinding(),
    ),
  ];
}
