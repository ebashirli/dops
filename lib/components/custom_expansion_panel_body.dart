import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class CustomExpansionPanelBody extends StatelessWidget {
  final int index;
  final List<List<GlobalKey<FormState>>> formKeyList;

  const CustomExpansionPanelBody({
    Key? key,
    required this.index,
    required this.formKeyList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          if (index <= 3)
            Form(
              key: formKeyList[index][0],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    labelText: '',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Assign'),
                    ),
                  ),
                ],
              ),
            ),
          Form(
            key: formKeyList[index][1],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  labelText: '',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
