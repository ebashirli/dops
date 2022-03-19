import 'package:flutter/material.dart';
import 'package:get/get.dart';

void selectItemSnackbar({
  String? title,
  String? message,
}) =>
    Get.snackbar(
      title ?? 'Selection',
      message ?? 'Select an item',
      maxWidth: 250,
      backgroundColor: Colors.green[50],
    );
