import 'package:dops/constants/lists.dart';
import 'package:dops/models/staff_model.dart';
import 'package:dops/repositories/staff_repository.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:dops/constants/style.dart';
import 'package:dops/widgets/custom_widgets.dart';

class StaffController extends GetxController {
  final GlobalKey<FormState> staffFormKey = GlobalKey<FormState>();
  final _repository = Get.find<StaffRepository>();

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
  String currentPlaceText = '';
  String systemDesignationText = '';
  String jobTitleText = '';
  String companyText = '';

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
    emailController = TextEditingController();
    homeAddressController = TextEditingController();
    contactController = TextEditingController();
    emergencyContactController = TextEditingController();
    emergencyContactNameController = TextEditingController();
    noteController = TextEditingController();

    dateOfBirth = DateTime.now();
    startDate = DateTime.now();
    contractFinishDate = DateTime.now();

    _documents.bindStream(_repository.getAllEmployeesAsStream());
  }

  saveStaff({required StaffModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addStaffModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateStaff({
    required StaffModel model,
  }) async {
    final isValid = staffFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    staffFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repository.updateStaffModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteStaff(StaffModel data) {
    _repository.removeStaffModel(data);
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

  void fillEditingControllers(StaffModel model) {
    badgeNoController.text = model.badgeNo;
    nameController.text = model.name;
    surnameController.text = model.surname;
    patronymicController.text = model.patronymic;
    initialController.text = model.initial;
    emailController.text = model.email;
    homeAddressController.text = model.homeAddress;
    contactController.text = model.currentPlace;
    emergencyContactController.text = model.contact;
    emergencyContactNameController.text = model.emergencyContact;
    noteController.text = model.emergencyContactName;

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

  buildAddEdit({StaffModel? aModel}) {
    if (aModel != null) {
      fillEditingControllers(aModel);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: aModel == null ? 'Add staff' : 'Update staff',
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
                          CustomStringTextField(
                            controller: badgeNoController,
                            labelText: 'Badge No',
                          ),
                          CustomStringTextField(
                            controller: nameController,
                            labelText: 'Name',
                          ),
                          CustomStringTextField(
                            controller: surnameController,
                            labelText: 'Surname',
                          ),
                          CustomStringTextField(
                            controller: patronymicController,
                            labelText: 'Patronymic',
                          ),
                          CustomStringTextField(
                            controller: initialController,
                            labelText: 'Initial (Unique)',
                          ),
                          CustomDateTimeFormField(
                            labelText: 'Date of Birth',
                            initialValue: dateOfBirth,
                            onDateSelected: (date) => dateOfBirth = date,
                          ),
                          CustomDropdownMenu(
                            labelText: 'Company',
                            selectedItem: companyText,
                            onChanged: (value) {
                              companyText = value ?? '';
                            },
                            items: listsMap['Company']!,
                          ),
                          CustomDropdownMenu(
                            labelText: 'System Designation',
                            selectedItem: systemDesignationText,
                            onChanged: (value) {
                              systemDesignationText = value ?? '';
                            },
                            items: listsMap['System Designation']!,
                          ),
                          CustomDropdownMenu(
                            labelText: 'Job Title',
                            selectedItem: jobTitleText,
                            onChanged: (value) {
                              jobTitleText = value ?? '';
                            },
                            items: listsMap['Job Title']!,
                          ),
                          CustomDateTimeFormField(
                            labelText: 'Start Date',
                            initialValue: startDate,
                            onDateSelected: (date) => startDate = date,
                          ),
                          CustomStringTextField(
                            controller: emailController,
                            labelText: 'E-mail',
                          ),
                          CustomStringTextField(
                            controller: homeAddressController,
                            labelText: 'Home Address',
                          ),
                          CustomDropdownMenu(
                            labelText: 'Employee place',
                            selectedItem: currentPlaceText,
                            onChanged: (value) {
                              currentPlaceText = value ?? '';
                            },
                            items: listsMap['Employee place']!,
                          ),
                          CustomDateTimeFormField(
                            labelText: 'Contract Finish Date',
                            initialValue: contractFinishDate,
                            onDateSelected: (date) => contractFinishDate = date,
                          ),
                          CustomStringTextField(
                            controller: contactController,
                            labelText: 'Contact',
                          ),
                          CustomStringTextField(
                            controller: emergencyContactController,
                            labelText: 'Emergency Contact',
                          ),
                          CustomStringTextField(
                            controller: emergencyContactNameController,
                            labelText: 'Emergency Contact Name',
                          ),
                          CustomStringTextField(
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
                        if (aModel != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteStaff(aModel);
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
                              id: aModel != null ? aModel.id : null,
                              badgeNo: badgeNoController.text,
                              name: nameController.text,
                              surname: surnameController.text,
                              patronymic: patronymicController.text,
                              fullName:
                                  '${nameController.text} ${surnameController.text} ${patronymicController.text}',
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
                            aModel == null
                                ? saveStaff(model: model)
                                : updateStaff(model: model);
                          },
                          child: Text(
                            aModel != null ? 'Update' : 'Add',
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
    return _documents.map((document) {
      Map<String, dynamic> map = {};
      document.toMap().entries.forEach((entry) {
        switch (entry.key) {
          case 'isHidden':
            break;
          default:
            map[entry.key] = entry.value.toString();
        }
      });
      return map;
    }).toList();
  }
}
