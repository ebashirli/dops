import 'package:dops/components/custom_widgets.dart';
import 'package:flutter/material.dart';

class FlexTextWidget extends StatelessWidget {
  final int flex;
  final String labelText;
  final String? initialValue;
  final TextEditingController? controller;

  const FlexTextWidget({
    Key? key,
    this.flex = 1,
    this.controller,
    required this.labelText,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: CustomTextFormField(
        initialValue: initialValue,
        readOnly: true,
        sizeBoxHeight: 0,
        labelText: labelText,
        controller: controller,
        maxLines: 1,
      ),
    );
  }
}
