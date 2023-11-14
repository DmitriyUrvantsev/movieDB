import 'package:flutter/material.dart';

class Constants {
  static const inputDecorationForm = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.grey)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.green)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.red)),
    isCollapsed: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  );

  static const textStyleHader = TextStyle(
    color: Colors.black,
    fontSize: 17,
  );
  static const textStyleDiscription = TextStyle(
    color: Colors.green,
    fontSize: 17,
  );
  static const textStyleDiscriptionVPN =
      TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold);

  static const textDescription =
      '''// Комментарии к данному Pet-проекту: Данные проект сделан на базе сайта https://www.themoviedb.org/ с открытым API кодом. К сожалению с территории России доступ к сайту заблокирован, поэтому для успешной работы приложения необходимо ''';

  static const textDescriptionVPN = 'включить VPN';
  static const textDescription2 = '''  на ноутбуке или телефоне \n
Tак же, т.к.  это Pet-проект, логин и пароль от сайта поставлены по умолчанию. 
Это сделано для удобства  и демонстрации работы без необходимости регистрации 
на сайте.
''';
}
