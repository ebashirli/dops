import 'package:flutter/material.dart';

class UserFormWidget extends StatelessWidget {
  const UserFormWidget({
    Key? key,
    required this.index,
    required this.formKey,
  }) : super(key: key);
  final int index;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Text('Form User ${index}'),
    );
  }
}
