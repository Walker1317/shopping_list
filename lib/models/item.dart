import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Item {

  String title;
  String category;
  bool bought;
  num price;

  Item({
    required this.title,
    required this.category,
    required this.bought,
    required this.price,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'category': category,
      'bought': bought,
      'price': price,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      title: map['title'] as String,
      category: map['category'] as String,
      bought: map['bought'] as bool,
      price: map['price'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source) as Map<String, dynamic>);
}
