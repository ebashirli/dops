import 'dart:ui';
import 'package:dops/repositories/activity_repository.dart';
import 'package:dops/repositories/dropdown_sources_repository.dart';
import 'package:dops/repositories/reference_document_repository.dart';
import 'package:dops/repositories/staff_repository.dart';
import 'package:dops/repositories/task_repository.dart';
import 'package:dops/services/firebase_service/firebase_storage_service.dart';
import 'package:dops/services/firebase_service/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';

Future<void> main() async {
  await initServices();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

@override
Future<void> initServices() async {
  await Get.putAsync<StorageService>(
      () async => await FirebaseStorageService('activities'),
      tag: 'activities');

  await Get.putAsync<StorageService>(
      () async => await FirebaseStorageService('reference_documents'),
      tag: 'reference_documents');

  await Get.putAsync<StorageService>(
      () async => await FirebaseStorageService('staff'),
      tag: 'staff');

  await Get.putAsync<StorageService>(
      () async => await FirebaseStorageService('tasks'),
      tag: 'tasks');
  await Get.putAsync<StorageService>(
      () async => await FirebaseStorageService('lists'),
      tag: 'lists');
  await Get.putAsync<ActivityRepository>(
      () async => await ActivityRepository());

  await Get.putAsync<ReferenceDocumentRepository>(
      () async => await ReferenceDocumentRepository());

  await Get.putAsync<StaffRepository>(() async => await StaffRepository());

  await Get.putAsync<TaskRepository>(() async => await TaskRepository());
  await Get.putAsync<DropwdownSourcesRepository>(() async => await DropwdownSourcesRepository());
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
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
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
