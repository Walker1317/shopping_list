import 'package:flutter/material.dart';

class SelectStringValue {

  Future<String?> pickValue({required BuildContext context, required String title,
    required String currentItem, required List<String> items,
  }) async {
    String? result;
    await showDialog(
      context: context,
      builder: (context){
        return SelectStringValueWidget(
          title: title, 
          currentItem: currentItem,
          items: items,
          onChanged: (value){
            result = value;
          }
        );
      }
    );
    return result;
  }

}

class SelectStringValueWidget extends StatefulWidget {
  const SelectStringValueWidget({super.key, required this.title, required this.currentItem,
  required this.items, required this.onChanged});
  final String title;
  final String currentItem;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  State<SelectStringValueWidget> createState() => _SelectStringValueWidgetState();
}

class _SelectStringValueWidgetState extends State<SelectStringValueWidget> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: widget.items.map<Widget>((e){
        return Column(
          children: [
            const Divider(),
            ListTile(
              selected: widget.currentItem == e,
              onTap: (){
                widget.onChanged.call(e);
                Navigator.pop(context);
              },
              title: Text(e),
            )
          ],
        );
      }).toList(),
    );
  }
}