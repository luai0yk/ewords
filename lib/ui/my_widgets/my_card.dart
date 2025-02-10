import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  const MyCard({super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: child,
    );
  }
}
