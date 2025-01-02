import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatCarteView extends StatelessWidget {
  const ChatCarteView({
    Key? key,
    required this.cardElem,
  }) : super(key: key);
  final CardElem cardElem;

  @override
  Widget build(BuildContext context) => Container(
        width: locationWidth,
        height: 91.h,
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          border: Border.all(color: Styles.c_E8EAEF, width: 1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AvatarView(
                      width: 44.w,
                      height: 44.h,
                      url: cardElem.faceURL,
                      text: cardElem.nickname,
                      textStyle: Styles.ts_FFFFFF_14sp_medium,
                    ),
                    10.horizontalSpace,
                    Flexible(
                      child: cardElem.nickname!.toText
                        ..style = Styles.ts_0C1C33_17sp
                        ..overflow = TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(color: Styles.c_E8EAEF, height: 1),
            Container(
              height: 26.h,
              padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 17.w),
              child: StrRes.carte.toText..style = Styles.ts_8E9AB0_12sp,
            )
          ],
        ),
      );
}
