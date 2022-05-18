import 'package:dops/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterColumnsWidget extends StatelessWidget {
  const FilterColumnsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildGroupCheckBox(homeController.allColumns.value),
        Divider(),
        SizedBox(
          height: Get.height * .3,
          width: Get.width * .21,
          child: ListView(
            children: [
              ...homeController.columns.map(buildSingleCheckBox).toList(),
            ],
          ),
        ),
        SizedBox(height: 14),
        Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                homeController.columnNames.value = homeController.columns
                    .where((e) => e.value.value)
                    .map((e) => e.title)
                    .toList();
                Get.back();
              },
              child: Text('Done'),
            ),
          ],
        )
      ],
    );
  }

  Widget buildSingleCheckBox(CheckBoxState checkBox) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * .2,
          child: Obx(() {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: checkBox.value.value,
              onChanged: (v) {
                checkBox.value.value = v!;
                homeController.allColumns.value.value.value =
                    homeController.columns.every((e) => e.value.value);
              },
              title: Text(checkBox.title),
            );
          }),
        ),
      ],
    );
  }

  buildGroupCheckBox(CheckBoxState checkBox) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * .2,
          child: Obx(() {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: checkBox.value.value,
              onChanged: toggleGroupCheckbox,
              title: Text(checkBox.title),
            );
          }),
        ),
      ],
    );
  }

  void toggleGroupCheckbox(bool? value) {
    if (value == null) return;
    homeController.allColumns.value.value.value = value;
    homeController.columns.forEach((e) => e.value.value = value);
  }
}

class CheckBoxState {
  final String title;
  final RxBool value;
  CheckBoxState({
    required this.title,
    required this.value,
  });
}
