import 'package:dops/controllers/auth_controller.dart';
import 'package:dops/modules/activity/activity_controller.dart';
import 'package:dops/modules/drawing/drawing_controller.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import 'package:dops/modules/reference_document/reference_document_controller.dart';
import 'package:dops/modules/staff/staff_controller.dart';
import 'package:dops/modules/stages/stages_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

AuthController authController = AuthController.instance;
ReferenceDocumentController referenceDocumentController =
    ReferenceDocumentController.instance;
ActivityController activityController = ActivityController.instance;
DrawingController drawingController = DrawingController.instance;
TaskController taskController = TaskController.instance;
DropdownSourcesController dropdownSourcesController =
    DropdownSourcesController.instance;
StaffController staffController = StaffController.instance;
StagesController stagesController = StagesController.instance;
FirebaseAuth auth = FirebaseAuth.instance;
