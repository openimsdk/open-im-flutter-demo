import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../res/styles.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.text,
    this.enabled = true,
    this.color,
    this.disabledColor,
    this.radius = 4,
    this.textStyle,
    this.disabledTextStyle,
    this.onTap,
    this.height,
    this.margin,
  }) : super(key: key);
  final Color? color;
  final Color? disabledColor;
  final double radius;
  final TextStyle? textStyle;
  final TextStyle? disabledTextStyle;
  final String text;
  final double? height;
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final bool enabled;

  Color? get _backgroundColor => enabled
      ? color ?? PageStyle.c_0089FF
      : disabledColor ?? PageStyle.c_0089FF_opacity40p;

  TextStyle? get _textStyle => enabled
      ? textStyle ?? PageStyle.ts_FFFFFF_18sp_semibold
      : disabledTextStyle ?? PageStyle.ts_FFFFFF_18sp_semibold;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          height: height ?? 44.h,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              alignment: Alignment.center,
              child: Text(text, style: _textStyle),
            ),
          ),
        ),
      ),
    );
  }
}
