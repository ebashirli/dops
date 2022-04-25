import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffFormWidget extends StatelessWidget {
  final String? id;
  const StaffFormWidget({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = Get.width * .4 * .3;
    final double sizeBoxHeight = Get.width * .01;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: Form(
        key: staffController.staffFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          width: Get.width * .4,
          child: Column(
            children: [
              SizedBox(
                height: Get.height * .425,
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 10),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.nameController,
                            labelText: 'Name',
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.surnameController,
                            labelText: 'Surname',
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.patronymicController,
                            labelText: 'Patronymic',
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.initialController,
                            labelText: 'Initial',
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomDateTimeFormField(
                            width: width,
                            labelText: 'Date of Birth',
                            initialValue:
                                staffController.dateOfBirthController.text,
                            controller: staffController.dateOfBirthController,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(height: 10),
                          CustomDropdownMenu(
                            width: width,
                            labelText: 'Company',
                            selectedItems: [staffController.companyText],
                            onChanged: (value) =>
                                staffController.companyText = value ?? '',
                            items: listsController.document.value.companies!,
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.badgeNoController,
                            labelText: 'Badge No',
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomDropdownMenu(
                            width: width,
                            labelText: 'System Designation',
                            selectedItems: [
                              staffController.systemDesignationText
                            ],
                            onChanged: (value) {
                              staffController.systemDesignationText =
                                  value ?? '';
                            },
                            items: listsController
                                .document.value.systemDesignations!,
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomDropdownMenu(
                            width: width,
                            labelText: 'Job Title',
                            selectedItems: [staffController.jobTitleText],
                            onChanged: (value) {
                              staffController.jobTitleText = value ?? '';
                            },
                            items: listsController.document.value.jobTitles!,
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomDateTimeFormField(
                            width: width,
                            labelText: 'Start Date',
                            initialValue:
                                staffController.startDateConroller.text,
                            controller: staffController.startDateConroller,
                          ),
                          CustomDateTimeFormField(
                            width: width,
                            labelText: 'Contract Finish Date',
                            initialValue: staffController
                                .contractFinishDateController.text,
                            controller:
                                staffController.contractFinishDateController,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 10),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.emailController,
                            labelText: 'E-mail',
                            validator: (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a valid email",
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.contactController,
                            labelText: 'Contact',
                            validator: staffController.validateMobile,
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller:
                                staffController.emergencyContactController,
                            labelText: 'Emergency Contact',
                            validator: staffController.validateMobile,
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller:
                                staffController.emergencyContactNameController,
                            labelText: 'Emergency Contact Name',
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.homeAddressController,
                            labelText: 'Home Address',
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomDropdownMenu(
                            width: width,
                            labelText: 'Current place',
                            selectedItems: [staffController.currentPlaceText],
                            onChanged: (value) {
                              staffController.currentPlaceText = value ?? '';
                            },
                            items:
                                listsController.document.value.employeePlaces!,
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                          CustomTextFormField(
                            width: width,
                            maxLines: 3,
                            controller: staffController.noteController,
                            labelText: 'Note',
                            sizeBoxHeight: sizeBoxHeight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
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
                      onPressed: () => Get.back(), child: const Text('Cancel')),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      StaffModel model = StaffModel(
                        badgeNo: staffController.badgeNoController.text,
                        name: staffController.nameController.text,
                        surname: staffController.surnameController.text,
                        patronymic: staffController.patronymicController.text,
                        initial: staffController.initialController.text,
                        systemDesignation:
                            staffController.systemDesignationText,
                        jobTitle: staffController.jobTitleText,
                        email: staffController.emailController.text,
                        company: staffController.companyText,
                        dateOfBirth: DateTime.parse(
                          staffController.dateOfBirthController.text,
                        ),
                        homeAddress: staffController.homeAddressController.text,
                        startDate: DateTime.parse(
                            staffController.startDateConroller.text),
                        currentPlace: staffController.currentPlaceText,
                        contractFinishDate: DateTime.parse(
                            staffController.contractFinishDateController.text),
                        contact: staffController.contactController.text,
                        emergencyContact:
                            staffController.emergencyContactController.text,
                        emergencyContactName:
                            staffController.emergencyContactNameController.text,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
