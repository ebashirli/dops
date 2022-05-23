import 'package:dops/constants/constant.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:dops/modules/values/values_repository.dart';
import 'package:dops/services/file_api/file_api.dart';
import 'package:get/get.dart';
import '../../components/custom_widgets.dart';

class ValueController extends GetxService {
  final _repo = Get.find<ValueRepository>();
  static ValueController instance = Get.find();

  RxList<ValueModel?> _documents = RxList<ValueModel?>([]);

  final RxBool containsHold = false.obs;

  RxBool _loading = true.obs;
  bool get loading => _loading.value;

  List<ValueModel?> get documents => _documents;

  add({required ValueModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repo.add(model);
    sendNotificationEmail(valueModel: model);
    CustomFullScreenDialog.cancelDialog();
  }

  update({required Map<String, dynamic> map, required String id}) async {
    CustomFullScreenDialog.showDialog();
    await _repo.updateFileds(map, id);
    if (map.containsKey('isHidden') && map['isHidden'])
      sendNotificationEmail(valueModel: getById(id), isUnassign: true);
    CustomFullScreenDialog.cancelDialog();
  }

  @override
  void onInit() {
    super.onInit();

    _documents.bindStream(_repo.getAllDocumentsAsStream());
    _documents.listen((List<ValueModel?> valueModelList) {
      if (valueModelList.isNotEmpty) _loading.value = false;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  ValueModel? getById(String? id) => documents.firstWhere((e) => e?.id == id);

  List<ValueModel?> valueModelsByStageId(String stageId) => documents.isNotEmpty
      ? documents.where((e) => e!.stageId == stageId).toList()
      : [];

  List<ValueModel?> get valueModelsAssignedCU =>
      staffController.currentUserId == null
          ? []
          : valueModelsByEmployeeId(staffController.currentUserId!);

  List<ValueModel?> valueModelsByEmployeeId(String id) {
    return documents
        .where((e) => e?.submitDateTime == null && e?.employeeId == id)
        .toList();
  }

  List<String?> stageIdsByEmployeeId(String id) {
    return valueModelsByEmployeeId(id).map((e) => e?.stageId).toList();
  }

  Set<String?> get valueModelIdsAssignedCU =>
      loading ? {} : valueModelsAssignedCU.map((e) => e!.id).toSet();

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
}
