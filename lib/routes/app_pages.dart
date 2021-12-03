import 'dart:math';

import 'package:dops/constants/constant.dart';
import 'package:dops/modules/login/login_view.dart';
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

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      middlewares:[AuthMiddlware()],

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
      middlewares:[AuthMiddlware()],
      binding: StagesBinding(),
    ),
  ];
}
class AuthMiddlware extends GetMiddleware{  
   RouteSettings? redirect(String? route) => !authController.isLoggedIn.value ? RouteSettings(name:Routes.LOGIN) : null;
}