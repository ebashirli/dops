import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final double? width;
  final double? height;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Icon? icon;
  final bool isNumber;
  final bool obscureText;
  final int? maxLines;
  final FocusNode? focusNode;
  final Function(String?)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final double? sizeBoxHeight;
  final void Function(String)? onChanged;
  final double? contentPadding;
  final bool? enabled;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.labelText,
    this.width,
    this.height,
    this.validator,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType,
    this.icon,
    this.maxLines,
    this.isNumber = false,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.obscureText = false,
    this.autofillHints,
    this.sizeBoxHeight = 0,
    this.onChanged,
    this.contentPadding = 10,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: isNumber
                ? TextFormField(
                    enabled: enabled,
                    readOnly: readOnly,
                    onChanged: onChanged,
                    obscureText: obscureText,
                    autofillHints: autofillHints,
                    autovalidateMode: AutovalidateMode.always,
                    focusNode: focusNode,
                    controller: controller,
                    textInputAction: textInputAction,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: onFieldSubmitted,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: labelText,
                      contentPadding: EdgeInsets.all(contentPadding!),
                      icon: icon,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : TextFormField(
                    enabled: enabled,
                    onChanged: onChanged,
                    autofillHints: autofillHints,
                    obscureText: obscureText,
                    autovalidateMode: AutovalidateMode.always,
                    onFieldSubmitted: onFieldSubmitted,
                    focusNode: focusNode,
                    keyboardType: TextInputType.multiline,
                    initialValue: initialValue,
                    readOnly: readOnly,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(contentPadding!),
                      labelText: labelText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller,
                    validator: validator,
                  ),
          ),
          SizedBox(height: sizeBoxHeight),
        ],
      ),
    );
  }
}
