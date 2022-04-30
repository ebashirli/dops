// flutter run -d web-server --web-port 8080 --web-hostname 172.30.134.63

import 'package:dops/modules/login/auth_controller.dart';
import 'package:dops/core/cache_manager.dart';
import 'package:dops/modules/activity/activity_controller.dart';
import 'package:dops/modules/drawing/drawing_controller.dart';
import 'package:dops/modules/home/home_controller.dart';
import 'package:dops/modules/issue/issue_controller.dart';
import 'package:dops/modules/list/lists_controller.dart';
import 'package:dops/modules/reference_document/reference_document_controller.dart';
import 'package:dops/modules/staff/staff_controller.dart';
import 'package:dops/modules/stages/stage_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:dops/modules/values/value_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

AuthManager authManager = AuthManager.instance;
HomeController homeController = HomeController.instance;
ReferenceDocumentController refDocController =
    ReferenceDocumentController.instance;
ActivityController activityController = ActivityController.instance;
DrawingController drawingController = DrawingController.instance;
TaskController taskController = TaskController.instance;
IssueController issueController = IssueController.instance;
ListsController listsController = ListsController.instance;
StaffController staffController = StaffController.instance;
StageController stageController = StageController.instance;
ValueController valueController = ValueController.instance;
FirebaseAuth auth = FirebaseAuth.instance;
CacheManager cacheManager = CacheManager.instance;

const String baseUrl = 'http://172.30.134.63:5000/';
const String basePath = 'P:\\Ismayil Bashirli\\Elvin Bashirli\\DOPS';
