import 'dart:math';

import 'package:dops/constants/constant.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/stages/stage_repository.dart';
import 'package:dops/modules/stages/widgets/build_edit_form_widget.dart';
import 'package:dops/modules/stages/widgets/build_expansion_panel_list_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class StageController extends GetxService {
  final _repository = Get.find<StageRepository>();
  static StageController instance = Get.find();

  RxList<StageModel> _documents = RxList<StageModel>([]);
  List<StageModel> get documents => _documents;

  int get maxIndex => documents
      .where(
          (StageModel stageModel) => stageModel.taskId == Get.parameters['id'])
      .map((StageModel stageModel) => stageModel.index)
      .reduce(max);

  bool get isCoordinator =>
      staffController.documents.indexWhere((staff) =>
          staff.id == auth.currentUser!.uid &&
          staff.systemDesignation == 'Coordinator') !=
      -1;
  List<StageModel> get taskStages {
    List<StageModel> _taskStages = documents
        .where((StageModel stageModel) =>
            stageModel.taskId == Get.parameters['id'])
        .toList();
    _taskStages
        .sort((a, b) => a.creationDateTime.compareTo(b.creationDateTime));
    return _taskStages;
  }

  List<StageModel> getStageModelsByIndex(int index) {
    List<StageModel> _taskStages = documents
        .where((StageModel stageModel) =>
            stageModel.taskId == Get.parameters['id'])
        .toList();
    _taskStages
        .sort((a, b) => a.creationDateTime.compareTo(b.creationDateTime));
    return _taskStages;
  }

  @override
  void onInit() {
    _documents.bindStream(_repository.getAllDocumentsAsStream());
    super.onInit();
  }

  final RxString pressedTaskId = ''.obs;

  Widget buildEditForm() => BuildEditFormWidget();
  Widget buildPanel() {
    return BuildExpansionPanelListWidget();
  }

  void addNew({required StageModel model}) {}
}
