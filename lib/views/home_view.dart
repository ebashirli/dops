import 'package:dops/controllers/activity_code_controller.dart';
import 'package:dops/controllers/reference_document_controller.dart';
import 'package:dops/views/activity_code_view.dart';
import 'package:dops/views/reference_document_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../enum.dart';

class HomeView extends GetView<HomeController> {
  final activityCodeController = Get.find<ActivityCodeController>();
  final referenceDocumentController = Get.find<ReferenceDocumentController>();

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
      case HomeStates.ActivityCodeState:
        return ActivityCodeView();
      case HomeStates.ReferenceDocumentState:
        return ReferenceDocumentView();

      case HomeStates.DropdownSourceListState:
        return Container(child: const Text('dropwdown'));

      case HomeStates.UserState:
        return Container(child: const Text('user'));
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
              controller.homeStates = HomeStates.UserState;
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
            label: const Text('Dropdown Source List'),
            onPressed: () {
              controller.homeStates = HomeStates.DropdownSourceListState;
              Get.back();
            },
          ),
          SizedBox(height: 10),
          TextButton.icon(
            icon: Icon(Icons.add),
            label: const Text('Activity Code'),
            onPressed: () {
              controller.homeStates = HomeStates.ActivityCodeState;
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  String _buildTitleOfPage() {
    switch (controller.homeStates) {
      case HomeStates.ActivityCodeState:
        return 'Activity Code';
      case HomeStates.ReferenceDocumentState:
        return 'Reference Documents';

      case HomeStates.DropdownSourceListState:
        return 'Dropdown Source List';

      case HomeStates.UserState:
        return 'Users';
    }
  }

  _buildAddDatabase() {
    switch (controller.homeStates) {
      case HomeStates.ActivityCodeState:
        return activityCodeController.buildAddEdit();
      case HomeStates.ReferenceDocumentState:
        return referenceDocumentController.buildAddEdit();

      case HomeStates.DropdownSourceListState:
        return;

      case HomeStates.UserState:
        return;
    }
  }
}
