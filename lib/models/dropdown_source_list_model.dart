import 'dart:convert';

class DropdownSourceListModel {
  String? docId;
  List<String>? list;

  DropdownSourceListModel({
    this.docId,
    this.list,
  });

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'list': list,
    };
  }

  factory DropdownSourceListModel.fromMap(String id, Map<String, dynamic> map) {
    return DropdownSourceListModel(
      docId: id,
      list: map['list'] != null ? map['list'] : null,
    );
  }

  String toJson() => json.encode(toMap());
}
