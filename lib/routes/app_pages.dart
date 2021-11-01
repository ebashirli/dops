import 'package:dops/controllers/bindings/bindings.dart';
import 'package:dops/views/activity_code_view.dart';
import 'package:dops/views/dropdown_source_lists_view.dart';
import 'package:dops/views/home_view.dart';
import 'package:dops/views/reference_document_view.dart';
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
      name: _Paths.ACTIVITY_CODE,
      page: () => ActivityCodeView(),
      binding: ActivityCodeBinding(),
    ),
    GetPage(
      name: _Paths.DROPDOWN_SOURCE_LISTS,
      page: () => DropdownSourceListsView(),
      binding: DropdownSourceListsBinding(),
    ),
  ];
}
