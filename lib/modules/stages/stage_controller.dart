import 'dart:math';
import 'package:collection/collection.dart';
import 'package:dops/modules/stages/widgets/worker_forms/worker_forms.dart';

import 'package:dops/modules/values/value_model.dart';

import 'package:dops/components/custom_widgets.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/widgets/value_table_view_widget.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/stages/widgets/expantion_panel_item_model.dart';
import 'package:dops/modules/stages/widgets/coordinator_form.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:dops/services/file_api/file_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:dops/constants/constant.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/stages/stage_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class StageController extends GetxService {
  final _repo = Get.find<StageRepository>();
  static StageController instance = Get.find();

  RxList<StageModel?> _documents = RxList<StageModel>([]);
  List<StageModel?> get documents => _documents;
  RxBool _loading = true.obs;
  bool get loading => _loading.value;
  late List<TextEditingController> textEditingControllers;
  late TextEditingController noteController;
  late TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();

    _documents.bindStream(_repo.getAllDocumentsAsStream());
    _documents.listen((List<StageModel?> stageModelList) {
      if (stageModelList.isNotEmpty) _loading.value = false;
    });

    textEditingControllers =
        List<TextEditingController>.generate(5, (_) => TextEditingController());
    noteController = TextEditingController();
    emailController = TextEditingController();
  }

  String? get currentTaskModelId => Get.parameters['id'];

  TaskModel? get currentTaskModel =>
      taskController.getById(currentTaskModelId!);

  DrawingModel? get currentDrawingModel => currentTaskModel?.drawingModel;

  List<StageModel?> get stagesOfCurrentTask {
    List<StageModel?> _stagesOfCurrentTask = (documents.isNotEmpty ||
                currentTaskModel != null) ||
            !loading
        ? documents
            .where((stageModel) => stageModel!.taskId == currentTaskModel!.id)
            .toList()
        : [];
    if (_stagesOfCurrentTask.isNotEmpty)
      _stagesOfCurrentTask
          .sort((a, b) => a!.creationDateTime.compareTo(b!.creationDateTime));
    return _stagesOfCurrentTask;
  }

  StageModel? getById(String id) {
    return loading || documents.isEmpty
        ? null
        : documents.singleWhereOrNull((e) => e!.id == id);
  }

  List<StageModel?> getByIdsAndIndex({
    required List<String?> ids,
    required int index,
  }) {
    return documents
        .where((e) => e?.index == index)
        .where((e) => ids.contains(e?.id))
        .toList();
  }

  List<StageModel?> stageModelsByEmployeeId({
    required String employeeId,
    required int index,
  }) {
    List<String?> stageIds = valueController.stageIdsByEmployeeId(employeeId);
    return getByIdsAndIndex(
      ids: stageIds,
      index: index,
    );
  }

  List<String?> taskIdsByEmployeeId({
    required String employeeId,
    required int index,
  }) {
    return stageModelsByEmployeeId(
      employeeId: employeeId,
      index: index,
    ).map((e) => e?.taskId).toList();
  }

  void fillEditingControllers() {
    noteController.text = lastTaskStage.note ?? '';
    emailController.text = 'elvin.bashirli@azfen.com';
  }

  int get maxIndex => stageAndValueModelsOfCurrentTask.length;

  int get indexOfLast =>
      stagesOfCurrentTask.isEmpty ? 0 : stagesOfCurrentTask.last!.index;

  RxList<StaffModel?> assigningStaffModels = RxList([]);
  List<StaffModel?> get assignedStaffModels =>
      stageAndValueModelsOfCurrentTask[indexOfLast]!
          .values
          .last
          .map<StaffModel?>((e) => staffController.documents
              .singleWhereOrNull((element) => element.id == e?.employeeId))
          .toList();

  List<Map<StageModel, List<ValueModel?>>?>
      get stageAndValueModelsOfCurrentTask {
    return currentTaskModel != null
        ? getStagesAndValueModelsByTask(currentTaskModel!)
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
      loading || taskModel == null
          ? []
          : documents.where((e) => e!.taskId == taskModel.id).toList();

  StageModel? getFirstStageOfFirstTask(TaskModel? taskModel) =>
      (stageController.loading || taskModel == null)
          ? null
          : documents.firstWhereOrNull(
              (e) => e!.index == 0 && e.taskId == taskModel.id);

  List<Map<StageModel, List<ValueModel?>>?> getStagesAndValueModelsByTask(
      TaskModel? taskModel) {
    if (documents.isEmpty || taskController.loading || taskModel == null)
      return [];

    List<StageModel?> stagesOfTask = getStagesOfTask(taskModel);
    if (stagesOfTask.isEmpty) return [];

    bool isFirstTask = taskController.checkIfIsFirstTask(taskModel);

    ValueModel? firstValueModelOfFirstTask = null;

    if (!isFirstTask) {
      TaskModel? firstTaskModel =
          taskController.loading || taskController.documents.isEmpty
              ? null
              : taskController.documents
                  .firstWhereOrNull((e) => e!.parentId == taskModel.parentId);
      StageModel? firstStageModel =
          firstTaskModel == null || documents.isEmpty || loading
              ? null
              : documents.firstWhereOrNull(
                  (e) => e!.taskId == firstTaskModel.id && e.index == 0);
      if (valueController.loading ||
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
    List<ValueModel?> valueModels = valueController.loading ||
            valueController.documents.isEmpty ||
            stageModel == null
        ? []
        : valueController.documents
            .where((e) => e!.stageId == stageModel.id)
            .toList();

    return valueModels;
  }

  bool get coordinatorAssigns =>
      stageAndValueModelsOfCurrentTask[indexOfLast]!.values.last.isEmpty;

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
      stageAndValueModelsOfCurrentTask[indexOfLast]!.keys.last;

  List<ValueModel?> get lastTaskStageValues =>
      stageAndValueModelsOfCurrentTask[indexOfLast]!.values.last;

  ValueModel? get valueModelAssignedCurrentUser {
    List<ValueModel?> valueModelList = lastTaskStageValues
        .where(
            (element) => element!.employeeId == staffController.currentUserId)
        .toList();
    return valueModelList.isNotEmpty ? valueModelList[0] : null;
  }

  String get labelText => stageDetailsList[indexOfLast]['staff job'];

  bool isWorkerFormVisible(ExpantionPanelItemModel item) {
    return (item.index == 7 &&
            stageAndValueModelsOfCurrentTask[7]!.values.first.isNotEmpty)
        ? true
        : valueModelAssignedCurrentUser == null
            ? false
            : stageController.currentTaskModel!.holdReason != null
                ? false
                : item.index != stageController.indexOfLast
                    ? false
                    : valueModelAssignedCurrentUser!.submitDateTime == null;
  }

  List<String> get specialFieldNames =>
      stageDetailsList[indexOfLast]['form fields'];

  UploadingFileType files = UploadingFileType();

  final RxBool commentStatus = false.obs;

  final RxInt issueGroup = 0.obs;

  List<ExpantionPanelItemModel> generateItems() {
    return List<ExpantionPanelItemModel>.generate(
      maxIndex,
      (int index) {
        ValueModel? valueModel = stageAndValueModelsOfCurrentTask.length > 7
            ? stageAndValueModelsOfCurrentTask[7]?.values.first.first
            : null;
        final Widget workerForm = index == 7
            ? valueModel == null
                ? SizedBox()
                : FilingStageWorkerForm(valueModel: valueModel)
            : CommonWorkerForm(index: index);

        final Widget coordinatorForm = CoordinatorForm(index: index);

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

  Future<String> add({required StageModel model}) async {
    CustomFullScreenDialog.showDialog();
    model.creationDateTime = DateTime.now();
    await _repo.add(model).then((value) => model.id = value);
    sendNotificationEmail(stageModel: model);
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
              cacheManager.getStaff!.initial,
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

  update({required Map<String, dynamic> map, required String id}) async {
    CustomFullScreenDialog.showDialog();
    await _repo.updateFileds(map, id);
    CustomFullScreenDialog.cancelDialog();
  }

  void onAssignOrUpdatePressed() async {
    Set<String?> assignedEmployeeIds = {};
    Set<String> assigningEmployeeIds = {};
    if (lastTaskStage.index != 9) {
      if (lastTaskStageValues.isNotEmpty) {
        assignedEmployeeIds = lastTaskStageValues
            .map((ValueModel? valueModel) => valueModel!.employeeId)
            .toSet();
      }
      assigningEmployeeIds = assigningStaffModels.map((e) => e!.id!).toSet();
    } else {
      if (staffController.currentUserId == null) return;
      assigningEmployeeIds = {staffController.currentUserId!};
      sendEmail(
        drawingNo:
            '${currentDrawingModel!.drawingNumber}-${currentTaskModel!.revisionMark}',
        email: emailController.text,
        note: noteController.text,
        filingId: stageAndValueModelsOfCurrentTask[7]!.values.last.last!.id!,
        nestingIds: stageAndValueModelsOfCurrentTask[8]!
            .values
            .last
            .map((e) => e!.id)
            .toList(),
      );
    }
    ValueModel vm = await ValueModel(
      stageId: lastTaskStage.id!,
      employeeId: '',
      assignedBy: auth.currentUser!.uid,
      assignedDateTime: DateTime.now(),
    );

    if (assignedEmployeeIds.isEmpty) {
      assigningEmployeeIds.forEach((employeeId) async {
        vm.employeeId = employeeId;
        valueController.add(model: vm);
      });
    } else {
      assignedEmployeeIds.difference(assigningEmployeeIds).forEach(
        (employeeId) {
          ValueModel? vm = lastTaskStageValues.singleWhere(
              (ValueModel? valueModel) => valueModel!.employeeId == employeeId);

          String? id = vm?.id;
          if (id != null)
            valueController.update(map: {'isHidden': true}, id: id);
        },
      );
      assigningEmployeeIds
          .difference(assignedEmployeeIds)
          .forEach((employeeId) => valueController.add(model: vm));
    }

    update(
      map: {
        'note': noteController.text,
        if (lastTaskStage.index == 9) 'email': emailController.text,
      },
      id: lastTaskStage.id!,
    );

    assigningStaffModels.value = [];
  }

  Future<void> onSubmitPressed() async {
    Map<String, dynamic> map = {};

    for (var i = 0; i < specialFieldNames.length; i++) {
      map[specialFieldNames[i].toLowerCase()] =
          ['HOLD', 'transmittal'].contains(specialFieldNames[i])
              ? textEditingControllers[i].text == ""
                  ? null
                  : textEditingControllers[i].text
              : int.parse(textEditingControllers[i].text);
    }

    map['isCommented'] = commentStatus.value;
    map['note'] = textEditingControllers.last.text == ''
        ? null
        : textEditingControllers.last.text;
    map['submitDateTime'] = DateTime.now();

    if (lastTaskStage.index == 7) {
      filingFileTypes.forEach((e) =>
          map[e.dbName] = e.files.map((PlatformFile? file) => file?.name));
    } else if (stageDetailsList[lastTaskStage.index]['file names'] != null) {
      map['fileNames'] = files.files.map((e) => e?.name).toList();
    }

    if (valueModelAssignedCurrentUser == null) return;
    String? id = valueModelAssignedCurrentUser!.id;

    if (id == null) return;

    valueController.update(map: map, id: id);

    List<UploadingFileType?> uploadingFilesList =
        lastTaskStage.index != 7 ? filingFileTypes : [files];

    if (uploadingFilesList.isEmpty) return null;

    uploadingFilesList.forEach((UploadingFileType? filesType) async =>
        await uploadFiles(filesType, id));

    if (isLastSubmit && indexOfLast != 9) {
      bool anyComment = await valueController.documents.any(
            (valueModel) =>
                valueModel!.stageId == lastTaskStage.id &&
                valueModel.isCommented,
          ) ||
          commentStatus.value;

      StageModel stage = StageModel(
        taskId: lastTaskStage.taskId,
        index: anyComment ? 4 : indexOfLast + 1,
        checkerCommentCounter: indexOfLast == 4
            ? lastTaskStage.checkerCommentCounter
            : (commentStatus.value && indexOfLast == 5)
                ? lastTaskStage.checkerCommentCounter + 1
                : 0,
        reviewerCommentCounter: [4, 5].contains(indexOfLast)
            ? lastTaskStage.reviewerCommentCounter
            : (commentStatus.value && indexOfLast == 6)
                ? lastTaskStage.reviewerCommentCounter + 1
                : 0,
        creationDateTime: DateTime.now(),
      );

      String nextStageId = await add(model: stage);

      final ValueModel valueModel = ValueModel(
        stageId: nextStageId,
        employeeId: '',
        assignedBy: 'System',
        assignedDateTime: DateTime.now(),
      );

      if (indexOfLast == 4 ||
          ((indexOfLast == 6 || indexOfLast == 7) && anyComment)) {
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

        [...designerIds, ...drafterIds].toSet().forEach((empId) =>
            valueController.add(model: valueModel..employeeId = empId));
      } else if (indexOfLast == 5) {
        final List<String?> checkerIds = stageAndValueModelsOfCurrentTask[3]!
            .values
            .last
            .map((e) => e!.employeeId)
            .toList();
        checkerIds.forEach((checkerId) {
          valueController.add(model: valueModel..employeeId = checkerId);
        });
      } else if (indexOfLast == 6 &&
          stageAndValueModelsOfCurrentTask[6]!.length > 1) {
        final List<String?> reviewerIds = stageAndValueModelsOfCurrentTask[6]!
            .values
            .toList()[stageAndValueModelsOfCurrentTask[6]!.length - 2]
            .map((e) => e!.employeeId)
            .toList();
        reviewerIds.forEach((reviewerId) {
          valueController.add(model: valueModel..employeeId = reviewerId);
        });
      }
    }
    textEditingControllers.forEach((e) => e.clear());
    files.files = [];
    commentStatus.value = false;
  }

  bool containsHoldFun(TaskModel taskModel) {
    if (taskModel.id == null) {
      return false;
    } else if (getStagesAndValueModelsByTask(taskModel).length < 8) {
      return false;
    } else {
      return valueController.loading
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

  void onFileButtonPressed({UploadingFileType? uploadingFiles}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: uploadingFiles?.allowedExtensions != null
          ? FileType.custom
          : FileType.any,
      allowMultiple: uploadingFiles?.allowMultiple ?? false,
      allowedExtensions: uploadingFiles?.allowedExtensions,
    );
    if (result != null) files.files = result.files;
  }

  String? lastActivityAndStatusDate(TaskModel taskModel,
      {bool isStatus = false}) {
    final List<Map<StageModel, List<ValueModel?>>?> details =
        getStagesAndValueModelsByTask(taskModel);

    if (details.isEmpty) return null;
    final List<ValueModel?> valueModelsOfLastStage =
        details[indexOfLast]![lastTaskStage]!;

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

  bool isCoordinatorFormVisible(ExpantionPanelItemModel item) {
    return !(currentTaskModel == null ||
        indexOfLast != item.index ||
        !staffController.isCoordinator ||
        currentTaskModel!.holdReason != null ||
        (item.index == 9 &&
            stageAndValueModelsOfCurrentTask.isNotEmpty &&
            stageAndValueModelsOfCurrentTask.last!.values.first.isNotEmpty) ||
        (item.index == 0 &&
            !taskController.checkIfIsFirstTask(currentTaskModel!)));
  }

  int? get phaseInitialValue {
    return stageAndValueModelsOfCurrentTask.isEmpty
        ? null
        : stageAndValueModelsOfCurrentTask.first!.values.first.isEmpty
            ? null
            : stageAndValueModelsOfCurrentTask.first!.values.first.first!.phase;
  }

  void copyToClipBoard(int index) {
    Clipboard.setData(
      ClipboardData(
        text: '$basePath\\',
      ),
    );
  }

  download(int index) {
    if (stagesOfCurrentTask.isEmpty) return;

    StageModel? stageModel =
        stagesOfCurrentTask.lastWhereOrNull((e) => e!.index == index);

    if (stageModel == null) return;

    int indexOfstageModel = stagesOfCurrentTask.indexOf(stageModel);

    if (indexOfstageModel == -1) return;

    StageModel? previousStageModel = stagesOfCurrentTask[indexOfstageModel - 1];

    if (previousStageModel == null) return;
    List<ValueModel?>? valueModelList = stageAndValueModelsOfCurrentTask[
        previousStageModel.index]![previousStageModel];

    if (valueModelList == null || valueModelList.isEmpty) return;

    List<String?> ids = valueModelList.map((e) => e!.id).toList();

    if (ids.isEmpty) return;

    return dowloadFiles(ids: ids);
  }

  List<StageModel?> get stageModelsAssignedCU {
    return loading || documents.isEmpty
        ? []
        : documents
            .where(
                (e) => valueController.checkIfStageModelAssignedCUById(e!.id!))
            .toList();
  }

  List<StageModel?> get stageModelsNotAssignedYet {
    return loading || documents.isEmpty
        ? []
        : documents.where((e) {
            return e!.index != 0
                ? !valueController.checkIfStageModelAssignedCUById(e.id!)
                : getStagesAndValueModelsByTask(
                            taskController.getById(e.taskId))
                        .length <
                    1;
          }).toList();
  }

  Set<String?> get taskIdsAsignedCU {
    return stageModelsAssignedCU.isEmpty
        ? {}
        : stageModelsAssignedCU.map((e) => e!.taskId).toSet();
  }

  Set<String?> get taskIdsNotAsignedYet {
    return stageModelsNotAssignedYet.isEmpty
        ? {}
        : stageModelsNotAssignedYet.map((e) => e!.taskId).toSet();
  }

  List<StageModel?> get stageModelsWithoutValueModels {
    return loading || documents.isEmpty
        ? []
        : documents
            .where((e) => valueController.checkIfParentIdsContains(e!.id!))
            .toList();
  }

  String? getCoordinatorNoteByindex(int index) {
    return stageAndValueModelsOfCurrentTask.length <= index
        ? null
        : stageAndValueModelsOfCurrentTask[index]!.keys.last.note;
  }
}
