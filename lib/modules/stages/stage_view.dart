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
      floatingActionButton: Visibility(
        visible: authManager.isCoordinator.value,
        child: ExpendableFab(
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
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
        child: StreamBuilder<Object>(
            stream: taskController.documents.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData || taskController.documents.isNotEmpty) {
                return Column(
                  children: [
                    stageController.buildEditForm(),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        controller: ScrollController(),
                        children: [
                          Obx(() => stageController.buildPanel()),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
