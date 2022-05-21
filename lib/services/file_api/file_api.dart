import 'dart:convert';
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:dops/modules/values/value_model.dart';

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

Future<http.Response?>? sendNotificationEmail({
  TaskModel? taskModel,
  ValueModel? valueModel,
  StageModel? stageModel,
  bool isUnassign = false,
}) async {
  final String url = baseUrl + 'send-notification-email';
  final Uri uri = Uri.parse(url);

  List<String> coordinatorsEmails = staffController.documents
      .where((e) => e.systemDesignation == "Coordinator")
      .map((e) => e.email)
      .toList();

  if (taskModel == null)
    taskModel = stageModel?.taskModel ?? valueModel?.taskModel;
  if (taskModel == null) return null;
  if (stageModel == null)
    stageModel = valueModel?.stageModel ?? taskModel.stageModels.first;
  if (stageModel == null) return null;

  Body body = Body(
    subject: 'DOPS Notification',
    emails: valueModel != null
        ? [staffController.getById(valueModel.employeeId!)!.email]
        : coordinatorsEmails,
    name: valueModel != null
        ? staffController.getById(valueModel.employeeId!)!.name
        : 'Coordinators',
    description: 'description',
    url:
        "http://172.30.134.63:8080/stages?id=${taskModel.id}&index=${stageModel.index}",
    taskNumber:
        '${taskModel.drawingModel?.drawingNumber}-${taskModel.revisionMark}',
    toDo: "",
    revisionType: taskModel.revisionType,
    title: taskModel.drawingModel!.drawingTitle,
    module: taskModel.drawingModel!.module,
    level: taskModel.drawingModel!.level,
    structureType: taskModel.drawingModel!.structureType,
    referenceDrawings: taskModel.referenceDocuments,
    teklaPhase: '${taskModel.teklaPhase}',
    eCFNumber: "${taskModel.changeNumber}",
    relatedPeopleInitials: staffController.documents
        .where((e) =>
            stageModel!.valueModels.map((e) => e?.employeeId).contains(e.id))
        .map((e) => e.initial)
        .toList(),
    note: stageModel.note,
  );

  return await http.post(
    uri,
    body: jsonEncode(body),
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

class Body {
  final List<String> emails;
  final String subject;
  final String name;
  final String description;
  final String url;
  final String taskNumber;
  final String? toDo;
  final String revisionType;
  final String title;
  final String module;
  final String level;
  final String structureType;
  final List<String> referenceDrawings;
  final String teklaPhase;
  final String eCFNumber;
  final List<String> relatedPeopleInitials;
  final String? note;

  Body({
    required this.subject,
    required this.emails,
    required this.name,
    required this.description,
    required this.url,
    required this.taskNumber,
    required this.toDo,
    required this.revisionType,
    required this.title,
    required this.module,
    required this.level,
    required this.structureType,
    required this.referenceDrawings,
    required this.teklaPhase,
    required this.eCFNumber,
    required this.relatedPeopleInitials,
    required this.note,
  });
}
