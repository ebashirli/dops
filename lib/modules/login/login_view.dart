import 'package:dops/components/custom_widgets.dart';
import 'package:dops/core/auth_manager.dart';
import 'package:dops/core/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthManager> with CacheManager {
  LoginView({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    emailController.text = getEmail()??'';
    passwordController.text = getPassword()??'';
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
            width: Get.width * 0.4,
            height: Get.height * .5,
            child: AutofillGroup(
              child: Form(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Login Page',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomTextFormField(
                          labelText: 'Email:',
                          autofillHints: [AutofillHints.email],
                          focusNode: FocusNode()..requestFocus(),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.contains('\n')) {
                              focusNode.requestFocus();
                            }
                          }),
                      CustomTextFormField(
                        focusNode: focusNode,
                        labelText: 'Password',
                        obscureText: true,
                        autofillHints: [AutofillHints.password],
                        maxLines: 1,
                        controller: passwordController,
                        textInputAction: TextInputAction.none,
                      ),
                      Container(
                        height: 45,
                        width: Get.width * 0.1,
                        child: ElevatedButton(
                            onPressed: () async {
                              _login();
                              saveEmail(emailController.text);
                              savePassword(passwordController.text);
                            },
                            child: const Text('Sign in')),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Future<void> _login() async {
    await controller.login(emailController.text, passwordController.text);
  }
}
