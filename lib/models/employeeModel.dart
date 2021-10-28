import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  String? docId;
  String? name;
  String? address;

  EmployeeModel({this.docId, this.name, this.address});

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'name': name,
      'address': address,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      docId: map['docId'] != null ? map['docId'] : null,
      name: map['name'] != null ? map['name'] : null,
      address: map['address'] != null ? map['address'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromJson(String source) =>
      EmployeeModel.fromMap(json.decode(source));
}
