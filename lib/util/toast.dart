import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ShowToast{

  static void warning(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.yellow.shade800,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  static void wawrningLong(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.yellow.shade800,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  static void error(String text){
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red.shade400,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
}