import 'package:dops/services/file_api/file_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Column getFilesDialogContent(
  List<String?> fileNames, {
  List<PlatformFile?>? files,
  int? index,
  String? valueModelId,
  String? filingFolder,
  List<String?>? valueModelIds,
}) {
  return Column(
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
              onPressed: () async {
                await dowloadFiles(
                  ids: valueModelIds ?? [valueModelId],
                  filingFolder: filingFolder,
                );
              },
              child: Text('Download All'),
            ),
          ],
        ),
    ],
  );
}
