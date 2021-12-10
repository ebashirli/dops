import 'package:dops/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bindings/bindings.dart';
import '../modules/stages/stage_view.dart';
import '../unknown_route_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final UNKNOWN =
      GetPage(name: Routes.HOME, page: () => UnknownRoutePage());
  static const INITIAL = Routes.HOME;
  static const LOGIN = Routes.LOGIN;
  static const SPLASH = Routes.SPLASH;
  static final routes = [
    // GetPage(
    //   name: _Paths.HOME,
    //   page: () => HomeView(),
    //   middlewares: [AuthMiddlware()],
    //   binding: HomeBinding(),
    // ),
    // GetPage(
    //   name: _Paths.LOGIN,
    //   page: () => LoginView(),
    //   middlewares: [AuthMiddlware()],
    //   binding: LoginBinding(),
    // ),
    GetPage(
      name: _Paths.STAGES,
      page: () => StageView(),
      // middlewares: [AuthMiddlware()],
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
      // middlewares: [AuthMiddlware()],
      // binding: HomeBinding(),
    ),
  ];
}

class AuthMiddlware extends GetMiddleware {
  RouteSettings? redirect(String? route) => RouteSettings(name: Routes.SPLASH);
}
