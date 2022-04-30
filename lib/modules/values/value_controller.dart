import 'package:dops/constants/constant.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:dops/modules/values/values_repository.dart';
import 'package:get/get.dart';
import '../../components/custom_widgets.dart';

class ValueController extends GetxService {
  final _repo = Get.find<ValueRepository>();
  static ValueController instance = Get.find();

  RxList<ValueModel?> _documents = RxList<ValueModel?>([]);

  final RxBool containsHold = false.obs;

  RxBool loading = true.obs;

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
      if (valueModelList.isNotEmpty) loading.value = false;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  List<ValueModel?> valueModelsByStageId(String stageId) => documents.isNotEmpty
      ? documents.where((e) => e!.stageId == stageId).toList()
      : [];

  List<ValueModel?> get valueModelsAssignedCurrentUser {
    return loading.value || documents.isEmpty
        ? []
        : documents
            .where(
              (e) =>
                  e!.submitDateTime == null &&
                  e.employeeId == staffController.currentUserId,
            )
            .toList();
  }

  Set<String?> get parentIds => loading.value || documents.isEmpty
      ? {}
      : documents.map((e) => e!.stageId).toSet();

  bool checkIfParentIdsContains(String id) => !parentIds.contains(id);

  Set<String?> get stageIdsOfVmsAssignedCurrentUser {
    return valueModelsAssignedCurrentUser.isEmpty
        ? {}
        : valueModelsAssignedCurrentUser.map((e) => e!.stageId).toSet();
  }

  bool checkIfStageModelAssignedCUById(String id) =>
      stageIdsOfVmsAssignedCurrentUser.contains(id);
}
