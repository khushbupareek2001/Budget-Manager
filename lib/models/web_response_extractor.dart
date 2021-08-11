import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WebResponseExtractor {
  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor: Colors.black,
        backgroundColor: Colors.grey[200],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2);
  }
}
