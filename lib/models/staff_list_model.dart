class StaffListModel {
  String? id;
  String badgeNo;
  String name;
  String surname;
  String patronymic;
  String fullName;
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

  StaffListModel({
    this.id,
    required this.badgeNo,
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.fullName,
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
      'badge_no': badgeNo,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'full_name': fullName,
      'initial': initial,
      'system_designation': systemDesignation,
      'job_title': jobTitle,
      'email': email,
      'company': company,
      'date_of_birth': dateOfBirth,
      'home_address': homeAddress,
      'start_date': startDate,
      'current_place': currentPlace,
      'contract_finish_date': contractFinishDate,
      'contact': contact,
      'emergency_contact': emergencyContact,
      'emergency_contact_name': emergencyContactName,
      'note': note,
    };
  }

  factory StaffListModel.fromMap(
    Map<String, dynamic> map,
    String? id,
  ) {
    return StaffListModel(
      id: id ?? '',
      badgeNo: map['badge_no'],
      name: map['name'],
      surname: map['surname'],
      patronymic: map['patronymic'],
      fullName: map['full_name'],
      initial: map['initial'],
      systemDesignation: map['system_designation'],
      jobTitle: map['job_title'],
      email: map['email'],
      company: map['company'],
      dateOfBirth: map['date_of_birth'].toDate(),
      homeAddress: map['home_address'],
      startDate: map['start_date'].toDate(),
      currentPlace: map['current_place'],
      contractFinishDate: map['contract_finish_date'].toDate(),
      contact: map['contact'],
      emergencyContact: map['emergency_contact'],
      emergencyContactName: map['emergency_contact_name'],
      note: map['note'],
    );
  }
}
