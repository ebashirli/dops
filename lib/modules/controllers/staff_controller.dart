import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/models/base_table_view_controller.dart';
import 'package:dops/modules/widgets/form_widgets/form_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/staff_model.dart';
import '../repositories/staff_repository.dart';

class StaffController extends BaseViewController {
  final GlobalKey<FormState> staffFormKey = GlobalKey<FormState>();
  final _repo = Get.find<StaffRepository>();
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
  RxBool _loading = true.obs;
  @override
  bool get loading => _loading.value;

  RxList<StaffModel> _documents = RxList<StaffModel>([]);
  List<StaffModel> get documents => _documents;

  Rx<StaffModel?> _currentStaff = Rx(cacheManager.getStaff);
  StaffModel? get currentStaff => _currentStaff.value;

  bool get isCoordinator => cacheManager.getStaff != null
      ? cacheManager.getStaff!.systemDesignation == 'Coordinator'
      : false;

  String? get currentUserId => auth.currentUser?.uid;

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

    _documents.bindStream(_repo.getAllDocumentsAsStream());
    _documents.listen((List<StaffModel?> staffModelList) {
      if (staffModelList.isNotEmpty) {
        _loading.value = false;
      }
    });
  }

  add({required StaffModel model}) async {
    CustomFullScreenDialog.showDialog();
    UserCredential? userCredential =
        await authManager.register(model.email, "123456");
    await _repo.addWithId(model, userCredential!.user!.uid);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  update({
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
    await _repo.updateModel(model, id);

    // ignore: unnecessary_null_comparison
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteStaff(String id) {
    _repo.removeModel(id);
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

    dateOfBirthController.text = model.dateOfBirth!.toDMYhmDash();

    startDateConroller.text = model.startDate!.toDMYhmDash();

    contractFinishDateController.text = model.contractFinishDate == null
        ? ''
        : model.contractFinishDate!.toDMYhmDash();

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

  @override
  buildAddForm({String? parentId}) {
    clearEditingControllers();
    homeController.getDialog(
      title: 'Add staff',
      content: StaffFormWidget(),
    );
  }

  @override
  buildUpdateForm({required String id}) {
    fillEditingControllers(id);
    homeController.getDialog(
      title: 'Update staff',
      content: StaffFormWidget(id: id),
    );
  }

  @override
  List<Map<String, dynamic>?> get tableData {
    return documents.map((staff) {
      Map<String, dynamic> staffMap = staff.toMap();
      Map<String, dynamic> map = {};
      homeController.mapPropNames.forEach((mapPropName) {
        switch (mapPropName) {
          case 'id':
            map[mapPropName] = staff.id!;
            break;
          case 'isHidden':
            break;
          case 'fullName':
            map[mapPropName] =
                '${staff.name} ${staff.surname} ${staff.patronymic}';
            break;
          case 'dateOfBirth':
          case 'startDate':
          case 'contractFinishDate':
            map[mapPropName] = staffMap[mapPropName] == null
                ? null
                : DateTime.parse(staffMap[mapPropName]).toDayMonthYear();
            break;
          default:
            map[mapPropName] = staffMap[mapPropName];
            break;
        }
      });

      return homeController.getTableMap(map);
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

  String? getCurrentStaffInitial() {
    return documents.isNotEmpty || currentStaff == null
        ? null
        : currentStaff!.initial;
  }

  StaffModel? getById(String? id) {
    return documents.singleWhereOrNull((staff) => staff.id == id);
  }

  String? getStaffInitialById(String id) => getById(id)?.initial;

  @override
  Color? getRowColor(DataGridRow row) => null;

  @override
  Widget getCellWidget(DataGridCell cell, String? taskId) =>
      Text('${cell.value}');
}
