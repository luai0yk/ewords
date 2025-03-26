import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/my_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.borderRadius = 10,
    this.padding,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? MyColors.themeColors[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      onPressed: onPressed,
      child: icon == null
          ? Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: fontWeight,
                fontSize: fontSize.sp,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: fontWeight,
                    fontSize: fontSize.sp,
                  ),
                ),
                const SizedBox(width: 10),
                icon!,
              ],
            ),
    );
  }
}