import 'package:flutter/material.dart';

class MySnackBar {
  static SnackBar create({required content}) {
    return SnackBar(
      content: Text(content),
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
