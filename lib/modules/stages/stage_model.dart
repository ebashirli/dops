class StageModel {
  String? id;
  String taskId;
  int index;
  int checkerCommentCounter;
  int reviewerCommentCounter;
  bool isHidden;
  DateTime creationDateTime;

  StageModel({
    this.id,
    required this.taskId,
    required this.index,
    required this.checkerCommentCounter,
    required this.reviewerCommentCounter,
    this.isHidden = false,
    required this.creationDateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'index': index,
      'checkerCommentCounter': checkerCommentCounter,
      'reviewerCommentCounter': reviewerCommentCounter,
      'creationDateTime': creationDateTime,
      'isHidden': isHidden,
    };
  }

  factory StageModel.fromMap(Map<String, dynamic> map, String? id) {
    return StageModel(
      id: id ?? null,
      taskId: map['taskId'],
      index: map['index'],
      checkerCommentCounter: map['checkerCommentCounter'],
      reviewerCommentCounter: map['reviewerCommentCounter'],
      isHidden: map['isHidden'],
      creationDateTime: map['creationDateTime'] != null
          ? map['creationDateTime'].toDate()
          : null,
    );
  }
}
