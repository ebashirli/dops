import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: stageViewAppBar(),
      floatingActionButton: CustomExpendableFab(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              stageController.buildEditForm(),
              SizedBox(height: 10),
              Center(child: stageController.buildPanel()),
            ],
          ),
        ),
      ),
    );
  }

  AppBar stageViewAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: (() => Get.toNamed(Routes.HOME)),
        icon: Icon(Icons.home),
      ),
      actions: [
        Center(child: Text(cacheManager.getStaff()!.initial)),
        IconButton(
          onPressed: () {
            authManager.signOut();
            Get.offAndToNamed(Routes.SPLASH);
          },
          icon: Icon(Icons.logout),
        ),
      ],
    );
  }
}
