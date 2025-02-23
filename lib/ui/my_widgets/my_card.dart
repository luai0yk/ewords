import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin, padding;
  final double? width, height;
  final AlignmentGeometry alignment;
  const MyCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.width,
    this.height,
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
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: child,
    );
  }
}
