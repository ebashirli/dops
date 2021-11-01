class UserModel {
  final String id;
  final String? fullName;
  final String? email;
  final String? userRole;

  UserModel({
    required this.id,
    this.fullName,
    this.email,
    this.userRole,
  });

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        userRole = data['userRole'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
    };
  }
}
