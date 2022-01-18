import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:flutter/material.dart';

import 'expansion_panel_body_widget.dart';

class BuildExpansionPanelListWidget extends StatefulWidget {
  const BuildExpansionPanelListWidget({
    Key? key,
  }) : super(key: key);
  final List<StageModel> taskStages = stageController.taskStages;

  @override
  State<BuildExpansionPanelListWidget> createState() =>
      _BuildExpansionPanelListWidgetState();
}

class _BuildExpansionPanelListWidgetState
    extends State<BuildExpansionPanelListWidget> {
  final List<Item> _data = generateItems(stageController.maxIndex);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
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
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: item.body,
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    required this.headerValue,
    required this.body,
    this.isExpanded = false,
  });

  final String headerValue;
  bool isExpanded;
  final Widget body;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: '${index + 1} | ${stageDetailsList[index]['name']}',
      body: ExpansionPanelBodyWidget(index: index),
    );
  });
}
