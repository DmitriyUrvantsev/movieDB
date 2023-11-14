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

  static const text1 = Text(
    'Для использования сочетания клавиш нажмите и удерживайте одну или более клавиш модификации, а затем нажмите последнюю клавишу сочетания. Для использования сочетания клавиш нажмите и удерживайте одну или более клавиш модификации, а затем нажмите последнюю клавишу сочетания.',
    style: textStyleHader,
  );
  static const text2 = Text(
    'Для использования сочетания клавиш нажмите и удерживайте одну или более клавиш ',
    style: textStyleHader,
  );
}
