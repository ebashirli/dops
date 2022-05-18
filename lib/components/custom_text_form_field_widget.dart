import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final double? width;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool readOnly;
  final TextInputType? keyboardType;
  final bool isNumber;
  final bool obscureText;
  final int? maxLines;
  final FocusNode? focusNode;
  final void Function(String?)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final double? sizeBoxHeight;
  final void Function(String)? onChanged;
  final double? contentPadding;
  final bool? enabled;
  final void Function()? onEditingComplete;
  final bool autofocus;

  const CustomTextFormField(
      {Key? key,
      this.controller,
      this.labelText,
      this.width,
      this.validator,
      this.initialValue,
      this.readOnly = false,
      this.keyboardType,
      this.maxLines = 1,
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
      this.onEditingComplete,
      this.autofocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: TextFormField(
              enabled: enabled,
              readOnly: readOnly,
              onChanged: onChanged,
              obscureText: obscureText,
              autofillHints: autofillHints,
              autovalidateMode: AutovalidateMode.always,
              focusNode: focusNode,
              controller: controller,
              textInputAction: textInputAction,
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.multiline,
              onFieldSubmitted: onFieldSubmitted,
              onEditingComplete: onEditingComplete,
              autofocus: autofocus,
              initialValue: initialValue,
              maxLines: maxLines,
              inputFormatters: isNumber
                  ? <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]'),
                      ),
                    ]
                  : null,
              decoration: InputDecoration(
                isDense: true,
                labelText: labelText,
                contentPadding: EdgeInsets.all(contentPadding!),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
              validator: validator,
            ),
          ),
          SizedBox(height: sizeBoxHeight),
        ],
      ),
    );
  }
}
