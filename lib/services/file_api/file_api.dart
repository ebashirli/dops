import 'dart:convert';
import 'dart:html' as html;
import 'package:dops/constants/lists.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dops/constants/constant.dart';

dowloadFiles({
  required List<String?> ids,
  String? filingFolder,
}) async {
  final String url = baseUrl +
      'download' +
      (filingFolder == null ? '' : '/?folder=$filingFolder');

  final Uri uri = Uri.parse(url);

  return await http
      .post(uri, body: jsonEncode({'ids': ids}))
      .then((_) => html.window.location.href = url);
}

dowloadFile({
  required String id,
  required String name,
  String? filingFolder,
}) async {
  final String url = baseUrl +
      'download/$id/$name' +
      (filingFolder == null ? '' : '/?folder=$filingFolder');

  return html.window.location.href = url;
}

Future<http.Response> sendEmail({
  required String drawingNo,
  required String filingId,
  required List<String?> nestingIds,
  required String email,
  String? note,
}) async {
  final String url = baseUrl + 'sendemail';
  final Uri uri = Uri.parse(url);
  return await http.post(
    uri,
    body: jsonEncode({
      'drawingNo': drawingNo,
      'filingId': filingId,
      'nestingIds': nestingIds,
      'email': email,
      'note': note,
    }),
  );
}

Future<String?> uploadFiles(UploadingFileType? filesType, String id) async {
  try {
    final String url = baseUrl +
        'upload/$id' +
        (filesType?.folderName == null
            ? ''
            : '/?folder=${filesType?.folderName}');

    final Uri uri = Uri.parse(url);
    final http.MultipartRequest request = http.MultipartRequest("POST", uri);
    filesType?.files.forEach((file) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          List<int>.from(file!.bytes!.toList()),
          contentType: MediaType('application', file.extension!),
          filename: file.name,
        ),
      );
    });

    final http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return respStr;
    }
    return await response.statusCode.toString();
  } catch (e) {
    return e.toString();
  }
}
