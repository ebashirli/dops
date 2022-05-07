import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:get/get.dart';

import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/issue/issue_model.dart';

class NestingStageForm extends StatelessWidget {
  NestingStageForm({Key? key}) : super(key: key);
  final TextEditingController textEditingController = TextEditingController();
  final RxList<IssueModel?> selectedIssueModel = RxList(<IssueModel?>[]);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDropdownMenuWithModel<IssueModel>(
                items: items,
                selectedItems: selectedIssueModel,
                onChanged: onChanged,
                itemAsString: itemAsString,
                labelText: 'Group Number',
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
                onPressed: onPressed,
                child: Text('Link to Group'),
              ),
            ],
          )
        ],
      ),
    );
  }

  void onPressed() {
    String groupId = selectedIssueModel.first!.id!;
    IssueModel? issueModel = issueController.getById(groupId);
    List<String?> linkedTasks =
        issueModel == null ? [] : issueModel.linkedTaskIds;

    linkedTasks.add(stageController.currentTask!.id);
    valueController.addValues(
      map: {
        'linkingToGroupDateTime': DateTime.now(),
        'note': stageController.textEditingControllers.last.text,
      },
      id: stageController.stageAndValueModelsOfCurrentTask[8]!.values.first
          .singleWhereOrNull(
              (e) => e!.employeeId == staffController.currentUserId)!
          .id!,
    );
    issueController.addValues(
      map: {'linkedTasks': linkedTasks},
      id: groupId,
    );
  }

  String itemAsString(IssueModel? issueModel) =>
      issueModel != null ? 'Group #${issueModel.groupNumber.toString()}' : '';

  void onChanged(List<IssueModel?> issueModelList) =>
      selectedIssueModel.value = issueModelList;

  List<IssueModel> get items {
    return issueController.documents
        .where(
          (e) =>
              e.createdBy == staffController.currentUserId &&
              e.issueDate == null,
        )
        .toList();
  }
}
