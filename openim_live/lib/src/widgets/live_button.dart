import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class LiveButton extends StatelessWidget {
  const LiveButton({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
  }) : super(key: key);
  final String text;
  final String icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon.toImage
          ..width = 62.w
          ..height = 62.h
          ..onTap = onTap,
        10.verticalSpace,
        text.toText..style = Styles.ts_FFFFFF_opacity70_14sp,
      ],
    );
  }

  LiveButton.microphone({
    super.key,
    this.onTap,
    bool on = true,
  })  : text = StrRes.microphone,
        icon = on ? ImageRes.liveMicOn : ImageRes.liveMicOff;

  LiveButton.speaker({
    super.key,
    this.onTap,
    bool on = true,
  })  : text = StrRes.speaker,
        icon = on ? ImageRes.liveSpeakerOn : ImageRes.liveSpeakerOff;

  LiveButton.hungUp({
    super.key,
    this.onTap,
  })  : text = StrRes.hangUp,
        icon = ImageRes.liveHangUp;

  LiveButton.reject({
    super.key,
    this.onTap,
  })  : text = StrRes.reject,
        icon = ImageRes.liveHangUp;

  LiveButton.cancel({
    super.key,
    this.onTap,
  })  : text = StrRes.cancel,
        icon = ImageRes.liveHangUp;

  LiveButton.pickUp({
    super.key,
    this.onTap,
  })  : text = StrRes.pickUp,
        icon = ImageRes.livePicUp;
}
