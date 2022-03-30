import 'package:dops/core/auth_manager.dart';
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AuthManager authManager = AuthManager.instance;
HomeController homeController = HomeController.instance;
ReferenceDocumentController referenceDocumentController =
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

void filesDialog(List<String?> fileNames) {
  Get.defaultDialog(
    title: 'Files',
    content: Column(
      children: [
        ...fileNames
            .map<Widget>(
              (String? fileName) => TextButton(
                onPressed: () {},
                child: Text(fileName!),
              ),
            )
            .toList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: Text('Download All'),
            ),
          ],
        )
      ],
    ),
  );
}
