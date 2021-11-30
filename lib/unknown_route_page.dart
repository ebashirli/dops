import 'package:flutter/material.dart';

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '404',
            style: TextStyle(fontSize: 34),
          ),
          const Text('Page not found')
        ],
      )),
    );
  }
}
