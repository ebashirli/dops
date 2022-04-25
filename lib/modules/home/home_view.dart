import 'package:dops/components/table_view_widget.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/list/lists_view.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'home_controller.dart';
import '../../enum.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  late GetxService _controller;
  late String tableName;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        drawer: _buildDrawer(),
        appBar: _buildAppBar(),
        body: _buildBody(),
      );
    });
  }

  Widget _buildBody() {
    switch (controller.homeStates) {
      case HomeStates.ActivityState:
        _controller = activityController;
        tableName = 'activity';
        break;

      case HomeStates.ReferenceDocumentState:
        _controller = refDocController;
        tableName = 'reference document';
        break;

      case HomeStates.ListState:
        return ListsView();

      case HomeStates.StaffState:
        _controller = staffController;
        tableName = 'staff';
        break;

      case HomeStates.TaskState:
        _controller = taskController;
        tableName = 'task';
        break;

      case HomeStates.IssueState:
        _controller = issueController;
        tableName = 'issue';
        break;
    }
    return TableView(
      controller: _controller,
      tableName: tableName,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_buildTitleOfPage()),
      actions: [
        if (isAddButtonVisibile)
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _buildAddDatabase(),
                child: Text('Add ${_buildTitleOfPage(isForTitle: false)}'),
              ),
              SizedBox(width: 10),
              if (homeController.homeStates == HomeStates.TaskState)
                ElevatedButton(
                  onPressed: controller.onAddTaskPressed,
                  child: Text('Add task'),
                ),
            ],
          ),
        SizedBox(width: 10),
        Center(
          child: staffController.currentStaff != null
              ? Text(staffController.currentStaff!.initial)
              : CircularProgressIndicator(),
        ),
        IconButton(
          onPressed: () => authManager.signOut(),
          icon: Icon(Icons.logout),
        ),
      ],
    );
  }

  bool get isAddButtonVisibile {
    return staffController.isCoordinator ||
        (controller.homeStates == HomeStates.IssueState &&
            valueController.documents
                .where((e) =>
                    e!.employeeId == staffController.currentUserId &&
                    stageController.getById(e.stageId)!.index == 8 &&
                    e.linkingToGroupDateTime == null)
                .isNotEmpty);
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
              controller.homeStates = HomeStates.TaskState;
              Get.back();
            },
          ),
          SizedBox(height: 10),
          TextButton.icon(
            icon: Icon(Icons.golf_course),
            label: const Text('Reference Documents'),
            onPressed: () {
              controller.homeStates = HomeStates.ReferenceDocumentState;
              Get.back();
            },
          ),
          SizedBox(height: 10),
          TextButton.icon(
            icon: Icon(Icons.local_activity),
            label: const Text('Lists'),
            onPressed: () {
              controller.homeStates = HomeStates.ListState;
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
            label: const Text('Drawings'),
            onPressed: () {
              controller.homeStates = HomeStates.TaskState;
              Get.back();
            },
          ),
          SizedBox(height: 10),
          TextButton.icon(
            icon: Icon(Icons.print),
            label: const Text('Issues'),
            onPressed: () {
              controller.homeStates = HomeStates.IssueState;
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  String _buildTitleOfPage({bool isForTitle = true}) {
    switch (controller.homeStates) {
      case HomeStates.ActivityState:
        return isForTitle ? 'Activity Code' : 'activity code';
      case HomeStates.ReferenceDocumentState:
        return isForTitle ? 'Reference Documents' : 'reference document';
      case HomeStates.ListState:
        return isForTitle ? 'Lists' : 'list items';
      case HomeStates.StaffState:
        return isForTitle ? 'Staff' : 'employee';
      case HomeStates.TaskState:
        return isForTitle ? 'Drawings' : 'drawing';
      case HomeStates.IssueState:
        return isForTitle ? 'Issue' : 'issue';
    }
  }

  _buildAddDatabase() {
    switch (controller.homeStates) {
      case HomeStates.ActivityState:
        return activityController.buildAddForm();
      case HomeStates.ReferenceDocumentState:
        return refDocController.buildAddForm();
      case HomeStates.StaffState:
        return staffController.buildAddForm();
      case HomeStates.TaskState:
        return drawingController.buildAddForm();
      case HomeStates.ListState:
        return listsController.buildAddForm();
      case HomeStates.IssueState:
        return issueController.buildAddForm();
    }
  }
}
