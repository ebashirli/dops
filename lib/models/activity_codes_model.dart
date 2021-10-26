import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityCodeModel {
  String? docId;
  String? activityId;
  String? activityName;
  String? area;
  int? prio;
  int? coefficient;
  double? currentPriority;
  double? budgetedLaborUnits;
  DateTime? start;
  DateTime? finish;
  double? cumulative;

  ActivityCodeModel({
    this.docId,
    this.activityId,
    this.activityName,
    this.area,
    this.prio,
    this.coefficient,
    this.currentPriority,
    this.budgetedLaborUnits,
    this.start,
    this.finish,
    this.cumulative,
  });

  toMap() {
    return {
      'docId': docId,
      'activityId': activityId,
      'activityName': activityName,
      'area': area,
      'prio': prio,
      'coefficient': coefficient,
      'currentPriority': currentPriority,
      'budgetedLaborUnits': budgetedLaborUnits,
      'start': start,
      'finish': finish,
      'cumulative': cumulative,
    };
  }

  ActivityCodeModel.fromMap(DocumentSnapshot data) {
    docId = data.id;
    activityId = data['activity_id'];
    activityName = data['activity_name'];
    area = data['area'];
    prio = int.parse(data['prio']);
    coefficient = int.parse(data['coefficient']);
    currentPriority = double.parse(data['current_priority']);
    budgetedLaborUnits = double.parse(data['budgeted_labor_units']);
    start = data['start'].toDate();
    finish = data['finish'].toDate();
    cumulative = double.parse(data['cumulative']);
  }
}
