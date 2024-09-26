import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/widgets/custom_appbar.dart';
import 'package:shopping_list/widgets/list_build.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ShoppingList> lists = [];
  SharedPreferences? prefs;
  bool loading = true;

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final instance = prefs!.getString("shopping_lists");
    if(instance != null){
      lists = jsonDecode(instance)["list"].map<ShoppingList>((e)=> ShoppingList.fromMap(e)).toList();
    } else {
      save();
    }
    setState(() {
      loading = false;
    });
  }

  save() async {
    await prefs!.setString(
      "shopping_lists",
      jsonEncode({
        "list" : lists.map((e) => e.toMap()).toList(),
      })
    );
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: "my_shopping_lists".i18n(),
        actions: [
          IconButton(
            onPressed: () async {
              final newList = await ShoppingList().createList(context);
              if(newList != null){
                setState(() {
                  lists.add(newList);
                  newList.save();
                });
              }
            },
            icon: const Icon(Ionicons.add_circle_outline, color: Colors.white, size: 30,)
          ),
        ],
      ),
      body: loading ?
      const Center(child: CircularProgressIndicator(),):
      lists.isEmpty ?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Ionicons.file_tray_stacked_outline, color: Colors.grey[300]!, size: 80,),
            const SizedBox(height: 20,),
            Text(
              "no_lists".i18n(),
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
                color: Colors.grey[300]
              ),
            ),
          ],
        ),
      ) :
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: lists.length,
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index){
              final list = lists[index];
              return ListBuild(
                list: list,
                onChanged: (value){
                  setState(() {
                    lists.removeAt(index);
                    lists.insert(index, value);
                    save();
                  });
                },
                onDelete: (value){
                  setState(() {
                    lists.removeAt(index);
                    save();
                  });
                },
              );
            }
          ),
        ),
      ),
    );
  }
}