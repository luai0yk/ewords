import 'package:flutter/material.dart';

class DialogHelper {
  static show(
      {required BuildContext context,
      required RoutePageBuilder pageBuilder,
      bool isDismissible = true}) {
    showGeneralDialog(
      context: context,
      pageBuilder: pageBuilder,
      barrierLabel: 'animated_dialog',
      barrierDismissible: isDismissible,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: child,
        );
      },
    );
  }
}
