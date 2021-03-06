import 'package:dops/components/custom_widgets.dart';
import 'package:dops/modules/widgets/stages/stage_widgets.dart';
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
      child: Column(
        children: [
          Container(child: _buildPanel()),
          SizedBox(height: 500),
        ],
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
                title: Center(
                    child: CustomText(
              item.headerValue,
              selectable: true,
            )));
          },
          body: ExpansionPanelBody(item: item),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
