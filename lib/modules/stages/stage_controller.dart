import 'dart:math';
import 'package:collection/collection.dart';

import 'package:dops/modules/values/value_model.dart';

import 'package:dops/components/custom_widgets.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/widgets/value_table_view_widget.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/stages/widgets/expantion_panel_item_model.dart';
import 'package:dops/modules/stages/widgets/coordinator_form.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import 'package:dops/constants/constant.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/stages/stage_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import 'widgets/empoyee_forms/employee_forms.dart';

class StageController extends GetxService {
  final _repository = Get.find<StageRepository>();
  static StageController instance = Get.find();

  RxList<StageModel?> _documents = RxList<StageModel>([]);
  List<StageModel?> get documents => _documents;
  RxBool loading = true.obs;
  late List<TextEditingController> textEditingControllers;
  late TextEditingController noteController;

  @override
  void onInit() {
    super.onInit();

    _documents.bindStream(_repository.getAllDocumentsAsStream());
    _documents.listen((List<StageModel?> stageModelList) {
      if (stageModelList.isNotEmpty) loading.value = false;
    });

    textEditingControllers =
        List<TextEditingController>.generate(5, (_) => TextEditingController());
    noteController = TextEditingController();
  }

  TaskModel? get currentTask =>
      currentTaskId == null ? null : taskController.getById(currentTaskId!);

  String? get currentTaskId => Get.parameters['id'];

  DrawingModel? get currentDrawing =>
      drawingController.drawingModelByTaskModel(currentTask);

  List<StageModel?> get stagesOfCurrentTask {
    List<StageModel?> _stagesOfCurrentTask =
        (documents.isNotEmpty || currentTask != null) || !loading.value
            ? documents
                .where((stageModel) => stageModel!.taskId == currentTask!.id)
                .toList()
            : [];
    if (_stagesOfCurrentTask.isNotEmpty)
      _stagesOfCurrentTask
          .sort((a, b) => a!.creationDateTime.compareTo(b!.creationDateTime));
    return _stagesOfCurrentTask;
  }

  StageModel? getById(String id) {
    return loading.value || documents.isEmpty
        ? null
        : documents.singleWhereOrNull((e) => e!.id == id);
  }

  int get maxIndex => stageAndValueModelsOfCurrentTask.length;

  int get lastIndex =>
      stagesOfCurrentTask.isEmpty ? 0 : stagesOfCurrentTask.last!.index;

  RxList<StaffModel?> assigningStaffModels = RxList([]);
  List<StaffModel?> get assignedStaffModels =>
      stageAndValueModelsOfCurrentTask[lastIndex]!
          .values
          .last
          .map<StaffModel?>((e) => staffController.documents
              .singleWhereOrNull((element) => element.id == e?.employeeId))
          .toList();

  List<Map<StageModel, List<ValueModel?>>?>
      get stageAndValueModelsOfCurrentTask {
    return currentTask != null
        ? getStagesAndValueModelsByTask(currentTask!)
        : [];
  }

  Map<StageModel, List<ValueModel?>>? getStageByTaskAndIndex(
      {required String taskId, required int index}) {
    TaskModel? taskModel = taskController.getById(taskId);

    return taskModel == null
        ? null
        : getStagesAndValueModelsByTask(taskModel)[index];
  }

  List<StageModel?> getStagesOfTask(TaskModel? taskModel) =>
      loading.value || taskModel == null
          ? []
          : documents.where((e) => e!.taskId == taskModel.id).toList();

  StageModel? getFirstStageOfFirstTask(TaskModel? taskModel) =>
      (stageController.loading.value || taskModel == null)
          ? null
          : documents.firstWhereOrNull(
              (e) => e!.index == 0 && e.taskId == taskModel.id);

  List<Map<StageModel, List<ValueModel?>>?> getStagesAndValueModelsByTask(
      TaskModel? taskModel) {
    if (documents.isEmpty || taskController.loading.value || taskModel == null)
      return [];

    List<StageModel?> stagesOfTask = getStagesOfTask(taskModel);
    if (stagesOfTask.isEmpty) return [];

    bool isFirstTask = taskController.checkFirstTask(taskModel);

    ValueModel? firstValueModelOfFirstTask = null;

    if (!isFirstTask) {
      TaskModel? firstTaskModel =
          taskController.loading.value || taskController.documents.isEmpty
              ? null
              : taskController.documents
                  .firstWhereOrNull((e) => e!.parentId == taskModel.parentId);
      StageModel? firstStageModel =
          firstTaskModel == null || documents.isEmpty || loading.value
              ? null
              : documents.firstWhereOrNull(
                  (e) => e!.taskId == firstTaskModel.id && e.index == 0);
      if (valueController.loading.value ||
          valueController.documents.isEmpty ||
          firstStageModel == null) {
        firstValueModelOfFirstTask = null;
      } else {
        Iterable<ValueModel?> valueModels = valueController.documents
            .where((e) => e!.stageId == firstStageModel.id);
        firstValueModelOfFirstTask =
            valueModels.isEmpty ? null : valueModels.first;
      }
    }
    return List.generate(
      stagesOfTask.map((e) => e!.index).reduce(max) + 1,
      (ind) {
        return Map<StageModel, List<ValueModel?>>.fromIterable(
          stagesOfTask.where((e) => e!.index == ind),
          key: (stageModel) => stageModel,
          value: (stageModel) => (ind == 0 && !isFirstTask)
              ? [firstValueModelOfFirstTask]
              : valueController.valueModelsByStageId(stageModel.id),
        );
      },
    );
  }

