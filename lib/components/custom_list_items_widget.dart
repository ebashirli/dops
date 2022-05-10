import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/list/lists_model.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class CustomListItems extends StatelessWidget {
  final List? lst;
  final String? lstName;

  CustomListItems({
    Key? key,
    this.lst,
    this.lstName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[400]!,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (lst != null || lstName != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    lstName!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black26),
                    ),
                    child: CustomText(
                      lst![0] == 'No Data' ? '0' : lst!.length.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          if (lst != null)
            lst![0] == 'No Data'
                ? Expanded(
                    child: Center(
                      child: const CustomText(
                        'No Data',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: lst!.length,
                      controller: ScrollController(),
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 10),
                        child: Card(
                          margin: EdgeInsets.only(bottom: 2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CustomText('${lst![index]}'),
                                ),
                                SizedBox(
                                    height: 20,
                                    child: GestureDetector(
                                      onTap: () {
                                        listsController.map =
                                            listsController.document.toMap();
                                        listsController.map[
                                                ReCase(lstName!).camelCase] =
                                            listsController
                                                .map[ReCase(lstName!).camelCase]
                                              ..remove(lst![index]);
                                        listsController.updateModel(
                                          ListsModel.fromMap(
                                            listsController.map,
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
