class StaffModel {
  String? id;
  String badgeNo;
  bool isHidden;
  String name;
  String surname;
  String patronymic;
  String? fullName;
  String initial;
  String systemDesignation;
  String jobTitle;
  String email;
  String company;
  DateTime dateOfBirth;
  String homeAddress;
  DateTime startDate;
  String currentPlace;
  DateTime contractFinishDate;
  String contact;
  String emergencyContact;
  String emergencyContactName;
  String note;

  StaffModel({
    this.id,
    this.isHidden = false,
    required this.badgeNo,
    required this.name,
    required this.surname,
    required this.patronymic,
    this.fullName,
    required this.initial,
    required this.systemDesignation,
    required this.jobTitle,
    required this.email,
    required this.company,
    required this.dateOfBirth,
    required this.homeAddress,
    required this.startDate,
    required this.currentPlace,
    required this.contractFinishDate,
    required this.contact,
    required this.emergencyContact,
    required this.emergencyContactName,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'badgeNo': badgeNo,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'initial': initial,
      'systemDesignation': systemDesignation,
      'jobTitle': jobTitle,
      'email': email,
      'company': company,
      'dateOfBirth': dateOfBirth,
      'homeAddress': homeAddress,
      'startDate': startDate,
      'currentPlace': currentPlace,
      'contractFinishDate': contractFinishDate,
      'contact': contact,
      'emergencyContact': emergencyContact,
      'emergencyContactName': emergencyContactName,
      'note': note,
      'isHidden': isHidden,
    };
  }

  factory StaffModel.fromMap(
    Map<String, dynamic> map,
    String? id,
  ) {
    return StaffModel(
      id: id ?? '',
      badgeNo: map['badgeNo'],
      name: map['name'],
      surname: map['surname'],
      patronymic: map['patronymic'],
      initial: map['initial'],
      systemDesignation: map['systemDesignation'],
      jobTitle: map['jobTitle'],
      email: map['email'],
      company: map['company'],
      dateOfBirth:
          map['dateOfBirth'] != null ? map['dateOfBirth'].toDate() : null,
      homeAddress: map['homeAddress'],
      startDate: map['startDate'] != null ? map['startDate'].toDate() : null,
      currentPlace: map['currentPlace'],
      contractFinishDate: map['contractFinishDate'] != null
          ? map['contractFinishDate'].toDate()
          : null,
      contact: map['contact'],
      emergencyContact: map['emergencyContact'],
      emergencyContactName: map['emergencyContactName'],
      note: map['note'],
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}
