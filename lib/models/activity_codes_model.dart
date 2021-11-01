import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'activityId': activityId,
      'activityName': activityName,
      'area': area,
      'prio': prio,
      'coefficient': coefficient,
      'currentPriority': currentPriority,
      'budgetedLaborUnits': budgetedLaborUnits,
      'start': start?.millisecondsSinceEpoch,
      'finish': finish?.millisecondsSinceEpoch,
      'cumulative': cumulative,
    };
  }

  factory ActivityCodeModel.fromMap(Map<String, dynamic> map, String docId) {
    return ActivityCodeModel(
        docId: docId,
        activityId: map['activityId'],
        activityName: map['activityName'],
        area: map['area'],
        prio: map['prio'],
        coefficient: map['coefficient'],
        currentPriority: map['currentPriority'],
        budgetedLaborUnits: map['budgetedLaborUnits'],
        start: map['start'],
        finish: map['finish'],
        cumulative: map['cumulative']);
  }

  String toJson() => json.encode(toMap());

  // factory ActivityCodeModel.fromJson(String source) {
  //   return ActivityCodeModel.fromMap(json.decode(source));
  // }
}
