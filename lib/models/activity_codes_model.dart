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

  factory ActivityCodeModel.fromMap(Map<String, dynamic> map) {
    return ActivityCodeModel(
      docId: map['docId'] != null ? map['docId'] : null,
      activityId: map['activityId'] != null ? map['activityId'] : null,
      activityName: map['activityName'] != null ? map['activityName'] : null,
      area: map['area'] != null ? map['area'] : null,
      prio: map['prio'] != null ? map['prio'] : null,
      coefficient: map['coefficient'] != null ? map['coefficient'] : null,
      currentPriority:
          map['currentPriority'] != null ? map['currentPriority'] : null,
      budgetedLaborUnits:
          map['budgetedLaborUnits'] != null ? map['budgetedLaborUnits'] : null,
      start: map['start'] != null ? map['start'].toDate() : null,
      finish: map['finish'] != null ? map['finish'].toDate() : null,
      cumulative: map['cumulative'] != null ? map['cumulative'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityCodeModel.fromJson(String source) {
    return ActivityCodeModel.fromMap(json.decode(source));
  }
}
