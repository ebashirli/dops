import 'dart:convert';

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
    required this.docId,
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

  Map<String, dynamic> toMap() {
    return {
      'activity_id': activityId,
      'activity_name': activityName,
      'area': area,
      'prio': prio,
      'coefficient': coefficient,
      'current_priority': currentPriority,
      'budgeted_labor_units': budgetedLaborUnits,
      'start': start,
      'finish': finish,
      'cumulative': cumulative,
    };
  }

  factory ActivityCodeModel.fromMap(DocumentSnapshot data) {
    return ActivityCodeModel(
      docId: data.id,
      activityId: data['activity_id'],
      activityName: data['activity_name'],
      area: data['area'],
      prio: data['prio'],
      coefficient: data['coefficient'],
      currentPriority: data['current_priority'],
      budgetedLaborUnits: data['budgeted_labor_units'],
      start: data['start'].toDate(),
      finish: data['finish'].toDate(),
      cumulative: data['cumulative'],
    );
  }

  String toJson() => json.encode(toMap());
}
