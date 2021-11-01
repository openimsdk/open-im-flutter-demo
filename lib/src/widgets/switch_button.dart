import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton({
    Key? key,
    this.on = true,
    this.onTap,
    this.width,
    this.height,
  }) : super(key: key);
  final bool on;
  final Function()? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Image.asset(
          on ? ImageRes.ic_switchOn : ImageRes.ic_switchOff,
          width: width ?? 38.w,
          height: height ?? 22.h,
        ),
      ),
    );
  }
}
