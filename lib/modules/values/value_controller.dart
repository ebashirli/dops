import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:dops/modules/values/values_repository.dart';
import 'package:get/get.dart';
import 'package:quick_notify/quick_notify.dart';
import '../../components/custom_widgets.dart';

class ValueController extends GetxService {
  final _repo = Get.find<ValueRepository>();
  static ValueController instance = Get.find();

  RxList<ValueModel?> _documents = RxList<ValueModel?>([]);

  final RxBool containsHold = false.obs;

  RxBool _loading = true.obs;
  bool get loading => _loading.value;

  List<ValueModel?> get documents => _documents;

  addNew({required ValueModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repo.add(model);
    CustomFullScreenDialog.cancelDialog();
  }

  addValues({required Map<String, dynamic> map, required String id}) async {
    CustomFullScreenDialog.showDialog();
    await _repo.updateFileds(map, id);
    CustomFullScreenDialog.cancelDialog();
  }

  @override
  void onInit() {
    super.onInit();

    _documents.bindStream(_repo.getAllDocumentsAsStream());
    _documents.listen((List<ValueModel?> valueModelList) {
      if (valueModelList.isNotEmpty) _loading.value = false;

      Set<String?> valueModelIdsAssignedCU =
          loading ? {} : valueModelsAssignedCU.map((e) => e!.id).toSet();

      List a = cacheManager.getValueModelIds();

      Set<String?> oldValueModelIdsAssignedCU =
          a.isNotEmpty ? a.map((e) => e.toString()).toSet() : {};

      valueModelIdsAssignedCU
          .difference(oldValueModelIdsAssignedCU)
          .forEach((e) {
        if (e != null) {
          getNotificationContent(e);
        }
      });

      cacheManager.saveValueModelIds(valueModelIdsAssignedCU.toList());
      // cacheManager.removevalueModelIds();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  ValueModel? getById(String id) =>
      documents.firstWhere((e) => e == null ? false : e.id == id);

  List<ValueModel?> valueModelsByStageId(String stageId) => documents.isNotEmpty
      ? documents.where((e) => e!.stageId == stageId).toList()
      : [];

  List<ValueModel?> get valueModelsAssignedCU {
    return loading || documents.isEmpty
        ? []
        : documents
            .where(
              (e) =>
                  e!.submitDateTime == null &&
                  e.employeeId == staffController.currentUserId,
            )
            .toList();
  }

  Set<String?> get parentIds => loading || documents.isEmpty
      ? {}
      : documents.map((e) => e!.stageId).toSet();

  bool checkIfParentIdsContains(String id) => !parentIds.contains(id);

  Set<String?> get stageIdsOfVmsAssignedCurrentUser {
    return valueModelsAssignedCU.isEmpty
        ? {}
        : valueModelsAssignedCU.map((e) => e!.stageId).toSet();
  }

  bool checkIfStageModelAssignedCUById(String id) =>
      stageIdsOfVmsAssignedCurrentUser.contains(id);

  void getNotificationContent(String id) {
    ValueModel? valueModel = getById(id);
    if (valueModel != null) {
      StageModel? stageModel = stageController.getById(valueModel.stageId);
      if (stageModel != null) {
        int index = stageModel.index;
        String job = stageDetailsList[index]['staff job'];

        QuickNotify.notify(
          title: stageDetailsList[index]['name'],
          content: "You are assigned as $job.",
        );
      }
    }
  }
}
