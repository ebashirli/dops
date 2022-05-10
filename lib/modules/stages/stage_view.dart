// import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/stages/widgets/custom_expansion_panel_list.dart';
import 'package:dops/modules/stages/widgets/fields_panel/fields_panel_widget.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: stageViewAppBar(),
        // floatingActionButton: CustomExpendableFab(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
          child: Column(
            children: [
              FieldsPanelWidget(),
              SizedBox(
                height: Get.height * .54,
                child: Center(
                  child: Obx(() {
                    return stageController.loading.value ||
                            stageController.documents.isEmpty
                        ? CircularProgressIndicator()
                        : CustomExpansionPanelList(
                            data: stageController.generateItems(),
                          );
                  }),
                ),
              ),
            ],
          ),
        ),
      );

  AppBar stageViewAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: (() => Get.toNamed(Routes.HOME)),
        icon: Icon(Icons.home),
      ),
      actions: [
        Center(child: CustomText(cacheManager.getStaff()!.initial)),
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
