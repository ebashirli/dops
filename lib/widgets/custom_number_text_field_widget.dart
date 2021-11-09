import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberTextField extends StatelessWidget {
  const CustomNumberTextField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(Icons.phone_iphone),
      ),
    );
  }
}
