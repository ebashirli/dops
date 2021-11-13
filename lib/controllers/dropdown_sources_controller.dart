import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/enum.dart';
import 'package:dops/models/dropdown_sources_model.dart';
import 'package:dops/repositories/dropdown_sources_repository.dart';
import 'package:get/get.dart';

class DropdownSourcesController extends GetxController {
  DropwdownSourcesRepository _repository = Get.find<DropwdownSourcesRepository>();
  // Rx<DropdownSourcesModel> document = DropdownSourcesModel().obs;
  
  @override
  void onInit() {
    super.onInit();
    // document.bindStream(_repository.getModelAsStream());
  }


  updateModel(DropdownSourcesModel model) {
    _repository.updateDropdownSourcesModel(model);
  }
}
