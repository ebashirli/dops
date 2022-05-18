import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/table_view_widget.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/list/lists_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  late String tableName;

  @override
  Widget build(BuildContext context) {
    controller.requestNotificationPermission();
    return Obx(() {
      return Scaffold(
        drawer: _buildDrawer(),
        appBar: _buildAppBar(),
        body: _buildBody(),
      );
    });
  }

  Widget _buildBody() {
    return controller.currentViewModel.value.isTableView
        ? TableViewWidget()
        : ListsView();
  }

  AppBar _buildAppBar() => AppBar(
        title: CustomText(
          controller.currentViewModel.value.title,
        ),
        actions: [
          CircleAvatar(
            child: Text(
              cacheManager.getStaff()!.initial,
              style: TextStyle(fontSize: 13),
            ),
          ),
          CustomPopUpMenuWidget(),
        ],
      );

  Widget _buildDrawer() {
    final int length = controller.viewProperties.length;
    return Container(
      width: Get.width * .11,
      color: Colors.white,
      padding: EdgeInsets.only(top: Get.height * .1, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          staffController.isCoordinator ? length : length - 2,
          (index) {
            return Column(
              children: [
                TextButton(
                  child: Text(controller.generateViewModel(index: index).title),
                  onPressed: () => controller.onDrawerMenuItemPressed(index),
                  style: ButtonStyle(alignment: Alignment.centerLeft),
                ),
                SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
