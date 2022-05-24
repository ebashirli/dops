// flutter run -d web-server --web-port 8080 --web-hostname 172.30.134.63
import 'package:dops/core/cache_manager.dart';
import 'package:dops/modules/controllers/controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';

AuthManager authManager = AuthManager.instance;
HomeController homeController = HomeController.instance;
ReferenceDocumentController refDocController =
    ReferenceDocumentController.instance;
ActivityController activityController = ActivityController.instance;
DrawingController drawingController = DrawingController.instance;
TaskController taskController = TaskController.instance;
ListsController listsController = ListsController.instance;
StaffController staffController = StaffController.instance;
StageController stageController = StageController.instance;
ValueController valueController = ValueController.instance;
MonitoringController monitoringController = MonitoringController.instance;
FirebaseAuth auth = FirebaseAuth.instance;
CacheManager cacheManager = CacheManager.instance;

const String baseUrl = 'http://172.30.134.63:5000/';
const String basePath = 'P:\\Ismayil Bashirli\\Elvin Bashirli\\DOPS';
