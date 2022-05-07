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
  String? filingFolder,
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
                    dowloadFile(
                      id: valueModelId!,
                      name: fileName!,
                      filingFolder: filingFolder,
                    );
                },
                child: Text(fileName!),
              ),
            )
            .toList(),
        if (fileNames.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: (valueModelIds == null)
                    ? null
                    : valueModelIds.isEmpty
                        ? null
                        : () => dowloadFiles(
                              ids: valueModelIds,
                              filingFolder: filingFolder,
                            ),
                child: Text('Download All'),
              ),
            ],
          ),
      ],
    ),
  );
}
