import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomDateTimeFormField extends StatelessWidget {
  CustomDateTimeFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.initialValue,
    this.width = 200,
  }) : super(key: key);
  final String labelText;
  final String? initialValue;
  final TextEditingController controller;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width,
          child: TextFormField(
            // validator: (value) {
            //   if (value!.isEmpty) {
            //     return null;
            //   }
            //   final components = value.split("-");
            //   if (components.length == 3) {
            //     final day = int.tryParse(components[0]);
            //     final month = int.tryParse(components[1]);
            //     final year = int.tryParse(components[2]);
            //     if (day != null && month != null && year != null) {
            //       final date = DateTime(year, month, day);
            //       if (date.year == year &&
            //           date.month == month &&
            //           date.day == day) {
            //         return null;
            //       }
            //     }
            //   }
            //   return "Wrong date";
            // },
            controller: controller,
            inputFormatters: [MaskTextInputFormatter(mask: "####-##-##")],
            autocorrect: false,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              hintText: 'yyyy-mm-dd',
              hintStyle: const TextStyle(color: Colors.black45),
              errorStyle: const TextStyle(color: Colors.redAccent),
              border: const OutlineInputBorder(),
              // suffixIcon: IconButton(
              //   onPressed: () async {
              //     final DateTime? _selectedDate = await showDatePicker(
              //       context: context,
              //       initialDatePickerMode: DatePickerMode.day,
              //       initialDate: DateTime.now(),
              //       initialEntryMode: DatePickerEntryMode.calendar,
              //       firstDate: DateTime(0),
              //       lastDate: DateTime(2500),
              //     );
              //     controller.text = _selectedDate!.toDMYhmDash();
              //   },
              //   icon: const Icon(Icons.event_note),
              // ),
              labelText: labelText,
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
