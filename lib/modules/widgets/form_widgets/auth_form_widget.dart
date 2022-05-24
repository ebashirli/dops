import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordChangingForm extends StatelessWidget {
  PasswordChangingForm({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController reNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomTextFormField(
            labelText: 'Email',
            autofillHints: [AutofillHints.email],
            focusNode: FocusNode()..requestFocus(),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            // validator: (value)
            //   return null;
            // },
          ),
          CustomTextFormField(
            labelText: 'Old password',
            obscureText: true,
            autofillHints: [AutofillHints.password],
            maxLines: 1,
            controller: oldPasswordController,
            textInputAction: TextInputAction.none,
          ),
          CustomTextFormField(
            labelText: 'New password',
            obscureText: true,
            autofillHints: [AutofillHints.password],
            maxLines: 1,
            controller: newPasswordController,
            textInputAction: TextInputAction.none,
          ),
          CustomTextFormField(
            labelText: 'New password again',
            obscureText: true,
            autofillHints: [AutofillHints.password],
            maxLines: 1,
            controller: reNewPasswordController,
            textInputAction: TextInputAction.none,
          ),
          Container(
            height: 45,
            width: Get.width * 0.1,
            child: ElevatedButton(
              onPressed: () async =>
                  cacheManager.saveEmail(emailController.text),
              child: const Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
