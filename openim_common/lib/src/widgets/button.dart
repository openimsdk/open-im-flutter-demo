import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.text,
    this.enabled = true,
    this.enabledColor,
    this.disabledColor,
    this.radius,
    this.textStyle,
    this.disabledTextStyle,
    this.onTap,
    this.height,
    this.margin,
    this.padding,
  }) : super(key: key);
  final Color? enabledColor;
  final Color? disabledColor;
  final double? radius;
  final TextStyle? textStyle;
  final TextStyle? disabledTextStyle;
  final String text;
  final double? height;
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          height: height ?? 44.h,
          decoration: BoxDecoration(
            color: enabled ? enabledColor ?? Styles.c_0089FF : disabledColor ?? Styles.c_0089FF_opacity50,
            borderRadius: BorderRadius.circular(radius ?? 4.r),
          ),
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(radius ?? 4.r),
            child: Container(
              alignment: Alignment.center,
              padding: padding,
              child: Text(
                text,
                style: textStyle ?? Styles.ts_FFFFFF_17sp_semibold,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageTextButton extends StatelessWidget {
  const ImageTextButton({
    Key? key,
    required this.icon,
    required this.text,
    this.textStyle,
    this.color,
    this.height,
    this.onTap,
  }) : super(key: key);
  final String icon;
  final String text;
  final TextStyle? textStyle;
  final Color? color;
  final double? height;
  final Function()? onTap;

  ImageTextButton.call({super.key, this.onTap})
      : icon = ImageRes.audioAndVideoCall,
        text = StrRes.audioAndVideoCall,
        color = Styles.c_FFFFFF,
        textStyle = null,
        height = null;

  ImageTextButton.message({super.key, this.onTap})
      : icon = ImageRes.message,
        text = StrRes.sendMessage,
        color = Styles.c_0089FF,
        textStyle = Styles.ts_FFFFFF_17sp,
        height = null;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        height: height ?? 46.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: color,
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon.toImage
                ..width = 20.w
                ..height = 20.h,
              6.horizontalSpace,
              text.toText..style = textStyle ?? Styles.ts_0C1C33_17sp,
            ],
          ),
        ),
      ),
    );
  }
}
