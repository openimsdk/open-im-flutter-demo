import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatCallItemView extends StatelessWidget {
  const ChatCallItemView({
    Key? key,
    required this.type,
    required this.content,
  }) : super(key: key);

  final String content;
  final String type;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          (type == 'audio' ? ImageRes.voiceCallMsg : ImageRes.videoCallMsg).toImage
            ..width = 18.w
            ..height = 18.h
            ..color = (/*isISend ? Styles.c_FFFFFF : */ Styles.c_0C1C33),
          8.horizontalSpace,
          Text(
            content,
            style: /*isISend ? Styles.ts_FFFFFF_17sp : */ Styles.ts_0C1C33_17sp,
          ),
        ],
      );
}
