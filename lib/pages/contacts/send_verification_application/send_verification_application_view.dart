import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'send_verification_application_logic.dart';

class SendVerificationApplicationPage extends StatelessWidget {
  final logic = Get.find<SendVerificationApplicationLogic>();

  SendVerificationApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.back(
          title: logic.isEnterGroup ? StrRes.groupVerification : StrRes.friendVerification,
          right: StrRes.send.toText
            ..style = Styles.ts_0C1C33_17sp
            ..onTap = logic.send,
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
                child: (logic.isEnterGroup ? StrRes.sendEnterGroupApplication : StrRes.sendToBeFriendApplication).toText
                  ..style = Styles.ts_8E9AB0_14sp,
              ),
              Container(
                height: 122.h,
                color: Styles.c_FFFFFF,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: TextField(
                  controller: logic.inputCtrl,
                  autofocus: true,
                  maxLines: 10,
                  maxLength: 20,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
