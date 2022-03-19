import 'package:dops/core/auth_manager.dart';
import 'package:dops/core/cache_manager.dart';
import 'package:dops/modules/activity/activity_controller.dart';
import 'package:dops/modules/drawing/drawing_controller.dart';
import 'package:dops/modules/home/home_controller.dart';
import 'package:dops/modules/list/lists_controller.dart';
import 'package:dops/modules/reference_document/reference_document_controller.dart';
import 'package:dops/modules/staff/staff_controller.dart';
import 'package:dops/modules/stages/stage_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:dops/modules/values/value_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

AuthManager authManager = AuthManager.instance;
HomeController homeController = HomeController.instance;
ReferenceDocumentController referenceDocumentController =
    ReferenceDocumentController.instance;
ActivityController activityController = ActivityController.instance;
DrawingController drawingController = DrawingController.instance;
TaskController taskController = TaskController.instance;
ListsController listsController = ListsController.instance;
StaffController staffController = StaffController.instance;
StageController stageController = StageController.instance;
ValueController valueController = ValueController.instance;
FirebaseAuth auth = FirebaseAuth.instance;
CacheManager cacheManager = CacheManager.instance;
