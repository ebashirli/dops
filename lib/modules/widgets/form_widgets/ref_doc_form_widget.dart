import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/models/ref_doc_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RefDocAddUpdateFormWidget extends StatelessWidget {
  const RefDocAddUpdateFormWidget({Key? key, this.id}) : super(key: key);
  final String? id;

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
        key: refDocController.referenceDocumentFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          width: Get.width * 0.38,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomDropdownMenuWithModel<String>(
                          width: width,
                          labelText: 'Project',
                          selectedItems: [refDocController.projectText],
                          onChanged: (value) {
                            refDocController.projectText = value.toString();
                          },
                          itemAsString: (e) => e!,
                          items: listsController.document.projects!
                              .map((e) => e.toString())
                              .toList(),
                        ),
                        CustomDropdownMenuWithModel<String>(
                          width: width,
                          labelText: 'Module name',
                          selectedItems: [refDocController.moduleNameText],
                          onChanged: (value) {
                            refDocController.moduleNameText = value.toString();
                          },
                          itemAsString: (e) => e!,
                          items: listsController.document.modules!
                              .map((e) => e.toString())
                              .toList(),
                        ),
                        CustomDropdownMenuWithModel<String>(
                          width: width,
                          itemAsString: (e) => e!,
                          labelText: 'Reference Type',
                          selectedItems: [refDocController.referenceTypeText],
                          onChanged: (value) {
                            refDocController.referenceTypeText =
                                value.toString();
                          },
                          items: listsController.document.referenceTypes!
                              .map((e) => e.toString())
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: width * 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextFormField(
                                width: width * 1.4,
                                controller:
                                    refDocController.documentNumberController,
                                labelText: 'Document number',
                              ),
                              CustomTextFormField(
                                width: width * .55,
                                controller: refDocController
                                    .transmittalNumberController,
                                labelText: 'Transmittal number',
                              ),
                            ],
                          ),
                        ),
                        CustomTextFormField(
                          width: width * 2,
                          controller: refDocController.titleController,
                          labelText: 'Title',
                        ),
                        SizedBox(
                          width: width * 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomDateTimeFormField(
                                width: width * .715,
                                labelText: 'Received date',
                                initialValue:
                                    refDocController.receiveDateController.text,
                                controller:
                                    refDocController.receiveDateController,
                              ),
                              SizedBox(
                                width: width * 1.28,
                                child: Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () => refDocController
                                            .handleChangedRadio(false),
                                        child: Row(
                                          children: [
                                            Radio<bool>(
                                              value: false,
                                              groupValue: refDocController
                                                  .actionRequiredOrNext.value,
                                              onChanged: (bool? value) {
                                                refDocController
                                                    .actionRequiredOrNext
                                                    .value = value!;
                                              },
                                            ),
                                            const CustomText('Action Required'),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => refDocController
                                            .handleChangedRadio(true),
                                        child: Row(
                                          children: [
                                            Radio<bool>(
                                              value: true,
                                              groupValue: refDocController
                                                  .actionRequiredOrNext.value,
                                              onChanged: refDocController
                                                  .handleChangedRadio,
                                            ),
                                            const CustomText('Next')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                child: Row(
                  children: <Widget>[
                    if (id != null)
                      ElevatedButton.icon(
                        onPressed: () {
                          refDocController.deleteReferenceDocument(id!);
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
                        ReferenceDocumentModel model = ReferenceDocumentModel(
                          project: refDocController.projectText,
                          referenceType: refDocController.referenceTypeText,
                          moduleName: refDocController.moduleNameText,
                          documentNumber:
                              refDocController.documentNumberController.text,
                          title: refDocController.titleController.text,
                          transmittalNumber:
                              refDocController.transmittalNumberController.text,
                          receivedDate: DateFormat('y-M-d').parse(
                              refDocController.receiveDateController.text),
                          actionRequiredOrNext:
                              refDocController.actionRequiredOrNext.value,
                          assignedTasksCount: 0,
                        );
                        id == null
                            ? refDocController.add(model: model)
                            : refDocController.update(
                                model: model,
                                id: id!,
                              );
                      },
                      child: Text(id != null ? 'Update' : 'Add'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
