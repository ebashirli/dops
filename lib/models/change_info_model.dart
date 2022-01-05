class ChangeInfoModel {
  final DateTime? dateTime;
  final String? byId;

  ChangeInfoModel(this.dateTime, this.byId);

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'byId': byId,
    };
  }

  factory ChangeInfoModel.fromMap(Map<String, dynamic> map) {
    return ChangeInfoModel(
      map['dateTime'] != null ? map['dateTime'].toDate() : null,
      map['byId'] != null ? map['byId'] : null,
    );
  }
}
