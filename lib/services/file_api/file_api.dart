import 'dart:convert';
import 'dart:html' as html;

import 'package:dops/modules/models/drawing_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/models/stage_model.dart';
import 'package:dops/modules/models/task_model.dart';
import 'package:dops/modules/models/value_model.dart';

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

  Map<String, dynamic> bodyToMap = {};

  if (taskModel != null) {
    DrawingModel? drawingModel = taskModel.drawingModel;
    if (drawingModel == null) return null;
    bodyToMap = Body(drawingModel: drawingModel, taskModel: taskModel).toMap();
  } else if (stageModel != null) {
    TaskModel? taskModel = stageModel.taskModel;
    if (taskModel == null) return null;
    DrawingModel? drawingModel = taskModel.drawingModel;
    if (drawingModel == null) return null;
    bodyToMap = Body(
      drawingModel: drawingModel,
      taskModel: taskModel,
      stageModel: stageModel,
    ).toMap();
  } else {
    if (valueModel == null || valueModel.staffModel == null) return null;
    StageModel? stageModel = valueModel.stageModel;
    if (stageModel == null) return null;
    TaskModel? taskModel = stageModel.taskModel;
    if (taskModel == null) return null;
    DrawingModel? drawingModel = taskModel.drawingModel;
    if (drawingModel == null) return null;

    bodyToMap = Body(
      drawingModel: drawingModel,
      taskModel: taskModel,
      stageModel: stageModel,
      valueModel: valueModel,
      isUnassign: isUnassign,
    ).toMap();
  }

  return await http.post(uri, body: jsonEncode(bodyToMap));
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
  TaskModel taskModel;
  DrawingModel drawingModel;
  StageModel? stageModel;
  ValueModel? valueModel;
  bool isUnassign;

  Body({
    required this.taskModel,
    required this.drawingModel,
    this.stageModel,
    this.valueModel,
    this.isUnassign = false,
  });

  String get url =>
      "http://172.30.134.63:8080/stages?id=${taskModel.id}&index=${stageModel?.index ?? 0}";
  String get taskNumber => taskModel.taskNumber;
  String get revisionType => taskModel.revisionType;
  String get title => drawingModel.drawingTitle;
  String get module => drawingModel.module;
  String get level => drawingModel.level;
  String get structureType => drawingModel.structureType;
  List<String?> get referenceDrawings => taskModel.referenceDocuments
      .map((e) => refDocController.getById(e)?.documentNumber)
      .toList();
  String get teklaPhase => '${drawingModel.teklaPhase}';
  String get eCFNumber => '${taskModel.changeNumber}';
  List<String?> get relatedPeopleInitials =>
      stageModel?.valueModels.map((e) => e?.staffModel?.initial).toList() ?? [];
  String get name => valueModel?.staffModel!.name ?? 'Coordinators';
  String? get note => stageModel?.note ?? taskModel.note;
  List<String> get emails => valueModel == null
      ? staffController.documents
          .where((e) => e.systemDesignation == "Coordinator")
          .map((e) => e.email)
          .toSet()
          .toList()
      : [valueModel!.staffModel!.email];

  String get subject => 'DOPS Notification | ${taskModel.taskNumber}';

  String get description => stageModel == null
      ? 'New revision has been created with following details: '
      : valueModel == null
          ? "${stageDetailsList[stageModel!.index - 1]['name']} of the the following revison has been completed: "
          : "You are ${isUnassign ? 'unassigned from' : 'assigned to'} following revision: ";

  String get toDo => valueModel == null
      ? 'Next action'
      : '${stageDetailsList[stageModel!.index]['name']}';

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
}
