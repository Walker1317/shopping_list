import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class AppContents {

  List<String> currencySymbols(){
    return [
      "\$",
      "€",
      "£",
      "R\$",
      "¥",
    ];
  }

  String localeFromSymbol(String symbol){
    switch (symbol) {
      case "\$":
        return "en_US";
      case "€":
        return "es_ES";
      case "£":
        return "en_GB";
      case "R\$":
        return "pt_BR";
      case "¥":
        return "ja_JP";
      default:
        return "en_US";
    }
  }


  List<String> listIcons(){
    return [
      "home",
      "car",
      "calendar",
      "bicycle",
      "cart",
      "desktop",
      "game",
      "gift",
      "books",
      "school",
      "shirt",
      "store",
      "business",
      "ticket",
      "food",
      "airplane",
    ];
  }

  IconData iconFromString(String data){
    switch (data) {
      case "home":
        return Ionicons.home_outline;
      case "car":
        return Ionicons.car_sport_outline;
      case "calendar":
        return Ionicons.calendar_number_outline;
      case "bicycle":
        return Ionicons.bicycle_outline;
      case "desktop":
        return Ionicons.desktop_outline;
      case "game":
        return Ionicons.game_controller_outline;
      case "gift":
        return Ionicons.gift_outline;
      case "books":
        return Ionicons.library_outline;
      case "school":
        return Ionicons.school_outline;
      case "shirt":
        return Ionicons.shirt_outline;
      case "store":
        return Ionicons.storefront_outline;
      case "business":
        return Ionicons.business_outline;
      case "ticket":
        return Ionicons.ticket_outline;
      case "food":
        return Ionicons.fast_food_outline;
      case "airplane":
        return Ionicons.airplane_outline;
      default:
        return Ionicons.receipt_outline;
    }
  }


}