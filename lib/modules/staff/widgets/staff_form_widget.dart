import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffFormWidget extends StatelessWidget {
  final String? id;
  const StaffFormWidget({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
        color: light,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: staffController.staffFormKey,
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
                          controller: staffController.badgeNoController,
                          labelText: 'Badge No',
                        ),
                        CustomTextFormField(
                          controller: staffController.nameController,
                          labelText: 'Name',
                        ),
                        CustomTextFormField(
                          controller: staffController.surnameController,
                          labelText: 'Surname',
                        ),
                        CustomTextFormField(
                          controller: staffController.patronymicController,
                          labelText: 'Patronymic',
                        ),
                        CustomTextFormField(
                          controller: staffController.initialController,
                          labelText: 'Initial',
                        ),
                        CustomDateTimeFormField(
                          labelText: 'Date of Birth',
                          initialValue:
                              staffController.dateOfBirthController.text,
                          controller: staffController.dateOfBirthController,
                        ),
                        CustomDropdownMenu(
                          labelText: 'Company',
                          selectedItems: [staffController.companyText],
                          onChanged: (value) =>
                              staffController.companyText = value ?? '',
                          items: listsController.document.value.companies!,
                        ),
                        CustomDropdownMenu(
                          labelText: 'System Designation',
                          selectedItems: [
                            staffController.systemDesignationText
                          ],
                          onChanged: (value) {
                            staffController.systemDesignationText = value ?? '';
                          },
                          items: listsController
                              .document.value.systemDesignations!,
                        ),
                        CustomDropdownMenu(
                          labelText: 'Job Title',
                          selectedItems: [staffController.jobTitleText],
                          onChanged: (value) {
                            staffController.jobTitleText = value ?? '';
                          },
                          items: listsController.document.value.jobTitles!,
                        ),
                        CustomDateTimeFormField(
                          labelText: 'Start Date',
                          initialValue: staffController.startDateConroller.text,
                          controller: staffController.startDateConroller,
                        ),
                        CustomTextFormField(
                          controller: staffController.emailController,
                          labelText: 'E-mail',
                          validator: (value) => EmailValidator.validate(value!)
                              ? null
                              : "Please enter a valid email",
                        ),
                        CustomTextFormField(
                          controller: staffController.homeAddressController,
                          labelText: 'Home Address',
                        ),
                        CustomDropdownMenu(
                          labelText: 'Current place',
                          selectedItems: [staffController.currentPlaceText],
                          onChanged: (value) {
                            staffController.currentPlaceText = value ?? '';
                          },
                          items: listsController.document.value.employeePlaces!,
                        ),
                        CustomDateTimeFormField(
                          labelText: 'Contract Finish Date',
                          initialValue:
                              staffController.contractFinishDateController.text,
                          controller:
                              staffController.contractFinishDateController,
                        ),
                        CustomTextFormField(
                          controller: staffController.contactController,
                          labelText: 'Contact',
                          validator: staffController.validateMobile,
                        ),
                        CustomTextFormField(
                          controller:
                              staffController.emergencyContactController,
                          labelText: 'Emergency Contact',
                          validator: staffController.validateMobile,
                        ),
                        CustomTextFormField(
                          controller:
                              staffController.emergencyContactNameController,
                          labelText: 'Emergency Contact Name',
                        ),
                        CustomTextFormField(
                          controller: staffController.noteController,
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
                            staffController.deleteStaff(id!);
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
                            badgeNo: staffController.badgeNoController.text,
                            name: staffController.nameController.text,
                            surname: staffController.surnameController.text,
                            patronymic:
                                staffController.patronymicController.text,
                            initial: staffController.initialController.text,
                            systemDesignation:
                                staffController.systemDesignationText,
                            jobTitle: staffController.jobTitleText,
                            email: staffController.emailController.text,
                            company: staffController.companyText,
                            dateOfBirth: DateTime.parse(
                                staffController.dateOfBirthController.text),
                            homeAddress:
                                staffController.homeAddressController.text,
                            startDate: DateTime.parse(
                                staffController.startDateConroller.text),
                            currentPlace: staffController.currentPlaceText,
                            contractFinishDate: DateTime.parse(staffController
                                .contractFinishDateController.text),
                            contact: staffController.contactController.text,
                            emergencyContact:
                                staffController.emergencyContactController.text,
                            emergencyContactName: staffController
                                .emergencyContactNameController.text,
                            note: staffController.noteController.text,
                          );
                          id == null
                              ? staffController.saveDocument(model: model)
                              : staffController.updateDocument(
                                  model: model,
                                  id: id!,
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
    );
  }
}
