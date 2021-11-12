import 'package:dops/views/table_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dops/controllers/reference_document_controller.dart';

class ReferenceDocumentView extends StatelessWidget {
  final controller = Get.find<ReferenceDocumentController>();
  final tableName = 'reference document';

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Stack(children: [
          if (controller.getDataForTableView.isEmpty)
            Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          TableView(
            controller: controller,
            tableName: tableName,
          )
        ]);
      },
    );
  }
}
