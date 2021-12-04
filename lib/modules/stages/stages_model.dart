class StageModel {
  String? id;
  String taskId;
  int attemptNumber;
  int stageIndex;
  DateTime assignedDate;
  List<String> staff;
  bool isCommented;
  int totalValues;
  List<String?> fileNames;
  bool isHidden;

  StageModel({
    this.id,
    required this.taskId,
    required this.attemptNumber,
    required this.stageIndex,
    required this.assignedDate,
    required this.staff,
    this.isCommented = false,
    required this.totalValues,
    required this.fileNames,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'attemptNumber': attemptNumber,
      'stageIndex': stageIndex,
      'assignedDate': assignedDate,
      'staff': staff,
      'isCommented': isCommented,
      'totalValues': totalValues,
      'fileNames': fileNames,
      'isHidden': isHidden,
    };
  }

  factory StageModel.fromMap(Map<String, dynamic> map, String id) {
    return StageModel(
      id: map['id'] != null ? map['id'] : null,
      taskId: map['taskId'],
      attemptNumber: map['attemptNumber'],
      stageIndex: map['stageIndex'],
      assignedDate: map['assignedDate'].toDate(),
      staff: List<String>.from(map['staff']),
      isCommented: map['isCommented'],
      totalValues: map['totalValues'],
      fileNames: List<String?>.from(map['fileNames']),
      isHidden: map['isHidden'],
    );
  }
}
