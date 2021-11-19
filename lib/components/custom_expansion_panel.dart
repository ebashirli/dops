import 'package:flutter/material.dart';

ExpansionPanel CustomExpansionPanel({
  required bool isExpanded,
  required String title,
  required Widget body,
}) {
  return ExpansionPanel(
    headerBuilder: (BuildContext context, bool isExpanded) {
      return ListTile(title: Text(title));
    },
    body: body,
    isExpanded: isExpanded,
  );
}
