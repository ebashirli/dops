import 'package:flutter/material.dart';

class CustomStringTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomStringTextField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        controller: controller,
        validator: (value) {
          // return validateName(value!);
        });
  }
}
