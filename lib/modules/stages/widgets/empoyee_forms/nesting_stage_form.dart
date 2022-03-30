import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NestingStageForm extends StatelessWidget {
  NestingStageForm({Key? key}) : super(key: key);
  final RxList issueGroupNumbersList = RxList([1, 2, 3, 4, 5]);
  late final RxList filteredList;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    filteredList = issueGroupNumbersList;

    return Form(
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextFormField(
                width: 100,
                controller: textEditingController,
                sizeBoxHeight: 0,
              ),
              SizedBox(width: 20),
              CustomTextFormField(
                sizeBoxHeight: 0,
                width: 340,
                maxLines: 2,
                labelText: 'Note',
                controller: stageController.textEditingControllers.last,
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Add to Group'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
