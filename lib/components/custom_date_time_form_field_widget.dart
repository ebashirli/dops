import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDateTimeFormField extends StatelessWidget {
  CustomDateTimeFormField({
    Key? key,
    required this.labelText,
    this.initialValue,
    this.onDateSelected,
  }) : super(key: key);
  final String labelText;
  final DateTime? initialValue;
  final dynamic Function(DateTime value)? onDateSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          child: DateTimeFormField(
            initialValue: initialValue,
            mode: DateTimeFieldPickerMode.date,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: labelText,
            ),
            // firstDate: DateTime.now().add(const Duration(days: 10)),
            // initialDate: DateTime.now().add(const Duration(days: 10)),
            // autovalidateMode: AutovalidateMode.always,
            // validator: (DateTime? e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
            onDateSelected: onDateSelected,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
