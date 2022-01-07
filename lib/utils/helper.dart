import 'package:flutter/material.dart';

class Helper{
   static void toast(context, msg, [duration = 2, color = Colors.grey]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        backgroundColor: color,
        content: Text(
          msg,
        ),
      ),
    );
  }

}