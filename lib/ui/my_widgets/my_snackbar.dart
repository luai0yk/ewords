import 'package:flutter/material.dart';

class MySnackBar {
  static SnackBar create(
      {required String content, String? label, Function()? onPressed}) {
    return SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: label ?? '',
        onPressed: onPressed ?? () {},
      ),
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
