import 'package:dops/constants/constant.dart';
import 'package:flutter/material.dart';

class ValuesListViewWidget extends StatefulWidget {
  const ValuesListViewWidget({Key? key}) : super(key: key);

  @override
  State<ValuesListViewWidget> createState() => _ValuesListViewWidgetState();
}

class _ValuesListViewWidgetState extends State<ValuesListViewWidget> {
  int index = stageController.lastIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stageController
              .getValueModelRows(index)['headers']![0]
              .map((e) => Text(e))
              .toList(),
        ),
        ...stageController
            .getValueModelRows(index)['rows']!
            .map((row) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: row.map<Widget>((cell) => Text(cell)).toList(),
                ))
            .toList()
      ],
    );
  }
}
