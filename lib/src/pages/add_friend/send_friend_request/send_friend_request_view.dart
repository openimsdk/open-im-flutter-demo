import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';
import 'package:openim_enterprise_chat/src/widgets/touch_close_keyboard.dart';

import 'send_friend_request_logic.dart';

class SendFriendRequestPage extends StatelessWidget {
  final logic = Get.find<SendFriendRequestLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: EnterpriseTitleBar.back(
          title: StrRes.friendVerify,
          actions: [
            _buildSendButton(),
          ],
        ),
        backgroundColor: PageStyle.c_F6F6F6,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 22.w),
              child: Text(
                StrRes.sendFriendRequest,
                style: PageStyle.ts_666666_14sp,
              ),
            ),
            Container(
              height: 122.h,
              color: PageStyle.c_FFFFFF,
              // padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
              child: _buildTextField(
                  autofocus: true, maxLines: 10, controller: logic.reasonCtrl),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 22.w),
              child: Text(
                StrRes.remarkName,
                style: PageStyle.ts_666666_14sp,
              ),
            ),
            Container(
              height: 48.h,
              color: PageStyle.c_FFFFFF,
              // padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: _buildTextField(controller: logic.remarkNameCtrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    bool autofocus = false,
    int maxLines = 1,
  }) =>
      TextField(
        controller: controller,
        autofocus: autofocus,
        maxLines: maxLines,
        style: PageStyle.ts_333333_16sp,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 22.w,
            vertical: 13.h,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
      );

  Widget _buildSendButton() => Material(
        child: Ink(
          decoration: BoxDecoration(
            color: PageStyle.c_1B72EC,
            borderRadius: BorderRadius.circular(4),
          ),
          child: InkWell(
            onTap: () => logic.addFriend(),
            child: Container(
              // height: 28.h,
              // alignment: Alignment.center,
              padding: EdgeInsets.only(
                left: 10.w,
                top: 3.h,
                right: 10.w,
                bottom: 5.h,
              ),
              child: Text(
                StrRes.send,
                style: PageStyle.ts_FFFFFF_16sp,
              ),
            ),
          ),
        ),
      );
}
