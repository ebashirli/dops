import 'package:flutter/material.dart';

class CustomStringTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final double? width;
  final String? Function(String?)? validator;

  const CustomStringTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.width,
    this.validator,
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
            validator: validator,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
