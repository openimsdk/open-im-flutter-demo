import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/image_button.dart';

enum RadioStyle {
  BLUE,
  WHITE,
}

class RadioButton extends StatelessWidget {
  const RadioButton({
    Key? key,
    this.isChecked = true,
    this.onTap,
    this.style = RadioStyle.WHITE,
  }) : super(key: key);
  final bool isChecked;
  final Function()? onTap;
  final RadioStyle style;

  String _asset() {
    switch (style) {
      case RadioStyle.WHITE:
        return isChecked
            ? ImageRes.ic_radioSelWhite
            : ImageRes.ic_radioNorWhite;
      default:
        return isChecked ? ImageRes.ic_radioSelBlue : ImageRes.ic_radioNorBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ImageButton(
      imgStrRes: _asset(),
      imgWidth: 15.h,
      imgHeight: 15.h,
      onTap: onTap,
    );
  }
}

class RadioButton1 extends StatelessWidget {
  const RadioButton1({
    Key? key,
    this.isChecked = true,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);
  final bool isChecked;
  final bool enabled;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: isChecked
          ? Image.asset(
              ImageRes.ic_radioSelBlue,
              width: 22.w,
              height: 22.h,
              color: !enabled ? Colors.grey : null,
            )
          : Image.asset(
              ImageRes.ic_radioNorWhite,
              color: PageStyle.c_979797,
              width: 22.w,
              height: 22.h,
            ),
    );
  }
}
