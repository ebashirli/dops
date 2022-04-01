import 'package:dops/modules/values/value_model.dart';
import 'package:dops/modules/values/values_repository.dart';
import 'package:get/get.dart';
import '../../components/custom_widgets.dart';

class ValueController extends GetxService {
  final _repository = Get.find<ValueRepository>();
  static ValueController instance = Get.find();

  RxList<ValueModel?> _documents = RxList<ValueModel?>([]);

  final RxBool containsHold = false.obs;

  RxBool loading = true.obs;

  List<ValueModel?> get documents => _documents;

  addNew({required ValueModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.add(model);
    CustomFullScreenDialog.cancelDialog();
  }

  addValues({required Map<String, dynamic> map, required String id}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addFields(map, id);
    CustomFullScreenDialog.cancelDialog();
  }

  @override
  void onInit() {
    super.onInit();

    _documents.bindStream(_repository.getAllDocumentsAsStream());
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
}
