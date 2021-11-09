class ActivityCodeModel {
  String? id;
  String? activityId;
  String? activityName;
  String? moduleName;
  int? priority;
  int? coefficient;
  double? currentPriority;
  double? budgetedLaborUnits;
  DateTime? startDate;
  DateTime? finishDate;
  double? cumulative;

  ActivityCodeModel({
    required this.id,
    this.activityId,
    this.activityName,
    this.moduleName,
    this.priority,
    this.coefficient,
    this.currentPriority,
    this.budgetedLaborUnits,
    this.startDate,
    this.finishDate,
    this.cumulative,
  });

  Map<String, dynamic> toMap() {
    return {
      'activity_id': activityId,
      'activity_name': activityName,
      'module_name': moduleName,
      'priority': priority,
      'coefficient': coefficient,
      'current_priority': currentPriority,
      'budgeted_labor_units': budgetedLaborUnits,
      'start_date': startDate,
      'finish_date': finishDate,
      'cumulative': cumulative,
    };
  }

  factory ActivityCodeModel.fromMap(
    Map<String, dynamic> map,
    String? id,
  ) {
    return ActivityCodeModel(
      id: id,
      activityId: map['activity_id'],
      activityName: map['activity_name'],
      moduleName: map['module_name'],
      priority: map['priority'],
      coefficient: map['coefficient'],
      currentPriority: map['current_priority'],
      budgetedLaborUnits: map['budgeted_labor_units'],
      startDate: map['start_date'].toDate(),
      finishDate: map['finish_date'].toDate(),
      cumulative: map['cumulative'],
    );
  }
}
