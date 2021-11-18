class ActivityModel {
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
  bool isHidden;

  ActivityModel({
    this.id,
    this.activityId,
    this.activityName,
    this.moduleName,
    this.priority,
    this.coefficient = 1,
    this.currentPriority,
    this.budgetedLaborUnits,
    this.startDate,
    this.finishDate,
    this.cumulative = 0,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'activity_name': activityName,
      'module_name': moduleName,
      'priority': priority,
      'coefficient': coefficient,
      'current_priority': currentPriority,
      'budgeted_labor_units': budgetedLaborUnits,
      'start_date': startDate,
      'finish_date': finishDate,
      'cumulative': cumulative,
      'isHidden': isHidden,
    };
  }

  factory ActivityModel.fromMap(
    Map<String, dynamic> map,
    String? id,
  ) {
    return ActivityModel(
      id: id,
      activityId: map['activity_id'],
      activityName: map['activity_name'],
      moduleName: map['module_name'],
      priority: map['priority'],
      coefficient: map['coefficient'],
      currentPriority: map['current_priority'],
      budgetedLaborUnits: map['budgeted_labor_units'],
      startDate: map['start_date'] != null ? map['start_date'].toDate() : null,
      finishDate:
          map['finish_date'] != null ? map['finish_date'].toDate() : null,
      cumulative: map['cumulative'],
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}
