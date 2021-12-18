class ChangeInfodModel {
  final DateTime? dateTime;
  final String? byId;

  ChangeInfodModel(this.dateTime, this.byId);

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'byId': byId,
    };
  }

  factory ChangeInfodModel.fromMap(Map<String, dynamic> map) {
    return ChangeInfodModel(
      map['dateTime'] != null ? map['dateTime'].toDate() : null,
      map['byId'] != null ? map['byId'] : null,
    );
  }
}
