import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBadge extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final IconData? icon;
  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFFE1F5FE),
    this.textColor = const Color(0xFF4FC3F7),
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: textColor,
              size: 14.sp,
            ),
          if (icon != null) SizedBox(width: 4.w),
          Text(
            textAlign: TextAlign.center,
            text.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
