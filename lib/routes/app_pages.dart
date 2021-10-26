import 'package:dops/controllers/bindings/activity_code_binding.dart';
import 'package:dops/controllers/bindings/home_binding.dart';
import 'package:dops/controllers/bindings/reference_document_binding.dart';
import 'package:dops/views/activity_code_view.dart';
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
  ];
}
