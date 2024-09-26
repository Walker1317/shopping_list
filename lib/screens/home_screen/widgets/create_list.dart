import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:shopping_list/models/app_contents.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/widgets/select_icon_data.dart';
import 'package:shopping_list/widgets/select_string_value.dart';

class CreateList extends StatefulWidget {
  const CreateList({super.key, required this.onCreated, this.list});
  final ShoppingList? list;
  final ValueChanged<ShoppingList> onCreated;

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  final _formKey = GlobalKey<FormState>();

  String? icon;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerSymbol = TextEditingController();
  final TextEditingController controllerBudget = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerSymbol.text = "\$";
    if(widget.list != null){
      controllerName.text = widget.list!.name!;
      controllerSymbol.text = widget.list!.symbol!;
      controllerBudget.text = widget.list!.budget!.toString().replaceAll(".", ",");
      icon = widget.list!.icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.list == null ? "new_list".i18n() : "edit_list".i18n()),
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
                  labelText: "list_name".i18n(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (text){
                  return text!.isEmpty ? "enter_list_name".i18n() : null;
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30)
                ],
              ),
              const SizedBox(height: 10,),
              TextFormField(
                readOnly: true,
                onTap: () async {
                  final result = await SelectStringValue().pickValue(
                    context: context,
                    title: "select_currency".i18n(),
                    currentItem: controllerSymbol.text,
                    items: AppContents().currencySymbols()
                  );
                  if(result != null){
                    setState(() {
                      controllerSymbol.text = result;
                    });
                  }
                },
                controller: controllerSymbol,
                decoration: InputDecoration(
                  labelText: "currency".i18n(),
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: controllerBudget,
                decoration: InputDecoration(
                  labelText: "budget".i18n(),
                  prefixText: controllerSymbol.text
                ),
                validator: (text){
                  return text!.isEmpty ? "enter_budget".i18n() : null;
                },
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(),
                ],
              ),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "icon".i18n(),
                  hintText: "touch_to_select".i18n(),
                  suffixIcon: icon == null ? null :
                  Icon(AppContents().iconFromString(icon!))
                ),
                readOnly: true,
                validator: (text){
                  return icon == null ? "select_icon".i18n() : null;
                },
                onTap: () async {
                  final result = await SelectIconData().pickIcon(
                    context: context,
                    title: "select_icon".i18n(),
                    currentItem: icon ?? '',
                    items: AppContents().listIcons()
                  );
                  if(result != null){
                    setState(() {
                      icon = result;
                    });
                  }
                },
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      if(widget.list == null){
                        widget.onCreated.call(
                          ShoppingList(
                            id: DateTime.now().microsecondsSinceEpoch.toString(),
                            name: controllerName.text,
                            symbol: controllerSymbol.text,
                            budget: num.parse(
                              controllerBudget.text
                              .replaceAll(".", "")
                              .replaceAll(",", ".")
                            ),
                            icon: icon,
                            categories: [],
                            items: [],
                          ),
                        );
                      } else {
                        widget.onCreated.call(
                          ShoppingList(
                            id: DateTime.now().microsecondsSinceEpoch.toString(),
                            name: controllerName.text,
                            symbol: controllerSymbol.text,
                            budget: num.parse(
                              controllerBudget.text
                              .replaceAll(".", "")
                              .replaceAll(",", ".")
                            ),
                            icon: icon,
                            categories: widget.list!.categories,
                            items: widget.list!.items,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.list == null ? "create".i18n() :  "edit".i18n())
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}