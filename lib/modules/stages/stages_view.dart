import 'package:dops/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StagesView extends StatefulWidget {
  @override
  State<StagesView> createState() => _StagesViewState();
}

class _StagesViewState extends State<StagesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(200, 20, 200, 20),
        child: Column(
          children: [
            stagesController.buildEditForm(),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                controller: ScrollController(),
                children: [
                  Obx(() {
                    return stagesController.buildPanel();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
