import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin, padding;
  final double? width, height;
  final double radius, borderWidth;
  final bool isBorderd;
  final AlignmentGeometry alignment;
  const MyCard({
    super.key,
    required this.child,
    this.margin,
    this.padding = const EdgeInsets.all(8),
    this.width,
    this.height,
    this.radius = 18,
    this.borderWidth = 1,
    this.isBorderd = true,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(radius),
        border: isBorderd
            ? Border.all(width: borderWidth, color: Colors.black12)
            : const Border(),
      ),
      child: child,
    );
  }
}
