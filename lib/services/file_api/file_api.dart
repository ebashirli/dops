import 'dart:convert';
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/staff/staff_model.dart';
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
  print('UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU: $isUnassign');
  print('helooooooooooo');
  final String url = baseUrl + 'send-notification-email';
  final Uri uri = Uri.parse(url);

  List<String> coordinatorsEmails = staffController.documents
      .where((e) => e.systemDesignation == "Coordinator")
      .map((e) => e.email)
      .toList();

  print('helooooooooooo0');
  if (taskModel == null)
    taskModel = stageModel?.taskModel ?? valueModel?.taskModel;
  if (taskModel == null) return null;
  if (stageModel == null)
    stageModel = valueModel?.stageModel ?? taskModel.stageModels.first;
  if (stageModel == null) return null;
  print('helooooooooooo1');

  StaffModel? staffModel =
      staffController.getById(valueModel?.employeeId ?? '');
  if (staffModel == null) return null;
  print('subject');
  String subject = 'DOPS Notification';
  print('emails');
  List<String> emails = valueModel != null
      ? [staffController.getById(valueModel.employeeId!)!.email]
      : coordinatorsEmails;
  print('name');
  final String name = valueModel != null
      ? staffController.getById(valueModel.employeeId!)!.name
      : 'Coordinators';
  print('description');
  final String description = 'description';
  final String urlToTask =
      "http://172.30.134.63:8080/stages?id=${taskModel.id}&index=${stageModel.index}";
  final String taskNumber =
      '${taskModel.drawingModel?.drawingNumber}-${taskModel.revisionMark}';
  print('toDo');
  final String toDo = "";
  print('revisionType');
  final String revisionType = taskModel.revisionType;
  print('title');
  final String title = taskModel.drawingModel!.drawingTitle;
  print('module');
  final String module = taskModel.drawingModel!.module;
  print('level');
  final String level = taskModel.drawingModel!.level;
  print('structureType');
  final String structureType = taskModel.drawingModel!.structureType;
  print('referenceDrawings');
  final List<String> referenceDrawings = taskModel.referenceDocuments;
  print('teklaPhase');
  final String teklaPhase = '${taskModel.teklaPhase}';
  print('eCFNumber');
  final String eCFNumber = "${taskModel.changeNumber}";
  print('relatedPeopleInitials');
  final List<String> relatedPeopleInitials = staffController.documents
      .where((e) =>
          stageModel!.valueModels.map((e) => e?.employeeId).contains(e.id))
      .map((e) => e.initial)
      .toList();
  print('note');
  final String? note = stageModel.note;

  Body body = Body(
    subject: subject,
    emails: emails,
    name: name,
    description: description,
    url: urlToTask,
    taskNumber: taskNumber,
    toDo: toDo,
    revisionType: revisionType,
    title: title,
    module: module,
    level: level,
    structureType: structureType,
    referenceDrawings: referenceDrawings,
    teklaPhase: teklaPhase,
    eCFNumber: eCFNumber,
    relatedPeopleInitials: relatedPeopleInitials,
    note: note,
  );
  print('helooooooooooo2');
  Map<String, dynamic> bodyToMap = body.toMap();
  print(bodyToMap);

  return await http.post(
    uri,
    body: jsonEncode(bodyToMap),
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

  Map<String, dynamic> toMap() {
    return {
      'emails': emails,
      'subject': subject,
      'name': name,
      'description': description,
      'url': url,
      'taskNumber': taskNumber,
      'toDo': toDo,
      'revisionType': revisionType,
      'title': title,
      'module': module,
      'level': level,
      'structureType': structureType,
      'referenceDrawings': referenceDrawings,
      'teklaPhase': teklaPhase,
      'eCFNumber': eCFNumber,
      'relatedPeopleInitials': relatedPeopleInitials,
      'note': note,
    };
  }

  factory Body.fromMap(Map<String, dynamic> map) {
    return Body(
      emails: List<String>.from(map['emails']),
      subject: map['subject'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      taskNumber: map['taskNumber'] ?? '',
      toDo: map['toDo'],
      revisionType: map['revisionType'] ?? '',
      title: map['title'] ?? '',
      module: map['module'] ?? '',
      level: map['level'] ?? '',
      structureType: map['structureType'] ?? '',
      referenceDrawings: List<String>.from(map['referenceDrawings']),
      teklaPhase: map['teklaPhase'] ?? '',
      eCFNumber: map['eCFNumber'] ?? '',
      relatedPeopleInitials: List<String>.from(map['relatedPeopleInitials']),
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Body.fromJson(String source) => Body.fromMap(json.decode(source));
}
