class ActivityModel {
  String? id;
  String? activityId;
  String? activityName;
  String? moduleName;
  int coefficient;
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
      'activityId': activityId,
      'activityName': activityName,
      'moduleName': moduleName,
      'coefficient': coefficient,
      'budgetedLaborUnits': budgetedLaborUnits,
      'startDate': startDate,
      'finishDate': finishDate,
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
      activityId: map['activityId'],
      activityName: map['activityName'],
      moduleName: map['moduleName'],
      coefficient: map['coefficient'],
      budgetedLaborUnits: map['budgetedLaborUnits'],
      startDate: map['startDate'] != null ? map['startDate'].toDate() : null,
      finishDate: map['finishDate'] != null ? map['finishDate'].toDate() : null,
      cumulative: map['cumulative'],
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}