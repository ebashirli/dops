import 'package:dops/components/custom_widgets.dart';
import 'package:dops/core/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthManager> {
  LoginView({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
            width: Get.width * 0.4,
            height: Get.height * .5,
            child: Obx(() {
              return Stack(
                children: [
                  Form(
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
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              // onSubmitted: (p0) => focusNode.requestFocus(),
                              validator: (value) {
                                if (value!.contains('\n')) {
                                  focusNode.requestFocus();
                                }
                              }),
                          CustomTextFormField(
                            focusNode: focusNode,
                            labelText: 'Password',
                            controller: passwordController,
                            textInputAction: TextInputAction.go,
                            onSubmitted: (p0) => print('salam'),
                            // validator: (value) {
                            //   if (value!.contains('\n')) {
                            //     print('alma');
                            //   }
                            // }
                          ),
                          Container(
                            height: 45,
                            width: Get.width * 0.1,
                            child: ElevatedButton(
                                onPressed: () async {
                                  await _login();
                                },
                                child: const Text('Sign in')),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (controller.isLoading.value) Center(child: CircularProgressIndicator())
                ],
              );
            })),
      ),
    );
  }

  Future<void> _login() async {
    controller.isLoading.value = true;
    await controller.login(emailController.text, passwordController.text);
    controller.isLoading.value = false;
  }
}
