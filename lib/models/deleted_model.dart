class DeletedModel {
  final DateTime? deletedDateTime;
  final String? deletedById;

  DeletedModel(this.deletedDateTime, this.deletedById);

  Map<String, dynamic> toMap() {
    return {
      'deletedDateTime': deletedDateTime,
      'deletedById': deletedById,
    };
  }

  factory DeletedModel.fromMap(Map<String, dynamic> map) {
    return DeletedModel(
      map['deletedDateTime'] != null ? map['deletedDateTime'].toDate() : null,
      map['deletedById'] != null ? map['deletedById'] : null,
    );
  }
}
