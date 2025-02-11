import 'package:flutter/material.dart';

class BottomSheetHelper {
  static show({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    showModalBottomSheet(context: context, builder: builder);
  }
}
