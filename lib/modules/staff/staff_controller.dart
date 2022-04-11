import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/core/cache_manager.dart';
import 'package:dops/modules/staff/widgets/staff_form_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

import 'staff_model.dart';
import 'staff_repository.dart';

class StaffController extends GetxService with CacheManager {
  final GlobalKey<FormState> staffFormKey = GlobalKey<FormState>();
  final _repository = Get.find<StaffRepository>();
  static StaffController instance = Get.find();

  late TextEditingController badgeNoController,
      nameController,
      surnameController,
      patronymicController,
      initialController,
      emailController,
      homeAddressController,
      contactController,
      emergencyContactController,
      emergencyContactNameController,
      noteController,
      dateOfBirthController,
      startDateConroller,
      contractFinishDateController;

  late String currentPlaceText,
      systemDesignationText,
      jobTitleText,
      companyText;

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;
  RxBool loading = true.obs;

  RxList<StaffModel> _documents = RxList<StaffModel>([]);
  List<StaffModel> get documents => _documents;

  bool get isCoordinator => getStaff() != null
      ? getStaff()!.systemDesignation == 'Coordinator'
      : false;

  String get currentUserId => auth.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    badgeNoController = TextEditingController();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    patronymicController = TextEditingController();
    initialController = TextEditingController();
    dateOfBirthController = TextEditingController();
    companyText = '';
    systemDesignationText = '';
    jobTitleText = '';
    emailController = TextEditingController();
    homeAddressController = TextEditingController();
    currentPlaceText = '';
    contractFinishDateController = TextEditingController();
    startDateConroller = TextEditingController();
    contactController = TextEditingController();
    emergencyContactController = TextEditingController();
    emergencyContactNameController = TextEditingController();
    noteController = TextEditingController();

    _documents.bindStream(_repository.getAllDocumentsAsStream());
    _documents.listen((List<StaffModel?> issueModelList) {
      if (issueModelList.isNotEmpty) loading.value = false;
    });
  }

  saveDocument({required StaffModel model}) async {
    CustomFullScreenDialog.showDialog();
    UserCredential? userCredential =
        await authManager.register(model.email, "123456");
    await _repository.addModelWithId(model, userCredential!.user!.uid);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateDocument({
    required StaffModel model,
    required String id,
  }) async {
    final isValid = staffFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    staffFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repository.updateModel(model, id);

    // ignore: unnecessary_null_comparison
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteStaff(String id) {
    _repository.removeModel(id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    badgeNoController.clear();
    nameController.clear();
    surnameController.clear();
    patronymicController.clear();
    initialController.clear();
    emailController.clear();
    homeAddressController.clear();
    contactController.clear();
    emergencyContactController.clear();
    emergencyContactNameController.clear();
    noteController.clear();

    dateOfBirthController.clear();
    startDateConroller.clear();
    contractFinishDateController.clear();

    currentPlaceText = '';
    systemDesignationText = '';
    jobTitleText = '';
    companyText = '';
  }

  void fillEditingControllers(String id) {
    final StaffModel model =
        documents.where((document) => document.id == id).toList()[0];

    badgeNoController.text = model.badgeNo;
    nameController.text = model.name;
    surnameController.text = model.surname;
    patronymicController.text = model.patronymic;
    initialController.text = model.initial;
    emailController.text = model.email;
    homeAddressController.text = model.homeAddress;
    contactController.text = model.contact;
    emergencyContactController.text = model.emergencyContact;
    emergencyContactNameController.text = model.emergencyContactName;
    noteController.text = model.note;

    dateOfBirthController.text = model.dateOfBirth!.toDMYhm();

    startDateConroller.text = model.startDate!.toDMYhm();

    contractFinishDateController.text = model.contractFinishDate!.toDMYhm();

    currentPlaceText = model.currentPlace;
    systemDesignationText = model.systemDesignation;
    jobTitleText = model.jobTitle;
    companyText = model.company;
  }

  whenCompleted() {
    CustomFullScreenDialog.cancelDialog();
    clearEditingControllers();
    Get.back();
  }

  catchError(FirebaseException error) {
    {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
        context: Get.context,
        title: "Error",
        message: "${error.message.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  buildAddForm({String? id}) {
    clearEditingControllers();
    getForm(title: 'Add staff');
  }

  buildUpdateForm({required String id}) {
    fillEditingControllers(id);
    getForm(title: 'Update staff', id: id);
  }

  getForm({required String title, String? id}) {
    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: title,
      content: StaffFormWidget(id: id),
    );
  }

  List<Map<String, dynamic>> get getDataForTableView {
    List<String> mapPropNames = mapPropNamesGetter('staff');

    return documents.map((staffMember) {
      Map<String, dynamic> map = {};
      mapPropNames.forEach((mapPropName) {
        switch (mapPropName) {
          case 'id':
            map[mapPropName] = staffMember.id!;
            break;
          case 'isHidden':
            break;
          case 'fullName':
            map[mapPropName] =
                '${staffMember.name} ${staffMember.surname} ${staffMember.patronymic}';
            break;
          default:
            map[mapPropName] = staffMember.toMap()[mapPropName];
            break;
        }
      });

      return map;
    }).toList();
  }

  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
    RegExp regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    } else if (contactController.text == emergencyContactController.text) {
      return 'Contact and emergency contact cannot be same';
    }
    return null;
  }

  StaffModel? get currentStaff {
    User? currentUser = auth.currentUser;
    return currentUser == null ? null : getById(currentUser.uid);
  }

  String? getCurrentStaffInitial() {
    return documents.isNotEmpty || currentStaff == null
        ? null
        : currentStaff!.initial;
  }

  StaffModel? getById(String id) {
    return loading.value || documents.isEmpty
        ? null
        : documents.singleWhereOrNull((staff) => staff.id == id);
  }

  String? getStaffInitialById(String id) {
    StaffModel? staffModel = getById(id);

    return staffModel == null ? null : staffModel.initial;
  }
}
