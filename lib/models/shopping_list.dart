// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shopping_list/models/item.dart';
import 'package:shopping_list/screens/home_screen/widgets/create_list.dart';
import 'package:shopping_list/screens/list_details/widgtes/new_category.dart';

class ShoppingList {

  String? id;
  String? name;
  String? symbol;
  num? budget;
  String? icon;
  List<String>? categories;
  List<Item>? items;
  
  ShoppingList({
    this.id,
    this.name,
    this.symbol,
    this.budget,
    this.icon,
    this.categories,
    this.items,
  });

  Future<ShoppingList?> createList(BuildContext context) async {
    ShoppingList? newList;
    await showDialog(
      context: context,
      builder: (context){
        return CreateList(
          onCreated: (value){
            newList = value;
          }
        );
      }
    );
    return newList;
  }

  Future<String?> createCategory(BuildContext context) async {
    String? newCategory;
    await showDialog(
      context: context,
      builder: (context){
        return NewCategory(
          list: this,
          onCreated: (value){
            newCategory = value;
          }
        );
      }
    );
    return newCategory;
  }

  Future save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final instance = prefs.getString("shopping_lists");
    List<ShoppingList> lists = jsonDecode(instance!)["list"].map<ShoppingList>((e)=> ShoppingList.fromMap(e)).toList();
    final index = lists.indexWhere((element) => element.id == id);
    if(index.isNegative){
      lists.add(this);
    } else {
      lists.removeAt(index);
      lists.insert(index, this);
    }
    await prefs.setString(
      "shopping_lists",
      jsonEncode({
        "list" : lists.map((e) => e.toMap()).toList(),
      })
    );
  }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id" : id,
      'name': name,
      'symbol': symbol,
      'budget': budget,
      'icon': icon,
      'categories': categories,
      'items': items!.map((x) => x.toMap()).toList(),
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      symbol: map['symbol'] != null ? map['symbol'] as String : null,
      budget: map['budget'] != null ? map['budget'] as num : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
      categories: map['categories'] != null ? map['categories'].map<String>((e)=> e.toString()).toList() as List<String> : null,
      items: map['items'] != null ? map['items'].map<Item>((e)=> Item.fromMap(e)).toList() as List<Item> : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingList.fromJson(String source) => ShoppingList.fromMap(json.decode(source) as Map<String, dynamic>);
}
