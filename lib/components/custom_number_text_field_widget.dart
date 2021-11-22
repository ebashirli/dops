import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberTextField extends StatelessWidget {
  const CustomNumberTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.width,
  }) : super(key: key);

  final String labelText;
  final TextEditingController controller;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: InputDecoration(
              labelText: labelText,
              icon: Icon(Icons.phone_iphone),
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
