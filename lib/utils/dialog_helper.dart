import 'package:flutter/material.dart';

class DialogHelper {
  static show({
    required BuildContext context,
    required RoutePageBuilder pageBuilder,
  }) {
    showGeneralDialog(
      context: context,
      pageBuilder: pageBuilder,
      barrierLabel: 'animated_dialog',
      barrierDismissible: true,
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
