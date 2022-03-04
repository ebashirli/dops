import 'package:dops/constants/constant.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:expendable_fab/expendable_fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: staffController.documents.isNotEmpty
                ? Text(
                    staffController.documents
                        .singleWhere(
                            (staff) => staff.id == auth.currentUser!.uid)
                        .initial,
                  )
                : CircularProgressIndicator(),
          ),
          IconButton(
            onPressed: () {
              authManager.signOut();
              Get.offAndToNamed(Routes.SPLASH);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: ExpendableFab(
        distance: 80.0,
        children: [
          ActionButton(
            onPressed: () {
              taskController.deleteTask(Get.parameters['id']!);
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
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // stageController.buildEditForm(),
              SizedBox(height: 10),
              stageController.buildPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
