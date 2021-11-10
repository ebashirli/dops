import 'package:flutter/material.dart';

class CustomStringTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final double? width;

  const CustomStringTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            controller: controller,
            validator: (value) {
              // return validateName(value!);
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
