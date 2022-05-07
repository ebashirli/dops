import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/login/auth_controller.dart';
import 'package:dops/modules/login/widgets/password_changing_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthManager> {
  LoginView({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    emailController.text = cacheManager.getEmail() ?? '';
    passwordController.text = cacheManager.getPassword() ?? '';
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8)),
            width: Get.width * 0.25,
            height: Get.height * .2,
            child: AutofillGroup(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomTextFormField(
                      labelText: 'Email',
                      autofillHints: [AutofillHints.email],
                      focusNode: FocusNode()..requestFocus(),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        return value!.contains('\n')
                            ? 'Forbidden charachter'
                            : null;
                      },
                    ),
                    CustomTextFormField(
                      focusNode: focusNode,
                      labelText: 'Password',
                      obscureText: true,
                      autofillHints: [AutofillHints.password],
                      maxLines: 1,
                      controller: passwordController,
                      textInputAction: TextInputAction.none,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 45,
                          width: Get.width * 0.1,
                          child: TextButton(
                              onPressed: () => changePasswordDialog(),
                              child: const Text('Forgot password')),
                        ),
                        Container(
                          height: 45,
                          width: Get.width * 0.1,
                          child: ElevatedButton(
                              onPressed: () async {
                                _login();
                                cacheManager
                                    .savePassword(passwordController.text);
                                cacheManager.saveEmail(emailController.text);
                              },
                              child: const Text('Sign in')),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future<dynamic> changePasswordDialog() => Get.defaultDialog(
        title: 'Password Changing',
        content: PasswordChangingForm(),
      );

  Future<void> _login() async =>
      await controller.login(emailController.text, passwordController.text);
}