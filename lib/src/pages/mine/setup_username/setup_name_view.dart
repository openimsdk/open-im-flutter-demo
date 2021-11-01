import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';
import 'package:openim_enterprise_chat/src/widgets/touch_close_keyboard.dart';

import 'setup_name_logic.dart';

class SetupUserNamePage extends StatelessWidget {
  final logic = Get.find<SetupUserNameLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: EnterpriseTitleBar.back(
          title: StrRes.setupNickname,
        ),
        backgroundColor: PageStyle.c_FFFFFF,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 22.w,
                right: 22.w,
                top: 40.h,
              ),
              padding: EdgeInsets.only(bottom: 7.h),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                    width: 1,
                    color: PageStyle.c_999999,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: PageStyle.ts_333333_20sp,
                      controller: logic.inputCtrl,
                      // focusNode: logic.focusNode,
                      autofocus: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        // hintText: logic.info.comment,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => logic.setupName(),
                    child: Container(
                      // height: 28.h,
                      padding: EdgeInsets.only(
                        top: 3.h,
                        bottom: 4.5.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: PageStyle.c_1B72EC,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        StrRes.save,
                        style: PageStyle.ts_FFFFFF_16sp,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
