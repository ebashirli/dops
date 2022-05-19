import 'package:dops/components/filter_columns_widget.dart';
import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPopUpMenuWidget extends StatelessWidget {
  const CustomPopUpMenuWidget({Key? key, this.isStageView}) : super(key: key);
  final bool? isStageView;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      onSelected: (item) => onSelected(context, item),
      itemBuilder: (context) => [
        if (homeController.isAddButtonVisibile &&
            isStageView == null &&
            !homeController.currentViewModel.value.isMonitoring)
          buildItem(MenuItems.itemAdd),
        if (homeController.isAddTaskButtonVisibile && isStageView == null)
          buildItem(MenuItems.itemAddTask),
        if (isStageView == null) buildItem(MenuItems.itemColumns),
        PopupMenuDivider(),
        buildItem(MenuItems.itemSignOut),
      ],
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: Colors.black, size: 20),
            const SizedBox(width: 10),
            Text(item.text),
          ],
        ),
      );

  onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemAdd:
        homeController.currentViewModel.value.isDrawings
            ? drawingController.buildAddForm()
            : homeController.currentViewModel.value.controller!.buildAddForm();
        break;
      case MenuItems.itemAddTask:
        homeController.dataGridController.value.selectedRow == null
            ? selectItemSnackbar()
            : taskController.buildAddForm(parentId: homeController.drawingdId);
        break;
      case MenuItems.itemColumns:
        homeController.getDialog(
          title: 'Filter Columns',
          content: FilterColumnsWidget(),
        );
        break;
      case MenuItems.itemSignOut:
        authManager.signOut();
        Get.offAndToNamed(Routes.SPLASH);
        break;
      default:
    }
  }
}

class MenuItem {
  final String text;
  final IconData icon;
  const MenuItem({required this.text, required this.icon});
}

class MenuItems {
  static const List<MenuItem> itemsFirst = [itemAdd, itemAddTask];
  static const List<MenuItem> itemsSecond = [itemSignOut];
  static const itemAdd = MenuItem(
    text: 'Add',
    icon: Icons.add,
  );

  static const itemAddTask = MenuItem(
    text: 'Add task',
    icon: Icons.add_task,
  );

  static const itemColumns = MenuItem(
    text: 'Filter Columns',
    icon: Icons.view_column,
  );

  static const itemSignOut = MenuItem(
    text: 'Sign out',
    icon: Icons.logout,
  );
}
