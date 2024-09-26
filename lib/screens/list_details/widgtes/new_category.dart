import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:shopping_list/models/shopping_list.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({super.key, required this.onCreated, required this.list, this.currentCategory});
  final ShoppingList list;
  final String? currentCategory;
  final ValueChanged<String> onCreated;

  @override
  State<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final _formKey = GlobalKey<FormState>();

  String? icon;
  final TextEditingController controllerName = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.currentCategory != null ?
    controllerName.text = widget.currentCategory! : null;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.currentCategory == null ? "new_category".i18n() : "edit_category".i18n()),
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
                  labelText: "category_name".i18n(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (text){
                  if(text!.isEmpty){
                    return "enter_category_name".i18n();
                  } else if(widget.list.categories!.contains(text)){
                    return "category_exists".i18n();
                  } else {
                    return null;
                  }
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30)
                ],
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      widget.onCreated.call(controllerName.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.currentCategory == null ? "create".i18n() :  "edit".i18n())
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}