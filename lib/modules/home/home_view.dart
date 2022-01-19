import 'package:dops/components/table_view_widget.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/list/lists_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
import '../../enum.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  late GetxService tableController;
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
        tableController = activityController;
        tableName = 'activity';
        break;

      case HomeStates.ReferenceDocumentState:
        tableController = referenceDocumentController;
        tableName = 'reference document';
        break;

      case HomeStates.DropdownSourceListState:
        return ListsView();

      case HomeStates.StaffState:
        tableController = staffController;
        tableName = 'staff';
        break;

      case HomeStates.TaskState:
        tableController = taskController;
        tableName = 'task';
        break;
    }
    return TableView(
      controller: tableController,
      tableName: tableName,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_buildTitleOfPage()),
      actions: [
        if (authManager.isCoordinator.value)
          IconButton(
            onPressed: () {
              _buildAddDatabase();
            },
            icon: Icon(Icons.add),
          ),
        Center(
          child: staffController.documents.isNotEmpty
              ? Text(
                  staffController.documents
                      .singleWhere((staff) => staff.id == auth.currentUser!.uid)
                      .initial,
                )
              : CircularProgressIndicator(),
        ),
        IconButton(
          onPressed: () {
            authManager.signOut();
          },
          icon: Icon(Icons.logout),
        ),
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
              controller.homeStates = HomeStates.TaskState;
              Get.back();
            },
          ),
          SizedBox(height: 10),
          // if (authManager.staffModel!.value.systemDesignation != UserRole.User)
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
          // if (authManager.staffModel!.value.systemDesignation == UserRole.Admin)
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
        return 'Drawings';
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
        return drawingController.buildAddEdit();
      case HomeStates.DropdownSourceListState:
        return listsController.buildAddEdit();
    }
  }
}
