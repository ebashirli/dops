class StageModel {
  String? id;
  String taskId;
  int index;
  int checkerCommentCounter;
  int reviewerCommentCounter;
  bool isHidden;
  DateTime? creationDateTime = DateTime.now();

  StageModel({
    this.id,
    required this.taskId,
    this.index = 0,
    this.checkerCommentCounter = 0,
    this.reviewerCommentCounter = 0,
    this.isHidden = false,
    this.creationDateTime,
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
