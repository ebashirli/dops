import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/reference_document/reference_document_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddUpdateFormWidget extends StatelessWidget {
  const AddUpdateFormWidget({Key? key, this.id}) : super(key: key);
  final String? id;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          key: referenceDocumentController.referenceDocumentFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Container(
              width: Get.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropdownMenu(
                    labelText: 'Project',
                    selectedItems: [referenceDocumentController.projectText],
                    onChanged: (value) {
                      referenceDocumentController.projectText = value ?? '';
                    },
                    items: listsController.document.value.projects!,
                  ),
                  CustomDropdownMenu(
                    labelText: 'Module name',
                    selectedItems: [referenceDocumentController.moduleNameText],
                    onChanged: (value) {
                      referenceDocumentController.moduleNameText = value ?? '';
                    },
                    items: listsController.document.value.modules!,
                  ),
                  CustomDropdownMenu(
                    labelText: 'Reference Type',
                    selectedItems: [
                      referenceDocumentController.referenceTypeText
                    ],
                    onChanged: (value) {
                      referenceDocumentController.referenceTypeText =
                          value ?? '';
                    },
                    items: listsController.document.value.referenceTypes!,
                  ),
                  CustomTextFormField(
                    controller:
                        referenceDocumentController.documentNumberController,
                    labelText: 'Document number',
                  ),
                  CustomTextFormField(
                    controller: referenceDocumentController.titleController,
                    labelText: 'Title',
                  ),
                  CustomTextFormField(
                    controller:
                        referenceDocumentController.transmittalNumberController,
                    labelText: 'Transmittal number',
                  ),
                  Obx(() {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 400,
                          child: CustomDateTimeFormField(
                            labelText: 'Received date',
                            initialValue: referenceDocumentController
                                .receiveDateController.text,
                            controller: referenceDocumentController
                                .receiveDateController,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: GestureDetector(
                            onTap: () => referenceDocumentController
                                .handleChangedRadio(false),
                            child: ListTile(
                              title: const Text('Action Required'),
                              leading: Radio<bool>(
                                value: false,
                                groupValue: referenceDocumentController
                                    .actionRequiredOrNext.value,
                                onChanged: (bool? value) {
                                  referenceDocumentController
                                      .actionRequiredOrNext.value = value!;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: GestureDetector(
                            onTap: () => referenceDocumentController
                                .handleChangedRadio(true),
                            child: ListTile(
                              title: const Text('Next'),
                              leading: Radio<bool>(
                                value: true,
                                groupValue: referenceDocumentController
                                    .actionRequiredOrNext.value,
                                onChanged: referenceDocumentController
                                    .handleChangedRadio,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  Container(
                    child: Row(
                      children: <Widget>[
                        if (id != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              referenceDocumentController
                                  .deleteReferenceDocument(id!);
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
                            ReferenceDocumentModel model =
                                ReferenceDocumentModel(
                              project: referenceDocumentController.projectText,
                              referenceType:
                                  referenceDocumentController.referenceTypeText,
                              moduleName:
                                  referenceDocumentController.moduleNameText,
                              documentNumber: referenceDocumentController
                                  .documentNumberController.text,
                              title: referenceDocumentController
                                  .titleController.text,
                              transmittalNumber: referenceDocumentController
                                  .transmittalNumberController.text,
                              receivedDate: DateFormat('dd/MM/yyyy').parse(
                                  referenceDocumentController
                                      .receiveDateController.text),
                              actionRequiredOrNext: referenceDocumentController
                                  .actionRequiredOrNext.value,
                              assignedTasksCount: 0,
                            );
                            id == null
                                ? referenceDocumentController.saveDocument(
                                    model: model)
                                : referenceDocumentController.updateDocument(
                                    model: model, id: id!);
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
}
