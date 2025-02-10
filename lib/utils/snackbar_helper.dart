import 'package:flutter/material.dart';

class SnackBarHelper {
  static show({required context, required widget}) {
    ScaffoldMessenger.of(context).showSnackBar(widget);
  }
}
