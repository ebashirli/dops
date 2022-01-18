import 'package:dops/components/custom_dropdown_menu_with_model_widget.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:flutter/material.dart';

class CoordinatorFormWidget extends StatelessWidget {
  CoordinatorFormWidget({
    Key? key,
    required this.index,
    required this.formKey,
  }) : super(key: key);
  final int index;
  final GlobalKey<FormState> formKey;

  bool _isCoordinator = stageController.isCoordinator;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CustomDropdownMenuWithModel<StaffModel>(
                        isMultiselection: ![0, 6, 7].contains(index),
                        itemAsString: (StaffModel? item) =>
                            '${item!.name} ${item.surname}',
                        labelText: stageDetailsList[index]['staff job'],
                        onChanged: (List) {},
                        selectedItems: [],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  SizedBox(width: 10),
                  if (_isCoordinator && taskStages.last.index == index)
                    ElevatedButton(
                      onPressed: () {
                        _onAssignOrUpdatePressed(
                          index: index,
                          lastStageId: stageStageModels.last.id!,
                          assigningEmployeeIds:
                              assigningEmployeeIdsList[index].toSet(),
                          assignedEmployeeIds: coordinatorAssigns
                              ? null
                              : stageValueModelsLists.last!
                                  .map((valueModel) => valueModel!.employeeId)
                                  .toSet(),
                        );
                      },
                      child: Container(
                        height: 48,
                        child: Center(
                          child: Text(
                            (coordinatorAssigns) ? 'Assign' : 'Update',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  void _onAssignOrUpdatePressed({
    required int index,
    required String lastStageId,
    required Set assigningEmployeeIds,
    Set? assignedEmployeeIds,
  }) async {
    ValueModel vm = await ValueModel(
      stageId: lastStageId,
      employeeId: '',
      assignedBy: auth.currentUser!.uid,
      assignedDateTime: DateTime.now(),
    );
    if (assignedEmployeeIds == null) {
      // asigning
      assigningEmployeeIds.forEach((employeeId) async {
        vm.employeeId = employeeId;
        valueController.addNew(model: vm);
      });
    } else {
      // updating
      assigningEmployeeIds
          .difference(assignedEmployeeIds)
          .forEach((employeeId) async {
        vm.employeeId = employeeId;
        valueController.addNew(model: vm);
      });
      assignedEmployeeIds
          .difference(assigningEmployeeIds)
          .forEach((employeeId) async {
        final String valueId = valueController.documents
            .singleWhere(
              (valueModel) => (valueModel!.isHidden == false &&
                  valueModel.stageId == lastStageId &&
                  valueModel.employeeId == employeeId),
            )!
            .id!;
        valueController.addValues(map: {'isHidden': true}, id: valueId);
      });
    }
  }

  void _onSubmitPressed(
      {required int index,
      required ValueModel assignedValueModel,
      required StageModel lastTaskStage,
      required bool isLastSubmit,
      bool isCommented = false}) async {
    Map<String, dynamic> map = {};

    numberFieldNames(index).forEach(
      (String? fieldName) {
        if (fieldName != null) {
          map[fieldName.toLowerCase()] = int.parse(
            controllersListForNumberFields[index]![fieldName.toLowerCase()]!
                .text,
          );
        }
      },
    );

    map['note'] = controllersListForNote[index].text;
    map['fileNames'] = fileNamesList[index];
    map['submitDateTime'] = DateTime.now();
    map['isCommented'] = isCommented;

    valueController.addValues(
      map: map,
      id: assignedValueModel.id!,
    );

    if (isLastSubmit) {
      bool anyComment = await valueController.documents.any((valueModel) =>
              valueModel!.stageId == lastTaskStage.id &&
              valueModel.isCommented) ||
          isCommented;

      StageModel stage = StageModel(
        taskId: lastTaskStage.taskId,
        index: anyComment ? 4 : index + 1,
        checkerCommentCounter: (isCommented && index == 5)
            ? lastTaskStage.checkerCommentCounter + 1
            : 0,
        reviewerCommentCounter: (isCommented && index == 6)
            ? lastTaskStage.reviewerCommentCounter + 1
            : 0,
        creationDateTime: DateTime.now(),
      );

      String nextStageId = await addNew(model: stage);

      if (index == 3 || ((index == 5 || index == 6) && anyComment)) {
        final String? designingId = await documents
            .singleWhere((stageModel) =>
                stageModel.index == 1 &&
                stageModel.taskId == lastTaskStage.taskId)
            .id;

        final String? draftingId = await documents
            .singleWhere((stageModel) =>
                stageModel.index == 2 &&
                stageModel.taskId == lastTaskStage.taskId)
            .id;

        final List<String?> designerIds = valueController.documents
            .where((valueModel) => valueModel!.stageId == designingId)
            .map((valueModel) => valueModel!.employeeId)
            .toList();
        final List<String?> drafterIds = valueController.documents
            .where((valueModel) => valueModel!.stageId == draftingId)
            .map((valueModel) => valueModel!.employeeId)
            .toList();

        [...designerIds, ...drafterIds].toSet().forEach((designerId) {
          valueController.addNew(
            model: ValueModel(
              stageId: nextStageId,
              employeeId: designerId,
              assignedBy: auth.currentUser!.uid,
              assignedDateTime: DateTime.now(),
            ),
          );
        });
      } else if (index == 4) {
        final String? checkingId = await documents
            .singleWhere((stageModel) =>
                stageModel.index == 3 &&
                stageModel.taskId == lastTaskStage.taskId)
            .id;
        final List<String?> checkerIds = valueController.documents
            .where((valueModel) => valueModel!.stageId == checkingId)
            .map((valueModel) => valueModel!.employeeId)
            .toList();

        checkerIds.forEach((checkerId) {
          valueController.addNew(
            model: ValueModel(
              stageId: nextStageId,
              employeeId: checkerId,
              assignedBy: auth.currentUser!.uid,
              assignedDateTime: DateTime.now(),
            ),
          );
        });
      }
    }
  }
}