  List<ValueModel?> getFirstValueModelOfFirstTask(StageModel? stageModel) {
    List<ValueModel?> valueModels = valueController.loading.value ||
            valueController.documents.isEmpty ||
            stageModel == null
        ? []
        : valueController.documents
            .where((e) => e!.stageId == stageModel.id)
            .toList();

    return valueModels;
  }

  bool get coordinatorAssigns =>
      stageAndValueModelsOfCurrentTask[lastIndex]!.values.last.isEmpty;

  bool get isLastSubmit =>
      lastTaskStageValues.where((element) {
        return element!.submitDateTime == null;
      }).length ==
      1;

  bool isStageAssigned(TaskModel? taskModel) => taskModel == null
      ? false
      : !stageController
          .getStagesAndValueModelsByTask(taskModel)
          .map(
            (e) => e!.values
                .map((e1) => e1.map((e2) => e2!.submitDateTime).contains(null))
                .contains(true),
          )
          .contains(true);

  StageModel get lastTaskStage =>
      stageAndValueModelsOfCurrentTask[lastIndex]!.keys.last;

  List<ValueModel?> get lastTaskStageValues =>
      stageAndValueModelsOfCurrentTask[lastIndex]!.values.last;

  ValueModel? get valueModelAssignedCurrentUser {
    List<ValueModel?> valueModelList = lastTaskStageValues
        .where(
            (element) => element!.employeeId == staffController.currentUserId)
        .toList();
    return valueModelList.isNotEmpty ? valueModelList[0] : null;
  }

  String get labelText => stageDetailsList[lastIndex]['staff job'];

  bool isWorkerFormVisible(ExpantionPanelItemModel item) {
    return valueModelAssignedCurrentUser == null
        ? false
        : stageController.currentTask!.holdReason != null
            ? false
            : item.index != stageController.lastIndex
                ? false
                : (item.index == 8 &&
                        (valueModelAssignedCurrentUser!
                                .linkingToGroupDateTime !=
                            null))
                    ? false
                    : valueModelAssignedCurrentUser!.submitDateTime == null;
  }

  List<String> get specialFieldNames =>
      stageDetailsList[lastIndex]['form fields'];

  final RxList<String> fileNames = RxList<String>([]);
  final RxBool commentStatus = false.obs;

  final RxBool commentCheckbox = false.obs;

  final RxInt issueGroup = 0.obs;

