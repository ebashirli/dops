import 'dart:ui';
import 'package:dops/core/cache_manager.dart';
import 'package:dops/modules/controllers/controllers.dart';
import 'package:dops/modules/repositories/activity_repository.dart';
import 'package:dops/modules/repositories/drawing_repository.dart';
import 'package:dops/modules/repositories/lists_repository.dart';
import 'package:dops/modules/repositories/ref_doc_repository.dart';
import 'package:dops/modules/repositories/staff_repository.dart';
import 'package:dops/modules/repositories/stage_repository.dart';
import 'package:dops/modules/repositories/task_repository.dart';
import 'package:dops/modules/repositories/value_repository.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:dops/services/firebase_service/firebase-database-service.dart';

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

  // Get.putAsync controllers

  await Get.putAsync<ActivityController>(
      () async => await ActivityController());

  await Get.putAsync<ListsController>(() async => await ListsController());

  await Get.putAsync<ReferenceDocumentController>(
      () async => await ReferenceDocumentController());

  await Get.putAsync<StaffController>(() async => await StaffController());

  await Get.putAsync<TaskController>(() async => await TaskController());

  await Get.putAsync<DrawingController>(() async => await DrawingController());

  await Get.putAsync<StageController>(() async => await StageController());

  await Get.putAsync<ValueController>(() async => await ValueController());

  await Get.putAsync<MonitoringController>(
      () async => await MonitoringController());

  await Get.putAsync<HomeController>(() async => await HomeController());
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
    