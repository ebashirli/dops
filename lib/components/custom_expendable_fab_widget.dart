import 'package:dops/constants/constant.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:expendable_fab/expendable_fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomExpendableFab extends StatelessWidget {
  const CustomExpendableFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !staffController.isCoordinator
        ? SizedBox.shrink()
        : ExpendableFab(
            distance: 80.0,
            children: [
              ActionButton(
                onPressed: () {
                  taskController.deleteTask(Get.parameters['id']!);
                  Get.offAndToNamed(Routes.SPLASH);
                },
                icon: const Icon(
                  Icons.dangerous,
                  color: Colors.red,
                ),
              ),
              ActionButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_attributes),
              ),
            ],
          );
  }
}
