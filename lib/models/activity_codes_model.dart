import 'dart:convert';

class ActivityCodeModel {
  String? docId;
  String? activityId;
  String? activityName;
  // String? moduleName;
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
    // this.moduleName,
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
      'docId': docId,
      'activity_id': activityId,
      'activity_name': activityName,
      // 'module_name': moduleName,
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

  factory ActivityCodeModel.fromMap(Map<String, dynamic> map, String docId) {
    return ActivityCodeModel(
        docId: docId,
        activityId: map['activity_id'],
        activityName: map['activity_name'],
        // moduleName: map['module_name'],
        area: map['area'],
        prio: map['prio'],
        coefficient: map['coefficient'],
        currentPriority: map['current_priority'],
        budgetedLaborUnits: map['budgeted_labor_units'],
        start: map['start'].toDate(),
        finish: map['finish'].toDate(),
        cumulative: map['cumulative']);
  }

  String toJson() => json.encode(toMap());

  // factory ActivityCodeModel.fromJson(String source) {
  //   return ActivityCodeModel.fromMap(json.decode(source));
  // }

}
