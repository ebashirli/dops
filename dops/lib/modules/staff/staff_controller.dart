import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_date_time_form_field_widget.dart';
import '../../components/custom_dropdown_menu_widget.dart';
import '../../components/custom_full_screen_dialog_widget.dart';
import '../../components/custom_snackbar_widget.dart';
import '../../components/custom_text_form_field_widget.dart';
import '../../constants/style.dart';
import 'staff_model.dart';
import 'staff_repository.dart';

class StaffController extends GetxController {
  final GlobalKey<FormState> staffFormKey = GlobalKey<FormState>();
  final _repository = Get.find<StaffRepository>();
  late final dropdownSourcesController = Get.find<DropdownSourcesController>();

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
      noteController;
  late DateTime dateOfBirth, startDate, contractFinishDate;
  late String currentPlaceText,
      systemDesignationText,
      jobTitleText,
      companyText;

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  RxList<StaffModel> _documents = RxList<StaffModel>([]);
  List<StaffModel> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    badgeNoController = TextEditingController();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    patronymicController = TextEditingController();
    initialController = TextEditingController();
    dateOfBirth = DateTime.now();
    companyText = '';
    systemDesignationText = '';
    jobTitleText = '';
    emailController = TextEditingController();
    homeAddressController = TextEditingController();
    currentPlaceText = '';
    contractFinishDate = DateTime.now();
    startDate = DateTime.now();
    contactController = TextEditingController();
    emergencyContactController = TextEditingController();
    emergencyContactNameController = TextEditingController();
    noteController = TextEditingController();

    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  saveDocument({required StaffModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addModel(model);
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

    dateOfBirth = DateTime.now();
    startDate = DateTime.now();
    contractFinishDate = DateTime.now();

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

    dateOfBirth = model.dateOfBirth;
    startDate = model.startDate;
    contractFinishDate = model.contractFinishDate;

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

  buildAddEdit({String? id, bool? newRev = false}) {
    if (id != null) {
      fillEditingControllers(id);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: id == null ? 'Add staff' : 'Update staff',
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
          color: light, //Color(0xff1E2746),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: staffFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              width: Get.width * .5,
              child: Column(
                children: [
                  Container(
                    height: 540,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          CustomTextFormField(
                            controller: badgeNoController,
                            labelText: 'Badge No',
                          ),
                          CustomTextFormField(
                            controller: nameController,
                            labelText: 'Name',
                          ),
                          CustomTextFormField(
                            controller: surnameController,
                            labelText: 'Surname',
                          ),
                          CustomTextFormField(
                            controller: patronymicController,
                            labelText: 'Patronymic',
                          ),
                          CustomTextFormField(
                            controller: initialController,
                            labelText: 'Initial',
                          ),
                          CustomDateTimeFormField(
                            labelText: 'Date of Birth',
                            initialValue: dateOfBirth,
                            onDateSelected: (date) => dateOfBirth = date,
                          ),
                          CustomDropdownMenu(
                            labelText: 'Company',
                            selectedItems: [companyText],
                            onChanged: (value) {
                              companyText = value ?? '';
                            },
                            items: dropdownSourcesController
                                .document.value.companies!,
                          ),
                          CustomDropdownMenu(
                            labelText: 'System Designation',
                            selectedItems: [systemDesignationText],
                            onChanged: (value) {
                              systemDesignationText = value ?? '';
                            },
                            items: dropdownSourcesController
                                .document.value.systemDesignations!,
                          ),
                          CustomDropdownMenu(
                            labelText: 'Job Title',
                            selectedItems: [jobTitleText],
                            onChanged: (value) {
                              jobTitleText = value ?? '';
                            },
                            items: dropdownSourcesController
                                .document.value.jobTitles!,
                          ),
                          CustomDateTimeFormField(
                            labelText: 'Start Date',
                            initialValue: startDate,
                            onDateSelected: (date) => startDate = date,
                          ),
                          CustomTextFormField(
                            controller: emailController,
                            labelText: 'E-mail',
                            validator: (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a valid email",
                          ),
                          CustomTextFormField(
                            controller: homeAddressController,
                            labelText: 'Home Address',
                          ),
                          CustomDropdownMenu(
                            labelText: 'Current place',
                            selectedItems: [currentPlaceText],
                            onChanged: (value) {
                              currentPlaceText = value ?? '';
                            },
                            items: dropdownSourcesController
                                .document.value.employeePlaces!,
                          ),
                          CustomDateTimeFormField(
                            labelText: 'Contract Finish Date',
                            initialValue: contractFinishDate,
                            onDateSelected: (date) => contractFinishDate = date,
                          ),
                          CustomTextFormField(
                            controller: contactController,
                            labelText: 'Contact',
                            validator: validateMobile,
                          ),
                          CustomTextFormField(
                            controller: emergencyContactController,
                            labelText: 'Emergency Contact',
                            validator: validateMobile,
                          ),
                          CustomTextFormField(
                            controller: emergencyContactNameController,
                            labelText: 'Emergency Contact Name',
                          ),
                          CustomTextFormField(
                            controller: noteController,
                            labelText: 'Note',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: <Widget>[
                        if (id != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteStaff(id);
                              Get.back();
                            },
                            icon: Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red,
                              ),
                            ),
                          ),
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel')),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            StaffModel model = StaffModel(
                              badgeNo: badgeNoController.text,
                              name: nameController.text,
                              surname: surnameController.text,
                              patronymic: patronymicController.text,
                              initial: initialController.text,
                              systemDesignation: systemDesignationText,
                              jobTitle: jobTitleText,
                              email: emailController.text,
                              company: companyText,
                              dateOfBirth: dateOfBirth,
                              homeAddress: homeAddressController.text,
                              startDate: startDate,
                              currentPlace: currentPlaceText,
                              contractFinishDate: contractFinishDate,
                              contact: contactController.text,
                              emergencyContact: emergencyContactController.text,
                              emergencyContactName:
                                  emergencyContactNameController.text,
                              note: noteController.text,
                            );
                            id == null
                                ? saveDocument(model: model)
                                : updateDocument(
                                    model: model,
                                    id: id,
                                  );
                          },
                          child: Text(
                            id != null ? 'Update' : 'Add',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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
}