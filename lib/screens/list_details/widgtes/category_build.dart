import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localization/localization.dart';
import 'package:shopping_list/models/app_contents.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/screens/list_details/widgtes/new_category.dart';
import 'package:shopping_list/screens/list_details/widgtes/new_item.dart';

class CategoryBuild extends StatelessWidget {
  const CategoryBuild({super.key, required this.list, required this.category, required this.onChanged});
  final ShoppingList list;
  final String category;
  final ValueChanged<ShoppingList> onChanged;

  @override
  Widget build(BuildContext context) {
    final total = list.items!.where((element)=> element.category == category)
    .fold(0.0, (previousValue, element) => previousValue + element.price);
    final totalFormated = NumberFormat.currency(symbol: list.symbol, locale: AppContents().localeFromSymbol(list.symbol!)).format(total);
    final items = list.items!.where((element)=> element.category == category).toList();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          title: Row(
            children: [
              Expanded(child: Text(category, style: const TextStyle(fontWeight: FontWeight.bold),)),
              PopupMenuButton(
                itemBuilder: (context){
                  return [
                    PopupMenuItem(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (context){
                            return NewCategory(
                              onCreated: (value){
                                if(value != category){
                                  for(var item in items){
                                    final index = list.items!.indexOf(item);
                                    final newItem = item;
                                    newItem.category = value;
                                    list.items!.removeAt(index);
                                    list.items!.insert(index, newItem);
                                  }

                                  final index = list.categories!.indexOf(category);
                                  list.categories!.removeAt(index);
                                  list.categories!.insert(index, value);
                                  onChanged.call(list);
                                }
                              },
                              list: list,
                              currentCategory: category,
                            );
                          }
                        );
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(),
                        leading: const Icon(Ionicons.pencil_outline),
                        title: Text("edit".i18n()),
                      )
                    ),
                    PopupMenuItem(
                      onTap: (){
                        for(var item in items){
                          list.items!.remove(item);
                        }
                        final index = list.categories!.indexOf(category);
                        list.categories!.removeAt(index);
                        onChanged.call(list);
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(),
                        leading: const Icon(Ionicons.trash_bin_outline),
                        title: Text("delete".i18n()),
                      ),
                    ),
                  ];
                }
              ),
              Text(totalFormated),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context){
                      return NewItem(
                        onCreated: (value){
                          list.items!.add(value);
                          onChanged.call(list);
                        },
                        category: category,
                        list: list
                      );
                    }
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Ionicons.add_circle_outline),
                    const SizedBox(width: 10,),
                    Text("new_item".i18n()),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text("item_name".i18n(), style: const TextStyle(color: Colors.grey),)),
                  Expanded(child: Text("bought".i18n(), style: const TextStyle(color: Colors.grey),)),
                  Expanded(child: Text("amount".i18n(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey),)),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            ListView.builder(
              itemCount: items.length,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index){
                final item = items[index];
                final formated = NumberFormat.currency(symbol: list.symbol, locale: AppContents().localeFromSymbol(list.symbol!)).format(item.price);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                          Switch(
                            activeColor: Colors.greenAccent[700],
                            value: item.bought,
                            onChanged: (value){
                              final index = list.items!.indexOf(item);
                              final newItem = item;
                              newItem.bought = !newItem.bought;
                              list.items!.removeAt(index);
                              list.items!.insert(index, newItem);
                              onChanged.call(list);
                            },
                          ),
                          Flexible(child: Text(formated, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                          PopupMenuButton(
                            itemBuilder: (context){
                              return [
                                PopupMenuItem(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (context){
                                        return NewItem(
                                          onCreated: (value){
                                            final index = list.items!.indexOf(item);
                                            list.items!.removeAt(index);
                                            list.items!.insert(index, value);
                                            onChanged.call(list);
                                          },
                                          item: item,
                                          category: category,
                                          list: list
                                        );
                                      }
                                    );
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(),
                                    leading: const Icon(Ionicons.pencil_outline),
                                    title: Text("edit".i18n()),
                                  )
                                ),
                                PopupMenuItem(
                                  onTap: (){
                                    final index = list.items!.indexOf(item);
                                    list.items!.removeAt(index);
                                    onChanged.call(list);
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(),
                                    leading: const Icon(Ionicons.trash_bin_outline),
                                    title: Text("delete".i18n()),
                                  ),
                                ),
                              ];
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}