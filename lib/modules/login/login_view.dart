import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(16),
            decoration:
                BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
            width: Get.width * 0.4,
            height: Get.height * .5,
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
                    CustomTextFormField(labelText: 'Email:', controller: emailController),
                    CustomTextFormField(
                      labelText: 'Password',
                      controller: passwordController,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          authController.login(emailController.text, passwordController.text);
                        },
                        child: const Text('Sign in'))
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
