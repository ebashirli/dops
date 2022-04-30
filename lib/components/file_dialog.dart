import 'package:dops/services/file_api/file_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void filesDialog(
  List<String?> fileNames, {
  List<PlatformFile?>? files,
  int? index,
  String? valueModelId,
  List<String?>? valueModelIds,
}) {
  Get.defaultDialog(
    title: 'Files',
    content: Column(
      children: [
        ...fileNames
            .map<Widget>(
              (String? fileName) => TextButton(
                onPressed: () {
                  if (![valueModelId, fileName].contains(null))
                    dowloadFile(id: valueModelId!, name: fileName!);
                },
                child: Text(fileName!),
              ),
            )
            .toList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () {
                if (valueModelIds != null || valueModelIds!.isNotEmpty) {
                  dowloadFiles(valueModelIds);
                }
              },
              child: Text('Download All'),
            ),
          ],
        )
      ],
    ),
  );
}
