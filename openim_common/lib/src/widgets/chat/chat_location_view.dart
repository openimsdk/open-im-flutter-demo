import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatLocationView extends StatelessWidget {
  const ChatLocationView({
    Key? key,
    required this.description,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);
  final String description;
  final double latitude;
  final double longitude;
  final _decoder = const JsonDecoder();

  @override
  Widget build(BuildContext context) {
    try {
      final map = _decoder.convert(description);
      String url = map['url'] ?? '';
      String name = map['name'] ?? '';
      String addr = map['addr'] ?? '';
      return Container(
        width: locationWidth,
        height: 130.h,
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          border: Border.all(color: Styles.c_E8EAEF, width: 1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            4.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: name.toText
                ..style = Styles.ts_0C1C33_14sp
                ..maxLines = 1
                ..overflow = TextOverflow.ellipsis,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: addr.toText
                ..style = Styles.ts_8E9AB0_12sp
                ..maxLines = 1
                ..overflow = TextOverflow.ellipsis,
            ),
            2.verticalSpace,
            Expanded(
              child: ImageUtil.networkImage(
                url: url,
                width: locationWidth,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      );
    } catch (e) {}
    return Container();
  }
}
