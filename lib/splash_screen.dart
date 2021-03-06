import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/views/auth_view.dart';
import 'package:dops/modules/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.userChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !authManager.isLoading.value) {
          return _waiting();
        } else {
          if (snapshot.hasError) {
            return errorView(snapshot);
          } else if (snapshot.data != null) {
            return FutureBuilder(
              future: authManager.initializeStaffModel(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return HomeView();
                } else if (snapshot.hasError) {
                  return errorView(snapshot);
                }
                return _waiting();
              },
            );
          }
        }
        return LoginView();
      },
    );
  }

  Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(
        body: Center(child: CustomText('Error: ${snapshot.error}')));
  }

  Scaffold _waiting() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              // child: CircularProgressIndicator(),
              child: Image.asset('images/azfen_logo.png'),
            ),
            const CustomText(
              'AZFEN J.V',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 5,
            ),
            const CustomText(
              'Drawing Office Department',
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
