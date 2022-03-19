import 'dart:math';
import 'package:dops/components/custom_widgets.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/widgets/value_table_view_widget.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/stages/widgets/custom_expansion_panel_list.dart';
import 'package:dops/modules/stages/widgets/expantion_panel_item_model.dart';
import 'package:dops/modules/stages/widgets/coordinator_form.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import 'package:dops/constants/constant.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/stages/stage_repository.dart';
import 'package:dops/modules/stages/widgets/fields_panel.dart/build_edit_form_widget.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import 'widgets/empoyee_forms/employee_forms.dart';

class StageController extends GetxService {
  final _repository = Get.find<StageRepository>();
  static StageController instance = Get.find();

  RxList<StageModel?> _documents = RxList<StageModel>([]);
  List<StageModel?> get documents => _documents;

  TaskModel get currentTask => taskController.documents
      .singleWhere((e) => e!.id == Get.parameters['id'])!;

  DrawingModel get currentDrawing =>
      drawingController.documents.singleWhere((e) => e.id == currentTask.id);

  List<StageModel?> get taskStages {
    List<StageModel?> _taskStages = documents.isNotEmpty
        ? documents
            .where((stageModel) => stageModel!.taskId == Get.parameters['id'])
            .toList()
        : [];
    if (_taskStages.isNotEmpty)
      _taskStages
          .sort((a, b) => a!.creationDateTime.compareTo(b!.creationDateTime));
    return _taskStages;
  }

  int get maxIndex =>
      taskStages.map((stageModel) => stageModel!.index).reduce(max);

  int get lastIndex => taskStages.last!.index;

  RxList<StaffModel?> assigningStaffModels = RxList([]);
  List<StaffModel?> get assignedStaffModels => taskValueModels[lastIndex]
      .values
      .last
      .map((e) => staffController.documents
          .singleWhere((element) => element.id == e?.employeeId))
      .toList();

  List<Map<StageModel, List<ValueModel?>>> get taskValueModels => List.generate(
        maxIndex + 1,
        (index) => Map.fromIterable(
          taskStages
              .where((StageModel? stageModel) => stageModel!.index == index),
          key: (stageModel) => stageModel,
          value: (stageModel) => valueController.documents
              .where((ValueModel? valueModel) =>
                  valueModel!.stageId == stageModel.id)
              .toList(),
        ),
      );

  bool get coordinatorAssigns => taskValueModels[lastIndex].values.last.isEmpty;

  bool get isLastSubmit =>
      lastTaskStageValues.where((element) {
        return element!.submitDateTime == null;
      }).length ==
      1;

  StageModel get lastTaskStage => taskValueModels[lastIndex].keys.last;

  List<ValueModel?> get lastTaskStageValues =>
      taskValueModels[lastIndex].values.last;

  ValueModel? get valueModelAssignedCurrentUser {
    List<ValueModel?> valueModelList = lastTaskStageValues.where(
      (element) {
        return element!.employeeId == staffController.currentUserId;
      },
    ).toList();
    return valueModelList.isNotEmpty ? valueModelList[0] : null;
  }

  bool isWorkerFormVisible(ExpantionPanelItemModel item) =>
      valueModelAssignedCurrentUser == null
          ? false
          : valueModelAssignedCurrentUser!.submitDateTime == null &&
              item.index == stageController.lastIndex;

  List<String> get specialFieldNames =>
      stageDetailsList[lastIndex]['form fields'];

  late List<TextEditingController> textEditingControllers;

  late RxList<String> fileNames = RxList<String>([]);
  late RxBool commentStatus = false.obs;

  final RxBool commentCheckbox = false.obs;

  final RxInt nestingGroup = 0.obs;

  @override
  void onInit() {
    _documents.bindStream(_repository.getAllDocumentsAsStream());
    textEditingControllers =
        List<TextEditingController>.generate(5, (_) => TextEditingController());
    super.onInit();
  }

  Widget buildEditForm() => BuildEditFormWidget();
  Widget buildPanel() {
    return Obx(() {
      final List<Widget> children = documents.isNotEmpty
          ? [
              CustomExpansionPanelList(data: generateItems(maxIndex + 1)),
              SizedBox(height: 200),
            ]
          : [CircularProgressIndicator()];

      return Column(children: children);
    });
  }

  List<ExpantionPanelItemModel> generateItems(int numberOfItems) {
    return List<ExpantionPanelItemModel>.generate(numberOfItems, (int index) {
      final Widget workerForm = index == 7
          ? FilingStageForm()
          : index == 8
              ? NestingStageForm()
              : WorkerForm(
                  index: index,
                  visible: lastIndex == index,
                );
      final Widget coordinatorForm =
          CoordinatorForm(index: index, visible: lastIndex == index);
      final Widget valueTableView = ValueTableView(
        index: index,
        stageValueModelsList: taskValueModels[index]
            [taskValueModels[index].keys.last],
      );
      final String headerValue =
          '${index + 1} | ${stageDetailsList[index]['name']}';

      return ExpantionPanelItemModel(
        headerValue: headerValue,
        coordinatorForm: coordinatorForm,
        workerForm: workerForm,
        valueTable: valueTableView,
        index: index,
      );
    });
  }

  Future<String> addNew({required StageModel model}) async {
    CustomFullScreenDialog.showDialog();
    model.creationDateTime = DateTime.now();
    await _repository.add(model).then((value) => model.id = value);
    CustomFullScreenDialog.cancelDialog();
    return model.id!;
  }

