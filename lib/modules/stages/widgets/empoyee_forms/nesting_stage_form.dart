import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/issue/issue_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                items: issueController.documents
                    .where((e) => e.createdBy == staffController.currentUserId)
                    .toList(),
                selectedItems: selectedIssueModel,
                onChanged: (List<IssueModel?> issueModelList) =>
                    selectedIssueModel.value = issueModelList,
                itemAsString: (IssueModel? issueModel) => issueModel != null
                    ? 'Group #${issueModel.groupNumber.toString()}'
                    : '',
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
                onPressed: () {
                  String groupId = selectedIssueModel.first!.id!;
                  List<String?> linkedTasks = issueController.documents
                      .singleWhere((e) => e.id == groupId)
                      .linkedTasks;

                  linkedTasks.add(stageController.currentTask!.id);
                  valueController.addValues(
                    map: {
                      'linkingToGroupDateTime': DateTime.now(),
                      'note': stageController.textEditingControllers.last.text,
                    },
                    id: stageController
                        .valueModelsOfCurrentTask[8]!.values.first
                        .singleWhere((e) =>
                            e!.employeeId == staffController.currentUserId)!
                        .id!,
                  );
                  issueController.addValues(
                    map: {'linkedTasks': linkedTasks},
                    id: groupId,
                  );
                },
                child: Text('Link to Group'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
