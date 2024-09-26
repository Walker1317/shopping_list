import 'package:flutter/material.dart';
import 'package:shopping_list/models/app_contents.dart';

class SelectIconData {

  Future<String?> pickIcon({required BuildContext context, required String title,
    required String currentItem, required List<String> items,
  }) async {
    String? result;
    await showDialog(
      context: context,
      builder: (context){
        return SelectIconDataWidget(
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

class SelectIconDataWidget extends StatefulWidget {
  const SelectIconDataWidget({super.key, required this.title, required this.currentItem,
  required this.items, required this.onChanged});
  final String title;
  final String currentItem;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  State<SelectIconDataWidget> createState() => _SelectIconDataWidgetState();
}

class _SelectIconDataWidgetState extends State<SelectIconDataWidget> {
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
              title: Icon(AppContents().iconFromString(e)),
            ),
          ],
        );
      }).toList(),
    );
  }
}