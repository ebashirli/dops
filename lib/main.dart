import 'dart:ui';
import 'package:dops/constants/constant.dart';
import 'package:dops/controllers/auth_controller.dart';
import 'package:dops/modules/drawing/drawing_repository.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import 'package:dops/modules/home/home_controller.dart';

import 'modules/activity/activity_repository.dart';
import 'modules/dropdown_source/dropdown_sources_repository.dart';
import 'modules/reference_document/reference_document_repository.dart';
import 'modules/staff/staff_repository.dart';
import 'modules/task/task_repository.dart';
import 'services/firebase_service/firebase_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

import 'routes/app_pages.dart';

Future<void> main() async {
  await initServices();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  setPathUrlStrategy();

  runApp(MyApp());
}

@override
Future<void> initServices() async {
  await Get.putAsync<StorageService>(() async => await FirebaseStorageService('activities'),
      tag: 'activities');

  await Get.putAsync<StorageService>(
      () async => await FirebaseStorageService('reference_documents'),
      tag: 'reference_documents');

  await Get.putAsync<StorageService>(() async => await FirebaseStorageService('staff'),
      tag: 'staff');

  await Get.putAsync<StorageService>(() async => await FirebaseStorageService('tasks'),
      tag: 'tasks');

  await Get.putAsync<StorageService>(() async => await FirebaseStorageService('drawings'),
      tag: 'drawings');

  await Get.putAsync<StorageService>(() async => await FirebaseStorageService('lists'),
      tag: 'lists');
  await Get.putAsync<ActivityRepository>(() async => await ActivityRepository());

  await Get.putAsync<ReferenceDocumentRepository>(() async => await ReferenceDocumentRepository());

  await Get.putAsync<StaffRepository>(() async => await StaffRepository());

  await Get.putAsync<TaskRepository>(() async => await TaskRepository());
  await Get.putAsync<DrawingRepository>(() async => await DrawingRepository());
  await Get.putAsync<DropwdownSourcesRepository>(() async => await DropwdownSourcesRepository());
  await Get.putAsync<HomeController>(() async => await HomeController());
  await Get.putAsync<DropdownSourcesController>(() async => await DropdownSourcesController());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: "DOPS",
      initialRoute: AppPages.LOGIN,
      getPages: AppPages.routes,
      unknownRoute: AppPages.routes[2],
      themeMode: ThemeMode.light,
      
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Color(0xff141A31),
        primaryColorDark: Color(0xff081029),
        scaffoldBackgroundColor: Color(0xff141A31),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.yellow),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
          ),
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
