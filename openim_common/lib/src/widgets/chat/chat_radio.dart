import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatRadio extends StatelessWidget {
  const ChatRadio({
    Key? key,
    required this.checked,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);
  final bool checked;
  final Function()? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child:
          (checked || !enabled ? ImageRes.radioSel : ImageRes.radioNor).toImage
            ..width = 20.w
            ..height = 20.h
            ..opacity = (enabled ? 1 : .5),
    );
  }
}
