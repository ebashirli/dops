import 'package:dops/modules/list/widgets/lists_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import '../../enum.dart';
import 'lists_model.dart';
import 'lists_repository.dart';
import 'package:get/get.dart';

class ListsController extends GetxService {
  ListsRepository _repo = Get.find<ListsRepository>();
  static ListsController instance = Get.find();

  Rx<ListsModel> _documents = ListsModel().obs;
  ListsModel get document => _documents.value;

  late Map<String, dynamic> map;

  RxBool loading = true.obs;

  Rx<States> state = States.Loading.obs;
  RxString choosenList = 'Companies'.obs;
  final textController = TextEditingController();
  RxList<Map<String, dynamic>> newAddedList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    map = document.toMap();
    _documents.bindStream(_repo.getModelAsStream());
    _documents.listen((ListsModel? listsModel) {
      if (listsModel == null) loading.value = false;
      map = listsModel!.toMap();
    });

    // _repo.chunckUpload();
  }

  Future<void> updateModel(ListsModel model) async {
    await _repo.updateListModel(model);
  }

  addNewItem() {
    map = document.toMap();
    map[ReCase(choosenList.value).camelCase] =
        map[ReCase(choosenList.value).camelCase]..add(textController.text);
    newAddedList.add({choosenList.value: textController.text});
    textController.clear();
  }

  deleteItem(element, index) {
    map[ReCase(element.keys.first).camelCase] =
        map[ReCase(element.keys.first).camelCase]..remove(element.values.first);
    newAddedList.removeAt(index);
  }

  buildAddForm() {
    Get.defaultDialog(
      radius: 12,
      titlePadding: EdgeInsets.only(top: 40, bottom: 20),
      title: 'Add New List Item',
      contentPadding: EdgeInsets.only(left: 12, right: 12),
      content: ListsFormWidget(map: map),
    );
  }

  Container chipContainer(Map<String, dynamic> element, index) {
    return Container(
      // height: 50,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: EdgeInsets.all(2),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                element.keys.first.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(element.values.first.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  splashRadius: 16,
                  onPressed: () {
                    deleteItem(element, index);
                  },
                  icon: Icon(Icons.close, size: 16, color: Colors.red)))
        ],
      ),
    );
  }
}
