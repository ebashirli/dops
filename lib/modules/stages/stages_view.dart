import 'package:dops/constants/stages_details.dart';
import 'package:dops/modules/stages/stages_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StagesView extends StatefulWidget {
  @override
  State<StagesView> createState() => _StagesViewState();
}

class _StagesViewState extends State<StagesView> {
  final List<Item> _data = generateItems(stageNames);
  final controller = Get.find<StagesController>();
  final taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(200, 20, 200, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: controller.buildEdit(
                    id:
                        taskController.openedTaskId.value),
              ),
              Container(child: _buildPanel()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere((Item currentItem) => item == currentItem);
                });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(List<String> stageNames) {
  return List<Item>.generate(stageNames.length, (int index) {
    return Item(
      headerValue: stageNames[index],
      expandedValue: 'This is item ${stageNames[index]}',
    );
  });
}
