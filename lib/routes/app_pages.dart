import 'dart:async';

import 'package:dops/constants/constant.dart';
import 'package:dops/modules/login/login_view.dart';
import 'package:dops/modules/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bindings/bindings.dart';
import '../modules/home/home_view.dart';
import '../modules/stages/stages_view.dart';
import '../unknown_route_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final UNKNOWN = GetPage(name: Routes.HOME, page: () => UnknownRoutePage());
  static const INITIAL = Routes.HOME;
  static const LOGIN = Routes.LOGIN;
  static const SPLASH = Routes.SPLASH;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      // middlewares: [AuthMiddlware()],
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.STAGES,
      page: () => StagesView(),
      // middlewares: [AuthMiddlware()],
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
      middlewares: [AuthMiddlware()],
      // binding: HomeBinding(),
    ),
  ];
}

class AuthMiddlware extends GetMiddleware {
  RouteSettings? redirect(String? route) {
    Timer(Duration(seconds: 2), () {
       authController.isLoggedIn.value ? RouteSettings(name: Routes.HOME) : RouteSettings(name: Routes.LOGIN);
    });
    
  }
}
