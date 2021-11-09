import 'dart:ui';

import 'package:dops/repositories/activity_code_repository.dart';
import 'package:dops/repositories/reference_document_repository.dart';
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
      () async => await FirebaseStorageService('activity_codes'),
      tag: 'activity_codes');

  await Get.putAsync<StorageService>(
      () async => await FirebaseStorageService('reference_documents'),
      tag: 'reference_documents');

  await Get.putAsync<ActivityCodeRepository>(
      () async => await ActivityCodeRepository());

  await Get.putAsync<ReferenceDocumentRepository>(
      () async => await ReferenceDocumentRepository());
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
