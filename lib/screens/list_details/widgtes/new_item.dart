import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:shopping_list/models/item.dart';
import 'package:shopping_list/models/shopping_list.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key, required this.onCreated, required this.category, required this.list, this.item});
  final ShoppingList list;
  final Item? item;
  final String category;
  final ValueChanged<Item> onCreated;

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  String? icon;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPrice = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.item != null){
      controllerName.text = widget.item!.title;
      controllerPrice.text = widget.item!.price.toString().replaceAll(".", ",");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.item == null ? "new_item".i18n() : "edit_item".i18n()),
      contentPadding: const EdgeInsets.all(10),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: controllerName,
                decoration: InputDecoration(
                  labelText: "item_name".i18n(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (text){
                  return text!.isEmpty ? "enter_item_name".i18n() : null;
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30)
                ],
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: controllerPrice,
                decoration: InputDecoration(
                  labelText: "amount".i18n(),
                  prefixText: widget.list.symbol,
                ),
                /*validator: (text){
                  return text!.isEmpty ? "enter_amount".i18n() : null;
                },*/
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(),
                ],
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      widget.onCreated.call(
                        Item(
                          title: controllerName.text,
                          category: widget.category,
                          bought: false,
                          price: controllerPrice.text.isEmpty ? 0 :
                          num.parse(
                            controllerPrice.text
                            .replaceAll(".", "")
                            .replaceAll(",", ".")
                          ),
                        ),
                      );
                      if(widget.item != null){
                        Navigator.pop(context);
                      } else {
                        controllerName.clear();
                        controllerPrice.clear();
                      }
                    }
                  },
                  child: Text(widget.item == null ? "create".i18n() :  "edit".i18n())
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}