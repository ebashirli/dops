import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/list/lists_model.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListsFormWidget extends StatelessWidget {
  const ListsFormWidget({
    Key? key,
    required this.map,
  }) : super(key: key);
  final Map<String, dynamic> map;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .3,
      child: Column(
        children: <Widget>[
          DropdownSearch<String>(
            showSearchBox: true,
            mode: Mode.MENU,
            items: listNames,
            onChanged: (value) => listsController.choosenList.value = value!,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: listsController.textController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(left: 8, bottom: 4),
              alignLabelWithHint: true,
              suffix: IconButton(
                  splashRadius: 16,
                  onPressed: listsController.addNewItem,
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
              children: listsController.newAddedList
                  .asMap()
                  .entries
                  .map(
                    (element) => listsController.chipContainer(
                      element.value,
                      element.key,
                    ),
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
                  onPressed: listsController.newAddedList.isNotEmpty
                      ? () async {
                          // if (textController.text.trim().isNotEmpty && choosenList.isNotEmpty)
                          listsController.updateModel(ListsModel.fromMap(map));
                          listsController.newAddedList.value = [];
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
    );
  }
}
