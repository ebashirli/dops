import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final TextStyle? style;
  final bool selectable;

  const CustomText(
    this.text, {
    Key? key,
    this.size,
    this.color,
    this.weight,
    this.style,
    this.selectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
        data: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.yellow,
            selectionColor: Colors.green,
            selectionHandleColor: Colors.blue,
          ),
        ),
        child: selectable
            ? Text(
                text,
                style: style,
              )
            : SelectableText(
                text,
                style: style,
              ),
      ),
    );
  }
}
