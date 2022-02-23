import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'accept_friend_request_logic.dart';

class AcceptFriendRequestPage extends StatelessWidget {
  final logic = Get.find<AcceptFriendRequestLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.friendRequests,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: Column(
        children: [
          Container(
            color: PageStyle.c_FFFFFF,
            padding: EdgeInsets.only(
              left: 22.w,
              right: 22.w,
              top: 33.h,
              bottom: 28.h,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AvatarView(
                      url: logic.userInfo.fromFaceURL,
                      size: 56.h,
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        logic.userInfo.fromNickname!,
                        style: PageStyle.ts_333333_20sp,
                      ),
                    ),
                    Image.asset(
                      ImageRes.ic_next,
                      width: 20.w,
                      height: 20.h,
                    )
                  ],
                ),
                Container(
                  height: 124.h,
                  width: 331.w,
                  margin: EdgeInsets.only(top: 29.h),
                  decoration: BoxDecoration(
                    color: PageStyle.c_EEEEEE,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${logic.userInfo.fromNickname}：${logic.userInfo.reqMsg}',
                        style: PageStyle.ts_333333_14sp,
                      ),
                      Spacer(),
                      Text(
                        StrRes.reply,
                        style: PageStyle.ts_1D6BED_16sp,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: PageStyle.c_FFFFFF,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            height: 55.h,
            child: Row(
              children: [
                Text(
                  StrRes.remark,
                  style: PageStyle.ts_333333_18sp,
                ),
                Spacer(),
                Image.asset(
                  ImageRes.ic_next,
                  width: 16.w,
                  height: 16.h,
                ),
              ],
            ),
          ),
          Ink(
            color: PageStyle.c_FFFFFF,
            height: 55.h,
            // width: 375.w,
            child: InkWell(
              onTap: () => logic.acceptFriendApplication(),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Text(
                  StrRes.acceptFriendRequests,
                  style: PageStyle.ts_1B61D6_18sp,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                StrRes.addBlacklist,
                style: PageStyle.ts_1B61D6_14sp,
              ),
              Container(
                height: 16.h,
                width: 1.w,
                color: PageStyle.c_1B61D6,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
              ),
              Text(
                StrRes.complaint,
                style: PageStyle.ts_1B61D6_14sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
