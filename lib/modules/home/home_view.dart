import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/table_view_widget.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/list/lists_view.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quick_notify/quick_notify.dart';

import 'home_controller.dart';
import '../../enum.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  late GetxService _controller;
  late String tableName;

  @override
  Widget build(BuildContext context) {
    requestNotificationPermission();
    return Obx(() {
      return Scaffold(
        drawer: _buildDrawer(),
        appBar: _buildAppBar(),
        body: _buildBody(),
      );
    });
  }

  Widget _buildBody() {
    switch (controller.homeState) {
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

      case HomeStates.MyTasksState:
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
      title: CustomText(_buildTitleOfPage()),
      actions: [
        if (isAddButtonVisibile)
          Row(
            children: [
              if (homeController.homeState != HomeStates.MyTasksState)
                ElevatedButton(
                  onPressed: () => _buildAddDatabase(),
                  child: Text('Add ${_buildTitleOfPage(isForTitle: false)}'),
                ),
              SizedBox(width: 10),
              if (homeController.homeState == HomeStates.TaskState)
                AddTaskElButton()
            ],
          ),
        SizedBox(width: 10),
        Center(
          child: staffController.currentStaff != null
              ? CustomText(staffController.currentStaff!.initial)
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
        (controller.homeState ==
            valueController.documents
                .where((e) => e!.employeeId == staffController.currentUserId)
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
            label: const Text('My Tasks'),
            onPressed: () {
              controller.homeState = HomeStates.MyTasksState;
              cacheManager.saveHomeState(HomeStates.MyTasksState);
              Get.back();
            },
          ),
          SizedBox(height: 10),
          TextButton.icon(
            icon: Icon(Icons.golf_course),
            label: const Text('Reference Documents'),
            onPressed: () {
              controller.homeState = HomeStates.ReferenceDocumentState;
              cacheManager.saveHomeState(HomeStates.ReferenceDocumentState);
              Get.back();
            },
          ),
          SizedBox(height: 10),
          if (staffController.isCoordinator)
            Column(
              children: [
                TextButton.icon(
                  icon: Icon(Icons.local_activity),
                  label: const Text('Lists'),
                  onPressed: () {
                    controller.homeState = HomeStates.ListState;
                    cacheManager.saveHomeState(HomeStates.ListState);
                    Get.back();
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          TextButton.icon(
            icon: Icon(Icons.add),
            label: const Text('Activities'),
            onPressed: () {
              controller.homeState = HomeStates.ActivityState;
              cacheManager.saveHomeState(HomeStates.ActivityState);
              Get.back();
            },
          ),
          SizedBox(height: 10),
          if (staffController.isCoordinator)
            Column(
              children: [
                TextButton.icon(
                  icon: Icon(Icons.people),
                  label: const Text('Staff'),
                  onPressed: () {
                    controller.homeState = HomeStates.StaffState;
                    cacheManager.saveHomeState(HomeStates.StaffState);
                    Get.back();
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          TextButton.icon(
            icon: Icon(Icons.task),
            label: const Text('Drawings'),
            onPressed: () {
              controller.homeState = HomeStates.TaskState;
              cacheManager.saveHomeState(HomeStates.TaskState);
              Get.back();
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  String _buildTitleOfPage({bool isForTitle = true}) {
    switch (controller.homeState) {
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
      case HomeStates.MyTasksState:
        return isForTitle ? 'My Tasks' : 'my tasks';
    }
  }

  _buildAddDatabase() {
    switch (controller.homeState) {
      case HomeStates.ActivityState:
        return activityController.buildAddForm();
      case HomeStates.ReferenceDocumentState:
        return refDocController.buildAddForm();
      case HomeStates.StaffState:
        return staffController.buildAddForm();
      case HomeStates.TaskState:
        return drawingController.buildAddForm();
      case HomeStates.MyTasksState:
        return;
      case HomeStates.ListState:
        return listsController.buildAddForm();
    }
  }
}

class AddTaskElButton extends StatelessWidget {
  const AddTaskElButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: taskController.onAddPressed,
      child: Text('Add task'),
    );
  }
}

requestNotificationPermission() async {
  await QuickNotify.requestPermission();
}
