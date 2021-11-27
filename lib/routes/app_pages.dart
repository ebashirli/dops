import 'package:get/get.dart';
import '../bindings/bindings.dart';
import '../modules/home/home_view.dart';
import '../modules/stages/stages_view.dart';

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
      name: _Paths.STAGES,
      page: () => StagesView(),
      binding: StagesBinding(),
    ),
  ];
}
