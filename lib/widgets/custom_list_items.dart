import 'package:dops/controllers/dropdown_source_lists_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListItems extends GetView<DropdownSourceListsController> {
  final List lst;
  final String lstName;
  final GlobalKey formKey;
  final TextEditingController newItemController;

  const CustomListItems({
    Key? key,
    required this.lst,
    required this.lstName,
    required this.formKey,
    required this.newItemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 190,
        margin: EdgeInsets.only(
          bottom: 80,
          top: 50,
          left: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lstName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Text(
                      lst.length.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: lst.length,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text('${lst[index]}'),
                    ],
                  ),
                ),
              ),
            ),
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: newItemController,
                      decoration: InputDecoration(
                        hintText: "New ${lstName.toLowerCase()}",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        return controller.validateName(value!);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        controller.saveUpdateDropdownSourceList(
                          lstName,
                          1, // itemIndex,
                          newItemController.text,
                          1,
                        );
                      },
                      child: Text('Add'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
