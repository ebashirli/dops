import 'dart:ui';
import 'package:dops/modules/login/auth_controller.dart';
import 'package:dops/core/cache_manager.dart';
import 'package:dops/modules/activity/activity_controller.dart';
import 'package:dops/modules/activity/activity_repository.dart';
import 'package:dops/modules/issue/issue_controller.dart';
import 'package:dops/modules/issue/issue_repository.dart';
import 'package:dops/modules/reference_document/reference_document_controller.dart';
import 'package:dops/modules/drawing/drawing_controller.dart';
import 'package:dops/modules/drawing/drawing_repository.dart';
import 'package:dops/modules/home/home_controller.dart';
import 'package:dops/modules/list/lists_controller.dart';
import 'package:dops/modules/list/lists_repository.dart';
import 'package:dops/modules/reference_document/reference_document_repository.dart';
import 'package:dops/modules/staff/staff_controller.dart';
import 'package:dops/modules/staff/staff_repository.dart';
import 'package:dops/modules/stages/stage_controller.dart';
import 'package:dops/modules/stages/stage_repository.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:dops/modules/task/task_repository.dart';
import 'package:dops/modules/values/value_controller.dart';
import 'package:dops/modules/values/values_repository.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:dops/services/firebase_service/firebase_storage_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  await initServices();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthManager());
  });
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: "DOPS",
      initialRoute: AppPages.SPLASH,
      getPages: AppPages.routes,
      unknownRoute: AppPages.routes[1],
      themeMode: ThemeMode.light,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

@override
Future<void> initServices() async {
  await GetStorage.init();

  await Get.putAsync<CacheManager>(() async => await CacheManager());

  await Get.putAsync<StorageService>(
    () async => await FirebaseStorageService('activities'),
    tag: 'activities',
  );

  await Get.putAsync<StorageService>(
    () async => await FirebaseStorageService('reference_documents'),
    tag: 'reference_documents',
  );

  await Get.putAsync<StorageService>(
    () async => await FirebaseStorageService('staff'),
    tag: 'staff',
  );

  await Get.putAsync<StorageService>(
    () async => await FirebaseStorageService('tasks'),
    tag: 'tasks',
  );

  await Get.putAsync<StorageService>(
    () async => await FirebaseStorageService('drawings'),
    tag: 'drawings',
  );

  await Get.putAsync<StorageService>(
    () async => await FirebaseStorageService('lists'),
    tag: 'lists',
  );

  await Get.putAsync<StorageService>(
    () async => await FirebaseStorageService('stages'),
    tag: 'stages',
  );

  await Get.putAsync<StorageService>(
    () async => await FirebaseStorageService('values'),
    tag: 'values',
  );

  await Get.putAsync<StorageService>(
    () async => await FirebaseStorageService('issue'),
    tag: 'issue',
  );

  // Get.putAsync repositories

  await Get.putAsync<ActivityRepository>(
      () async => await ActivityRepository());

  await Get.putAsync<ReferenceDocumentRepository>(
      () async => await ReferenceDocumentRepository());

  await Get.putAsync<StaffRepository>(() async => await StaffRepository());

  await Get.putAsync<TaskRepository>(() async => await TaskRepository());

  await Get.putAsync<StageRepository>(() async => await StageRepository());

  await Get.putAsync<DrawingRepository>(() async => await DrawingRepository());

  await Get.putAsync<ListsRepository>(() async => await ListsRepository());

  await Get.putAsync<ValueRepository>(() async => await ValueRepository());

  await Get.putAsync<IssueRepository>(() async => await IssueRepository());

  // Get.putAsync controllers

  await Get.putAsync<HomeController>(() async => await HomeController());

  await Get.putAsync<ListsController>(() async => await ListsController());

  await Get.putAsync<ActivityController>(
      () async => await ActivityController());

  await Get.putAsync<ReferenceDocumentController>(
      () async => await ReferenceDocumentController());

  await Get.putAsync<StaffController>(() async => await StaffController());

  await Get.putAsync<TaskController>(() async => await TaskController());

  await Get.putAsync<DrawingController>(() async => await DrawingController());

  await Get.putAsync<StageController>(() async => await StageController());

  await Get.putAsync<ValueController>(() async => await ValueController());

  await Get.putAsync<IssueController>(() async => await IssueController());
}


// darkTheme: ThemeData.dark().copyWith(
//         primaryColor: Color(0xff141A31),
//         primaryColorDark: Color(0xff081029),
//         scaffoldBackgroundColor: Color(0xff141A31),
//         textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.yellow),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ButtonStyle(
//             shape: MaterialStateProperty.all(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
//           ),
//         ),
//       ),
    