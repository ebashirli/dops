import 'package:cloud_firestore/cloud_firestore.dart';
import '../../enum.dart';
import 'dropdown_sources_model.dart';
import 'dropdown_sources_repository.dart';
import 'package:get/get.dart';

class DropdownSourcesController extends GetxController {
  DropwdownSourcesRepository _repository = Get.find<DropwdownSourcesRepository>();
  Rx<DropdownSourcesModel> document = DropdownSourcesModel().obs;

  @override
  void onInit() {
    super.onInit();
    document.bindStream(_repository.getModelAsStream());
    print(document.value);
  }

  updateModel(DropdownSourcesModel model) {
    _repository.updateDropdownSourcesModel(model);
  }
}
