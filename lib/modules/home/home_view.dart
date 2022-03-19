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
        _controller = referenceDocumentController;
        tableName = 'reference document';
        break;

      case HomeStates.DropdownSourceListState:
        return ListsView();

      case HomeStates.StaffState:
        _controller = staffController;
        tableName = 'staff';
        break;

      case HomeStates.TaskState:
        _controller = taskController;
        tableName = 'task';
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
        if (staffController.isCoordinator)
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _buildAddDatabase(),
                child: Text('Add ${_buildTitleOfPage(isForTitle: false)}'),
              ),
              SizedBox(width: 10),
              if (homeController.homeStates == HomeStates.TaskState)
                ElevatedButton(
                  onPressed: controller.onEditPressed,
                  child: Text('Add task'),
                ),
            ],
          ),
        SizedBox(width: 10),
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

  String _buildTitleOfPage({bool isForTitle = true}) {
    switch (controller.homeStates) {
      case HomeStates.ActivityState:
        return isForTitle ? 'Activity Code' : 'activity code';
      case HomeStates.ReferenceDocumentState:
        return isForTitle ? 'Reference Documents' : 'reference document';
      case HomeStates.DropdownSourceListState:
        return isForTitle ? 'Lists' : 'list items';
      case HomeStates.StaffState:
        return isForTitle ? 'Staff' : 'employee';
      case HomeStates.TaskState:
        return isForTitle ? 'Drawings' : 'drawing';
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
