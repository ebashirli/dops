import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dropdown_sources_controller.dart';

// ignore: must_be_immutable
class DropdownSourcesView extends StatelessWidget {
  final controller = Get.find<DropdownSourcesController>();
  List<String> fieldNames = [];
  List<List<String>> values = [];

  @override
  Widget build(BuildContext context) {
    return Text('data');

    // return Obx(() {
    // return Center(
    //   child: ListView.separated(
    //     padding: EdgeInsets.zero,
    //     controller: ScrollController(),
    //     scrollDirection: Axis.horizontal,
    //     itemCount: 12,
    //     separatorBuilder: (context, index) => SizedBox(width: 12),
    //     itemBuilder: (context, index) {
    //       return Container();
    //     },
    //   ),
    // );
    // });
  }
}
