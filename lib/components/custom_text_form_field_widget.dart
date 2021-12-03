import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final double? width;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Icon? icon;
  final bool isNumber;
  final int? maxLines;

  const CustomTextFormField({
    Key? key,
    this.controller,
    required this.labelText,
    this.width,
    this.validator,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType,
    this.icon,
    this.maxLines,
    this.isNumber = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: isNumber
                ? TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: labelText,
                      contentPadding: EdgeInsets.all(10),
                      icon: icon,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : TextFormField(
                    keyboardType: TextInputType.multiline,
                    initialValue: initialValue,
                    readOnly: readOnly,
                    maxLines: maxLines,
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
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
