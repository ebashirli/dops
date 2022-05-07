import 'dart:convert';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dops/constants/constant.dart';

Future<String?> uploadFiles({
  required List<PlatformFile?> files,
  required String id,
  String? folder,
}) async {
  if (files.isEmpty) return null;
  try {
    final String url =
        baseUrl + 'upload/$id' + (folder == null ? '' : '/?folder=$folder');

    final Uri uri = Uri.parse(url);
    final http.MultipartRequest request = http.MultipartRequest("POST", uri);
    files.forEach((file) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          List<int>.from(file!.bytes!.toList()),
          contentType: MediaType('application', file.extension!),
          filename: file.name,
        ),
      );
    });

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();

      return respStr;
    } else {
      return null;
    }
  } catch (e) {
    return e.toString();
  }
}

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
