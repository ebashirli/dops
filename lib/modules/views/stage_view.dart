import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/widgets/stages/stage_widgets.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fieldsPanelHeigth = Get.height * .39;
    return Scaffold(
      appBar: stageViewAppBar(),
      // floatingActionButton: CustomExpendableFab(),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: drawingController.loading ||
                    taskController.loading ||
                    stageController.loading ||
                    valueController.loading ||
                    stageController.documents.isEmpty
                ? LinearProgressIndicator(
                    backgroundColor: light,
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: fieldsPanelHeigth,
                        child: FieldsPanelWidget(),
                      ),
                      SizedBox(
                        height: Get.height - fieldsPanelHeigth,
                        child: CustomExpansionPanelList(
                          data: stageController.generateItems(),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  AppBar stageViewAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: (() => Get.toNamed(Routes.HOME)),
        icon: Icon(Icons.home),
      ),
      actions: [
        CircleAvatar(
          child: Text(
            cacheManager.getStaff!.initial,
            style: TextStyle(fontSize: 13),
          ),
        ),
        CustomPopUpMenuWidget(isStageView: true)
      ],
    );
  }
}
