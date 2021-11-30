import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final controller = Get.find<LoginController>();
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
                          CustomTextFormField(labelText: 'Email:', controller: emailController),
                          CustomTextFormField(
                            labelText: 'Password',
                            controller: passwordController,
                          ),
                          Container(
                            height: 45,
                            width: Get.width * 0.1,
                            child: ElevatedButton(
                                onPressed: () async {
                                  controller.isLoading.value = true;
                                  await authController.login(emailController.text, passwordController.text);
                                  controller.isLoading.value = false;
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
}
