import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:shopping_list/models/app_contents.dart';
import 'package:shopping_list/models/shopping_list.dart';

class BudgetResume extends StatelessWidget {
  const BudgetResume({super.key, required this.list});
  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    final total = list.items!.fold(0.0, (previousValue, element) => previousValue + element.price);
    final budget = list.budget;
    final bought = list.items!.where((element) => element.bought == true).fold(0.0, (previousValue, element) => previousValue + element.price);
    final totalFormated = NumberFormat.currency(symbol: list.symbol, locale: AppContents().localeFromSymbol(list.symbol!)).format(total);
    final budgetFormated = NumberFormat.currency(symbol: list.symbol, locale: AppContents().localeFromSymbol(list.symbol!)).format(budget);
    final boughtFormatted = NumberFormat.currency(symbol: list.symbol, locale: AppContents().localeFromSymbol(list.symbol!)).format(bought);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Total / ${"budget".i18n()}", style: const TextStyle(fontWeight: FontWeight.w300),),
            const SizedBox(height: 10,),
            Wrap(
              children: [
                Text(totalFormated, style: TextStyle(fontSize: 24, color: total < budget! ? Colors.greenAccent[700] : Colors.redAccent[700]),),
                const SizedBox(width: 20,),
                Text(budgetFormated, style: const TextStyle(fontSize: 24),),
              ],
            ),
            const SizedBox(height: 10,),
            const Text("Bought", style: TextStyle(fontWeight: FontWeight.w300),),
            const SizedBox(height: 10,),
            Text(boughtFormatted, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),),
          ],
        ),
      ),
    );
  }
}