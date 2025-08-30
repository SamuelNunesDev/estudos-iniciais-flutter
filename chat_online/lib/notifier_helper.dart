import 'package:flutter/material.dart';

class NotifierHelper {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message, {Color? color}) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color ?? Colors.red),
    );
  }
}