  List<ExpantionPanelItemModel> generateItems() {
    return List<ExpantionPanelItemModel>.generate(
      maxIndex,
      (int index) {
        final Widget workerForm = index == 7
            ? FilingStageForm()
            : index == 8
                ? NestingStageForm()
                : WorkerForm(index: index, visible: lastIndex == index);
        final Widget coordinatorForm = CoordinatorForm();
        final Widget valueTableView = ValueTableView(
          index: index,
          stageValueModelsList: stageAndValueModelsOfCurrentTask[index]![
              stageAndValueModelsOfCurrentTask[index]!.keys.last],
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
      },
    );
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

    List<ValueModel?> valueModelList =
        stageAndValueModelsOfCurrentTask[index]!.values.last;

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

  addValues({required Map<String, dynamic> map, required String id}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.updateFileds(map, id);
    CustomFullScreenDialog.cancelDialog();
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
      assigningEmployeeIds.forEach((employeeId) async {
        vm.employeeId = employeeId;
        valueController.addNew(model: vm);
      });
    } else {
      assignedEmployeeIds.difference(assigningEmployeeIds).forEach(
            (employeeId) => valueController.addValues(
                map: {'isHidden': true},
                id: lastTaskStageValues
                    .singleWhereOrNull((ValueModel? valueModel) =>
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
    addValues(map: {'note': noteController.text}, id: lastTaskStage.id!);

    assigningStaffModels.value = [];
  }

  bool containsHoldFun(TaskModel taskModel) {
    if (taskModel.id == null) {
      return false;
    } else if (getStagesAndValueModelsByTask(taskModel).length < 8) {
      return false;
    } else {
      return valueController.loading.value
          ? false
          : getStagesAndValueModelsByTask(taskModel)[7]!.values.first.isEmpty
              ? false
              : getStagesAndValueModelsByTask(taskModel)[7]!
                      .values
                      .first
                      .first!
                      .hold !=
                  null;
    }
  }

  void onSubmitPressed() async {
    Map<String, dynamic> map = {};

    for (var i = 0; i < specialFieldNames.length; i++) {
      map[specialFieldNames[i].toLowerCase()] = specialFieldNames[i] == 'HOLD'
          ? textEditingControllers[i].text
          : int.parse(textEditingControllers[i].text);
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
      bool anyComment = await valueController.documents.any(
            (valueModel) =>
                valueModel!.stageId == lastTaskStage.id &&
                valueModel.isCommented,
          ) ||
          commentStatus.value;

      StageModel stage = StageModel(
        taskId: lastTaskStage.taskId,
        index: anyComment ? 4 : lastIndex + 1,
        checkerCommentCounter: lastIndex == 4
            ? lastTaskStage.checkerCommentCounter
            : (commentStatus.value && lastIndex == 5)
                ? lastTaskStage.checkerCommentCounter + 1
                : 0,
        reviewerCommentCounter: [4, 5].contains(lastIndex)
            ? lastTaskStage.reviewerCommentCounter
            : (commentStatus.value && lastIndex == 6)
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
        final List<String?> designerIds = stageAndValueModelsOfCurrentTask[1]!
            .values
            .last
            .map((e) => e!.employeeId)
            .toList();
        final List<String?> drafterIds = stageAndValueModelsOfCurrentTask[2]!
            .values
            .last
            .map((e) => e!.employeeId)
            .toList();

        [...designerIds, ...drafterIds].toSet().forEach((empId) {
          valueController.addNew(
            model: valueModel..employeeId = empId,
          );
        });
      } else if (lastIndex == 5) {
        final List<String?> checkerIds = stageAndValueModelsOfCurrentTask[3]!
            .values
            .last
            .map((e) => e!.employeeId)
            .toList();
        checkerIds.forEach((checkerId) {
          valueController.addNew(
            model: valueModel..employeeId = checkerId,
          );
        });
      } else if (lastIndex == 6 &&
          stageAndValueModelsOfCurrentTask[6]!.length > 1) {
        final List<String?> reviewerIds = stageAndValueModelsOfCurrentTask[6]!
            .values
            .toList()[stageAndValueModelsOfCurrentTask[6]!.length - 2]
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

  String? lastActivityAndStatusDate(
    TaskModel taskModel, {
    bool isStatus = false,
  }) {
    final List<Map<StageModel, List<ValueModel?>>?> details =
        getStagesAndValueModelsByTask(taskModel);

    if (details.isEmpty) return null;
    final List<ValueModel?> valueModelsOfLastStage =
        details[lastIndex]![lastTaskStage]!;

    if (valueModelsOfLastStage.isEmpty)
      return lastTaskStage.creationDateTime.toDMYhm();
    List<DateTime> assignedDateTimes = valueModelsOfLastStage
        .map<DateTime>((e) => e!.assignedDateTime)
        .toList();
    DateTime maxAssignedDateTime = assignedDateTimes.reduce(
      (a, b) => a.isAfter(b) ? a : b,
    );
    DateTime minAssignedDateTime = assignedDateTimes.reduce(
      (a, b) => a.isAfter(b) ? b : a,
    );
    DateTime maxSubmitDateTime = valueModelsOfLastStage
        .map<DateTime>((e) => e!.submitDateTime ?? DateTime(0))
        .reduce((a, b) => a.isAfter(b) ? a : b);
    return isStatus
        ? minAssignedDateTime.toDMYhm()
        : [maxAssignedDateTime, maxSubmitDateTime]
            .reduce((a, b) => a.isAfter(b) ? a : b)
            .toDMYhm();
  }

  bool isCoordinatorFormVisible(ExpantionPanelItemModel item) =>
      currentTask == null ||
              lastIndex != item.index ||
              !staffController.isCoordinator ||
              currentTask!.holdReason != null ||
              (item.index == 0 && !taskController.checkFirstTask(currentTask!))
          ? false
          : true;

  String phaseInitialValue(DrawingModel drawingModel) {
    final List<ValueModel?> listValueModel = stageAndValueModelsOfCurrentTask
            .isEmpty
        ? []
        : stageController.stageAndValueModelsOfCurrentTask.first!.values.first;

    return listValueModel.isEmpty
        ? ' '
        : '${listValueModel.first!.phase ?? ""}';
  }
}
