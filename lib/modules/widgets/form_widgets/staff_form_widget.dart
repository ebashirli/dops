import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/models/staff_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffFormWidget extends StatelessWidget {
  final String? id;
  const StaffFormWidget({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = Get.width * .4 * .3;
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
              SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextFormField(
                            width: width,
                            controller: staffController.nameController,
                            labelText: 'Name',
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.surnameController,
                            labelText: 'Surname',
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.patronymicController,
                            labelText: 'Patronymic',
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.initialController,
                            labelText: 'Initial',
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
                    ),
                    SizedBox(
                      height: 240,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomDropdownMenuWithModel<String>(
                            itemAsString: (e) => e!,
                            width: width,
                            labelText: 'Company',
                            selectedItems: [staffController.companyText],
                            onChanged: (value) =>
                                staffController.companyText = value.first!,
                            items: listsController.document.companies!
                                .map((e) => e.toString())
                                .toList(),
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.badgeNoController,
                            labelText: 'Badge No',
                          ),
                          CustomDropdownMenuWithModel<String>(
                            width: width,
                            labelText: 'System Designation',
                            itemAsString: (e) => e!,
                            selectedItems: [
                              staffController.systemDesignationText
                            ],
                            onChanged: (value) => staffController
                                .systemDesignationText = value.first.toString(),
                            items: listsController.document.systemDesignations!
                                .map((e) => e.toString())
                                .toList(),
                          ),
                          CustomDropdownMenuWithModel<String>(
                            itemAsString: (e) => e!,
                            width: width,
                            labelText: 'Job Title',
                            selectedItems: [staffController.jobTitleText],
                            onChanged: (value) =>
                                staffController.jobTitleText = value.first!,
                            items: listsController.document.jobTitles!
                                .map((e) => e.toString())
                                .toList(),
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
                    ),
                    SizedBox(
                      height: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextFormField(
                            width: width,
                            controller: staffController.emailController,
                            labelText: 'E-mail',
                            validator: (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a valid email",
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.contactController,
                            labelText: 'Contact',
                            validator: staffController.validateMobile,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller:
                                staffController.emergencyContactController,
                            labelText: 'Emergency Contact',
                            validator: staffController.validateMobile,
                          ),
                          CustomTextFormField(
                            width: width,
                            controller:
                                staffController.emergencyContactNameController,
                            labelText: 'Emergency Contact Name',
                          ),
                          CustomTextFormField(
                            width: width,
                            controller: staffController.homeAddressController,
                            labelText: 'Home Address',
                          ),
                          CustomDropdownMenuWithModel<String>(
                            itemAsString: (e) => e!,
                            width: width,
                            labelText: 'Current place',
                            selectedItems: [staffController.currentPlaceText],
                            onChanged: (value) =>
                                staffController.currentPlaceText = value.first!,
                            items: listsController.document.employeePlaces!
                                .map((e) => e.toString())
                                .toList(),
                          ),
                          CustomTextFormField(
                            width: width,
                            maxLines: 3,
                            controller: staffController.noteController,
                            labelText: 'Note',
                          ),
                        ],
                      ),
                    ),
                  ],
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
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
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
                        contractFinishDate: staffController
                                .contractFinishDateController.text.isEmpty
                            ? null
                            : DateTime.parse(staffController
                                .contractFinishDateController.text),
                        contact: staffController.contactController.text,
                        emergencyContact:
                            staffController.emergencyContactController.text,
                        emergencyContactName:
                            staffController.emergencyContactNameController.text,
                        note: staffController.noteController.text,
                      );
                      id == null
                          ? staffController.add(model: model)
                          : staffController.update(
                              model: model,
                              id: id!,
                            );
                    },
                    child: Text(id != null ? 'Update' : 'Add'),
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
