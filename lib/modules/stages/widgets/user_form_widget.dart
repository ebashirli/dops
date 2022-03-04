import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UserFormWidget extends StatefulWidget {
  UserFormWidget({Key? key}) : super(key: key);

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final int index = stageController.lastIndex;

  List<String> get specialFieldNames =>
      stageDetailsList[index]['columns']..remove('File Names');

  late Map<String, TextEditingController> _textEditingControllers;
  late List<String> fileNames;
  late List<String> commentStatus;
  late bool isChecked;

  @override
  void initState() {
    super.initState();

    _textEditingControllers = Map.fromIterable(
      [...specialFieldNames, 'Note'],
      key: (element) => element,
      value: (element) => TextEditingController(),
    );

    fileNames = <String>[];

    commentStatus = ['', ''];
    isChecked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...specialFieldNames
              .map(
                (e) => CustomTextFormField(
                  labelText: e,
                  sizeBoxHeight: 0,
                  controller: _textEditingControllers[e],
                  isNumber: true,
                  width: 80,
                ),
              )
              .toList(),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);

                if (result != null) {
                  setState(() => fileNames =
                      result.files.map((file) => file.name).toList());
                }
              },
              child: Center(
                child: Text(
                  'Files (${fileNames.length})',
                ),
              ),
            ),
          ),
          if ([5, 6].contains(index))
            CustomDropdownMenu(
              bottomPadding: 0,
              sizeBoxHeight: 0,
              width: 110,
              onChanged: (value) =>
                  setState(() => commentStatus[index - 5] = value),
              selectedItems: [commentStatus[index - 5]],
              items: ['With', 'Without'],
            ),
          CustomTextFormField(
            labelText: 'Note',
            sizeBoxHeight: 0,
            controller: _textEditingControllers['Note'],
            width: 200,
            maxLines: 2,
          ),
          if (index == 7)
            Row(
              children: <Widget>[
                Checkbox(
                  checkColor: Colors.white,
                  value: true,
                  onChanged: (bool? value) =>
                      setState(() => isChecked = value!),
                ),
                Text(
                  'By clicking this checkbox I confirm that all files\nare attached correctly and below appropriate task',
                ),
              ],
            ),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () => stageController.onSubmitPressed(),
              child: Container(
                height: 20,
                child: Center(child: const Text('Submit')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
