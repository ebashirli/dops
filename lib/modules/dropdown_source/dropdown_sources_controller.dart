import 'package:dops/constants/lists.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import '../../enum.dart';
import 'dropdown_sources_model.dart';
import 'dropdown_sources_repository.dart';
import 'package:get/get.dart';

class DropdownSourcesController extends GetxController {
  DropwdownSourcesRepository _repository =
      Get.find<DropwdownSourcesRepository>();
  static DropdownSourcesController instance = Get.find();
  late Rx<DropdownSourcesModel> document;
  Rx<States> state = States.Loading.obs;
  RxString choosenList = 'Companies'.obs;
  final textController = TextEditingController();
  late Map<String, dynamic> map;
  RxList<Map<String, dynamic>> newAddedList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    document = DropdownSourcesModel().obs;
    map = document.value.toMap();
    document.bindStream(_repository.getModelAsStream());
  }

  Future<void> updateModel(DropdownSourcesModel model) async {
    await _repository.updateDropdownSourcesModel(model);
  }

  addNewItem() {
    map = document.value.toMap();
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

  buildAddEdit() {
    Get.defaultDialog(
        radius: 12,
        titlePadding: EdgeInsets.only(top: 40, bottom: 20),
        title: 'Add New List Item',
        contentPadding: EdgeInsets.only(left: 12, right: 12),
        content: Container(
          width: 500,
          child: Column(
            children: <Widget>[
              DropdownSearch<String>(
                showSearchBox: true,
                mode: Mode.MENU,
                items: listNames,
                onChanged: (value) => choosenList.value = value!,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(left: 8, bottom: 4),
                  alignLabelWithHint: true,
                  suffix: IconButton(
                      splashRadius: 16,
                      onPressed: addNewItem,
                      icon: Icon(Icons.add)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Wrap(
                  alignment: WrapAlignment.start,
                  children: newAddedList
                      .asMap()
                      .entries
                      .map(
                        (element) => chipContainer(element.value, element.key),
                      )
                      .toList(),
                );
              }),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Cancel')),
                  SizedBox(width: 10),
                  Obx(() {
                    return ElevatedButton(
                      onPressed: newAddedList.isNotEmpty
                          ? () async {
                              // if (textController.text.trim().isNotEmpty && choosenList.isNotEmpty)
                              updateModel(DropdownSourcesModel.fromMap(map));
                              newAddedList.value = [];
                              Get.back();
                            }
                          : null,
                      child: const Text('Done'),
                    );
                  }),
                ],
              ),
            ],
          ),
        ));
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
