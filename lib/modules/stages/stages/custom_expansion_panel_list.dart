import 'package:dops/modules/stages/stages/expantion_panel_item_model.dart';
import 'package:dops/modules/stages/stages/stage/expansion_panel_body.dart';
import 'package:flutter/material.dart';

class CustomExpansionPanelList extends StatefulWidget {
  CustomExpansionPanelList({Key? key, required this.data}) : super(key: key);
  final List<ExpantionPanelItemModel> data;

  @override
  State<CustomExpansionPanelList> createState() =>
      _CustomExpansionPanelListState();
}

class _CustomExpansionPanelListState extends State<CustomExpansionPanelList> {
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
          widget.data[index].isExpanded = !isExpanded;
        });
      },
      children: widget.data.map<ExpansionPanel>((ExpantionPanelItemModel item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Center(child: Text(item.headerValue)),
            );
          },
          body: ExpansionPanelBody(item: item),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
