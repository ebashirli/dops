abstract class BaseModel {
  dynamic docId;
  BaseModel({
    required this.docId,
  });

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
    };
  }

  Map<String, dynamic> toJson();
  BaseModel fromJson(Map<String, dynamic> json);
}
