import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomDateTimeFormField extends StatelessWidget {
  CustomDateTimeFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.initialValue,
  }) : super(key: key);
  final String labelText;
  final String? initialValue;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: TextFormField(
            onChanged: (value) => print(controller.text),
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              final components = value.split("/");
              if (components.length == 3) {
                final day = int.tryParse(components[0]);
                final month = int.tryParse(components[1]);
                final year = int.tryParse(components[2]);
                if (day != null && month != null && year != null) {
                  final date = DateTime(year, month, day);
                  if (date.year == year &&
                      date.month == month &&
                      date.day == day) {
                    return null;
                  }
                }
              }
              return "Wrong date";
            },
            controller: controller,
            inputFormatters: [MaskTextInputFormatter(mask: "##/##/####")],
            autocorrect: false,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              hintText: 'dd/mm/yyyy',
              hintStyle: const TextStyle(color: Colors.black45),
              errorStyle: const TextStyle(color: Colors.redAccent),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () async {
                  final DateTime? _selectedDate = await showDatePicker(
                    context: context,
                    initialDatePickerMode: DatePickerMode.day,
                    initialDate: DateTime.now(),
                    initialEntryMode: DatePickerEntryMode.calendar,
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2030),
                  );
                  controller.text =
                      '${_selectedDate!.day}/${_selectedDate.month}/${_selectedDate.year}';
                },
                icon: const Icon(Icons.event_note),
              ),
              labelText: labelText,
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
