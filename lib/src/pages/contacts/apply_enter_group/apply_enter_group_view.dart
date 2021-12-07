import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';
import 'package:openim_enterprise_chat/src/widgets/touch_close_keyboard.dart';

import 'apply_enter_group_logic.dart';

class ApplyEnterGroupPage extends StatelessWidget {
  final logic = Get.find<ApplyEnterGroupLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: EnterpriseTitleBar.back(
          title: StrRes.enterGroupVerify,
          actions: [
            GestureDetector(
              onTap: logic.sendApply,
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: BoxDecoration(
                  color: PageStyle.c_1B72EC,
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 28.h,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  // top: 5.h,
                  // bottom: 5.h,
                ),
                child: Text(
                  StrRes.send,
                  style: PageStyle.ts_FFFFFF_16sp,
                ),
              ),
            )
          ],
        ),
        backgroundColor: PageStyle.c_F6F6F6,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              height: 40.h,
              alignment: Alignment.centerLeft,
              child: Text(
                StrRes.enterGroupHint,
                style: PageStyle.ts_666666_14sp,
              ),
            ),
            Container(
              height: 122.h,
              color: PageStyle.c_FFFFFF,
              child: TextField(
                // expands: true,
                controller: logic.controller,
                autofocus: true,
                maxLines: 10,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
