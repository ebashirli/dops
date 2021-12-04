import 'dart:async';

import 'package:dops/constants/constant.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      // auth.currentUser!.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/azfen_logo.png'),
            ),
            const Text(
              'AZFEN J.V',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
            const Text(
              'Drawing Office Department',
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
