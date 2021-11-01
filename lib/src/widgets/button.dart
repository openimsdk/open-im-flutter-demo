import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    this.background,
    this.radius = 4,
    required this.textStyle,
    required this.text,
    this.onTap,
    this.height,
    this.margin,
  }) : super(key: key);
  final Color? background;
  final double radius;
  final TextStyle textStyle;
  final String text;
  final double? height;
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          height: height ?? 44.h,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              alignment: Alignment.center,
              child: Text(text, style: textStyle),
            ),
          ),
        ),
      ),
    );
  }
}
