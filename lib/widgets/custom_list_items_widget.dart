import 'package:flutter/material.dart';

class CustomListItems extends StatelessWidget {
  final List<String> lst;
  final String lstName;

  const CustomListItems({
    Key? key,
    required this.lst,
    required this.lstName,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lstName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Text(
                    lst.length.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: lst.length,
              controller: ScrollController(),
              separatorBuilder: (context, index) => SizedBox(
                width: 4
              ),
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Text('${lst[index]}'),
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
