class ValueModel {
  String? id;
  String stageId;
  String? employeeId;
  String assignedBy;
  DateTime assignedDateTime;
  DateTime? unassignedBy;
  DateTime? unassignedDateTime;
  DateTime? submitDateTime;
  int? phase;
  int? weight;
  int? gas;
  int? sfd;
  int? dtl;
  String? holdContainingReason;
  String? note;
  List<String>? fileNames;
  bool isCommented;
  bool isHidden;

  ValueModel({
    this.id,
    required this.stageId,
    required this.employeeId,
    required this.assignedBy,
    required this.assignedDateTime,
    this.unassignedBy,
    this.unassignedDateTime,
    this.submitDateTime,
    this.phase,
    this.weight,
    this.gas,
    this.sfd,
    this.dtl,
    this.holdContainingReason,
    this.note,
    this.fileNames,
    this.isCommented = false,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'stageId': stageId,
      'employeeId': employeeId,
      'assignedBy': assignedBy,
      'assignedDateTime': assignedDateTime,
      'isCommented': isCommented,
      'isHidden': isHidden,
      'holdContainingReason':
          holdContainingReason != null ? holdContainingReason : null,
      'submitDateTime': submitDateTime != null ? submitDateTime : null,
      'phase': phase != null ? phase : null,
      'weight': weight != null ? weight : null,
      'gas': gas != null ? gas : null,
      'sfd': sfd != null ? sfd : null,
      'dtl': dtl != null ? dtl : null,
      'note': note != null ? note : null,
      'fileNames': fileNames != null ? fileNames : null,
    };
  }

  factory ValueModel.fromMap(Map<String, dynamic> map, String? id) {
    return ValueModel(
      id: id ?? null,
      stageId: map['stageId'],
      employeeId: map['employeeId'],
      assignedBy: map['assignedBy'],
      assignedDateTime: map['assignedDateTime'] != null
          ? map['assignedDateTime'].toDate()
          : null,
      submitDateTime:
          map['submitDateTime'] != null ? map['submitDateTime'].toDate() : null,
      holdContainingReason: map['holdContainingReason'] != null
          ? map['holdContainingReason']
          : null,
      phase: map['phase'] != null ? map['phase'] : null,
      weight: map['weight'] != null ? map['weight'] : null,
      gas: map['gas'] != null ? map['gas'] : null,
      sfd: map['sfd'] != null ? map['sfd'] : null,
      dtl: map['dtl'] != null ? map['dtl'] : null,
      note: map['note'] != null ? map['note'] : null,
      fileNames:
          map['fileNames'] != null ? List<String>.from(map['fileNames']) : null,
      isCommented: map['isCommented'],
      isHidden: map['isHidden'],
    );
  }
}