  Map<String, List<List<String>>> getValueModelRows(index) {
    List<String> allColumnHeaders = [
      'Employee Initial',
      ...stageDetailsList[index]['columns'],
      'Note',
      'Assigned date time',
      'Submit date time',
    ];

    List<ValueModel?> valueModelList = taskValueModels[index].values.last;

    List<String> specialFieldNames = stageDetailsList[index]['columns']
      ..remove('File Names');

    List<List<String>> rows = valueModelList.isNotEmpty
        ? valueModelList.map((ValueModel? valueModel) {
            return [
              cacheManager.getStaff()!.initial,
              ...specialFieldNames
                  .map((fn) => valueModel!.toMap()[fn.toLowerCase()] != null
                      ? valueModel.toMap()[ReCase(fn).camelCase].toString()
                      : '')
                  .toList(),
              valueModel!.note ?? '',
              DateFormat('yyyy-MM-dd kk:mm:ss')
                  .format(valueModel.assignedDateTime),
              valueModel.submitDateTime != null
                  ? DateFormat('yyyy-MM-dd kk:mm:ss')
                      .format(valueModel.submitDateTime!)
                  : '',
            ];
          }).toList()
        : [];
    return {
      'headers': [allColumnHeaders],
      'rows': rows
    };
  }

  void onAssignOrUpdatePressed() async {
    Set<String?> assignedEmployeeIds = lastTaskStageValues.isNotEmpty
        ? lastTaskStageValues
            .map((ValueModel? valueModel) => valueModel!.employeeId)
            .toSet()
        : {};

    Set<String> assigningEmployeeIds =
        assigningStaffModels.map((e) => e!.id!).toSet();

    ValueModel vm = await ValueModel(
      stageId: lastTaskStage.id!,
      employeeId: '',
      assignedBy: auth.currentUser!.uid,
      assignedDateTime: DateTime.now(),
    );

    if (assignedEmployeeIds.isEmpty) {
      // asigning
      assigningEmployeeIds.forEach((employeeId) async {
        vm.employeeId = employeeId;
        valueController.addNew(model: vm);
      });
    } else {
      assignedEmployeeIds.difference(assigningEmployeeIds).forEach(
            (employeeId) => valueController.addValues(
                map: {'isHidden': true},
                id: lastTaskStageValues
                    .singleWhere((ValueModel? valueModel) =>
                        valueModel!.employeeId == employeeId)!
                    .id!),
          );
      assigningEmployeeIds
          .difference(assignedEmployeeIds)
          .forEach((employeeId) {
        vm.employeeId = employeeId;
        valueController.addNew(model: vm);
      });
    }
    assigningStaffModels.value = [];
  }

  void onSubmitPressed() async {
    Map<String, dynamic> map = {};

    for (var i = 0; i < specialFieldNames.length; i++) {
      map[specialFieldNames[i].toLowerCase()] =
          int.parse(textEditingControllers[i].text);
    }
    map['isCommented'] = commentStatus.value;
    map['note'] = textEditingControllers.last.text;
    map['fileNames'] = fileNames;
    map['submitDateTime'] = DateTime.now();

    valueController.addValues(
      map: map,
      id: valueModelAssignedCurrentUser!.id!,
    );

    if (isLastSubmit) {
      bool anyComment = await valueController.documents.any((valueModel) =>
              valueModel!.stageId == lastTaskStage.id &&
              valueModel.isCommented) ||
          commentStatus.value;

      StageModel stage = StageModel(
        taskId: lastTaskStage.taskId,
        index: anyComment ? 4 : lastIndex + 1,
        checkerCommentCounter: (commentStatus.value && lastIndex == 5)
            ? lastTaskStage.checkerCommentCounter + 1
            : 0,
        reviewerCommentCounter: (commentStatus.value && lastIndex == 6)
            ? lastTaskStage.reviewerCommentCounter + 1
            : 0,
        creationDateTime: DateTime.now(),
      );

      String nextStageId = await addNew(model: stage);

      final ValueModel valueModel = ValueModel(
        stageId: nextStageId,
        employeeId: '',
        assignedBy: 'System',
        assignedDateTime: DateTime.now(),
      );

      if (lastIndex == 4 ||
          ((lastIndex == 6 || lastIndex == 7) && anyComment)) {
        final List<String?> designerIds =
            taskValueModels[1].values.last.map((e) => e!.employeeId).toList();
        final List<String?> drafterIds =
            taskValueModels[2].values.last.map((e) => e!.employeeId).toList();

        [...designerIds, ...drafterIds].toSet().forEach((empId) {
          valueController.addNew(
            model: valueModel..employeeId = empId,
          );
        });
      } else if (lastIndex == 5) {
        final List<String?> checkerIds =
            taskValueModels[3].values.last.map((e) => e!.employeeId).toList();
        checkerIds.forEach((checkerId) {
          valueController.addNew(
            model: valueModel..employeeId = checkerId,
          );
        });
      } else if (lastIndex == 6 && taskValueModels[6].length > 1) {
        final List<String?> reviewerIds = taskValueModels[6]
            .values
            .toList()[taskValueModels[6].length - 2]
            .map((e) => e!.employeeId)
            .toList();
        reviewerIds.forEach((reviewerId) {
          valueController.addNew(
            model: valueModel..employeeId = reviewerId,
          );
        });
      }
    }
    textEditingControllers.forEach((e) => e.clear());
    fileNames.value = [];
    commentStatus.value = false;
    commentCheckbox.value = false;
  }

  void onFileButtonPressed({
    List<String>? allowedExtensions,
    bool allowMultiple = true,
    void Function(FilePickerResult result)? fun,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowMultiple: allowMultiple,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      fun != null
          ? fun(result)
          : fileNames.value = result.files.map((file) => file.name).toList();
    }
  }

  void onFileCountButtonPressed(fileNames) {
    Get.defaultDialog();
  }
}
