import '../activity/activity_controller.dart';
import '../reference_document/reference_document_controller.dart';
import '../staff/staff_controller.dart';
import '../task/task_controller.dart';
import '../activity/activity_view.dart';
import '../reference_document/reference_document_view.dart';
import '../staff/staff_view.dart';
import '../task/task_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
import '../../enum.dart';
import '../dropdown_source/dropdown_sources_view.dart';

class HomeView extends GetView<HomeController> {
  final activityController = Get.find<ActivityController>();
  final referenceDocumentController = Get.find<ReferenceDocumentController>();
  final staffController = Get.find<StaffController>();
  final taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          drawer: _buildDrawer(),
          appBar: _buildAppBar(),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (controller.homeStates) {
      case HomeStates.ActivityState:
        return ActivityView();

      case HomeStates.ReferenceDocumentState:
        return ReferenceDocumentView();

      case HomeStates.DropdownSourceListState:
        return DropdownSourcesView();

      case HomeStates.StaffState:
        return StaffView();

      case HomeStates.TaskState:
        return TaskView();
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_buildTitleOfPage()),
      actions: [
        IconButton(
            onPressed: () {
              _buildAddDatabase();
            },
            icon: Icon(Icons.add))
      ],
    );
  }

  Container _buildDrawer() {
    return Container(
      width: 250,
      color: Colors.white,
      padding: EdgeInsets.only(top: 100, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.list_alt),
            label: const Text('Home'),
            onPressed: () {
              controller.homeStates = HomeStates.StaffState;
              Get.back();
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.golf_course),
            label: const Text('Reference Documents'),
            onPressed: () {
              controller.homeStates = HomeStates.ReferenceDocumentState;
              Get.back();
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.local_activity),
            label: const Text('Lists'),
            onPressed: () {
              controller.homeStates = HomeStates.DropdownSourceListState;
              Get.back();
            },
          ),
          SizedBox(height: 10),
          TextButton.icon(
            icon: Icon(Icons.add),
            label: const Text('Activities'),
            onPressed: () {
              controller.homeStates = HomeStates.ActivityState;
              Get.back();
            },
          ),
          SizedBox(height: 10),
          TextButton.icon(
            icon: Icon(Icons.people),
            label: const Text('Staff'),
            onPressed: () {
              controller.homeStates = HomeStates.StaffState;
              Get.back();
            },
          ),
          SizedBox(height: 10),
          TextButton.icon(
            icon: Icon(Icons.task),
            label: const Text('Tasks'),
            onPressed: () {
              controller.homeStates = HomeStates.TaskState;
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  String _buildTitleOfPage() {
    switch (controller.homeStates) {
      case HomeStates.ActivityState:
        return 'Activity Code';

      case HomeStates.ReferenceDocumentState:
        return 'Reference Documents';

      case HomeStates.DropdownSourceListState:
        return 'Lists';

      case HomeStates.StaffState:
        return 'Staff';
      case HomeStates.TaskState:
        return 'Tasks';
    }
  }

  _buildAddDatabase() {
    switch (controller.homeStates) {
      case HomeStates.ActivityState:
        return activityController.buildAddEdit();
      case HomeStates.ReferenceDocumentState:
        return referenceDocumentController.buildAddEdit();
      case HomeStates.StaffState:
        return staffController.buildAddEdit();
      case HomeStates.TaskState:
        return taskController.buildAddEdit();
      case HomeStates.DropdownSourceListState:
        return;
    }
  }
}