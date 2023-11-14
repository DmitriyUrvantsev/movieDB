import 'package:flutter/material.dart';

abstract class AppButtonStyle {
  static const ButtonStyle linkButton = ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.blue),
      overlayColor: MaterialStatePropertyAll(Colors.green),
      padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 25, vertical: 8)));
}
