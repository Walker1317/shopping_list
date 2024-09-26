import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:shopping_list/models/app_contents.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/screens/list_details/list_details.dart';

class ListBuild extends StatelessWidget {
  const ListBuild({super.key, required this.list, required this.onChanged, required this.onDelete});
  final ShoppingList list;
  final ValueChanged<ShoppingList> onChanged;
  final ValueChanged onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> showDialog(
        context: context,
        useSafeArea: false,
        builder: (_)=> ListDetals(
          list: list,
          onChanged: (value)=> onChanged.call(value),
          onDelete: (value)=> onDelete.call(value),
        )
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          ),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(list.name!, style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 24),),
          ),
          trailing: Icon(AppContents().iconFromString(list.icon!), color: Theme.of(context).primaryColor,),
          subtitle: Text("${list.categories!.length} ${"categories".i18n()}     ${list.items!.length} ${"items".i18n()}     ${NumberFormat.currency(symbol: list.symbol).format(list.items!.fold(0.0, (previousValue, element) => previousValue + element.price))}"),
        ),
      ),
    );
  }
}