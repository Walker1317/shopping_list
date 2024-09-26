import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localization/localization.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/screens/home_screen/widgets/create_list.dart';
import 'package:shopping_list/screens/list_details/widgtes/budget_resume.dart';
import 'package:shopping_list/screens/list_details/widgtes/category_build.dart';
import 'package:shopping_list/widgets/custom_appbar.dart';

class ListDetals extends StatefulWidget {
  const ListDetals({super.key, required this.list, required this.onChanged, required this.onDelete});
  final ShoppingList list;
  final ValueChanged<ShoppingList> onChanged;
  final ValueChanged onDelete;

  @override
  State<ListDetals> createState() => _ListDetalsState();
}

class _ListDetalsState extends State<ListDetals> {
  ShoppingList list = ShoppingList();

  @override
  void initState() {
    super.initState();
    list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: list.name!,
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (context){
              return [
                PopupMenuItem(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return CreateList(
                          onCreated: (value){
                            setState(() {
                              list = value;
                              widget.onChanged.call(value);
                            });
                          },
                          list: list,
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
                    widget.onDelete.call(null);
                    Navigator.pop(context);
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
        ]
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BudgetResume(list: list),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final newCategory = await list.createCategory(context);
                  if(newCategory != null){
                    setState(() {
                      list.categories!.add(newCategory);
                      widget.onChanged.call(list);
                      list.save();
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Ionicons.add_circle_outline),
                    const SizedBox(width: 10,),
                    Text("new_category".i18n()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            list.categories!.isEmpty ?
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Ionicons.file_tray_stacked_outline, color: Colors.grey[300]!, size: 80,),
                  const SizedBox(height: 20,),
                  Text(
                    "no_categories".i18n(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: Colors.grey[300]
                    ),
                  ),
                ],
              ),
            ) :
            ListView.builder(
              itemCount: list.categories!.length,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index){
                String category = list.categories![index];
                return CategoryBuild(list: list, category: category, onChanged: (value){
                  setState(() {
                    list = value;
                    list.save();
                  });
                  widget.onChanged.call(value);
                });
              }
            ),
          ],
        ),
      ),
    );
  }
}