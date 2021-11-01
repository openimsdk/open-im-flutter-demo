import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/utils/debounce_button.dart';
import 'package:openim_enterprise_chat/src/widgets/avatar_view.dart';
import 'package:openim_enterprise_chat/src/widgets/button.dart';
import 'package:openim_enterprise_chat/src/widgets/image_button.dart';
import 'package:openim_enterprise_chat/src/widgets/name_input_box.dart';
import 'package:openim_enterprise_chat/src/widgets/touch_close_keyboard.dart';

import 'setupinfo_logic.dart';

class SetupSelfInfoPage extends StatelessWidget {
  final logic = Get.find<SetupSelfInfoLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: PageStyle.c_FFFFFF,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            height: 1.sh,
            child: Stack(
              children: [
                Positioned(
                  top: 92.h,
                  child: Text(
                    StrRes.welcomeUse,
                    style: PageStyle.ts_333333_26sp,
                  ),
                ),
                Positioned(
                  top: 133.h,
                  child: Text(
                    StrRes.plsFullSelfInfo,
                    style: PageStyle.ts_999999_16sp,
                  ),
                ),
                Positioned(
                  top: 205.h,
                  child: Container(
                    width: 311.w,
                    alignment: Alignment.center,
                    child: Obx(() => logic.icon.isEmpty
                        ? ImageButton(
                            imgStrRes: ImageRes.ic_bigCamera,
                            imgWidth: 90.h,
                            imgHeight: 90.h,
                            onTap: () => logic.pickerPic(),
                          )
                        : AvatarView(
                            size: 90.h,
                            url: logic.icon.value,
                            onTap: () => logic.pickerPic(),
                          )),
                  ),
                ),
                Positioned(
                  top: 301.h,
                  child: Container(
                    width: 311.w,
                    alignment: Alignment.center,
                    child: Text(
                      StrRes.clickUpdateAvatar,
                      style: PageStyle.ts_999999_12sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 368.h,
                  width: 311.w,
                  child: Obx(() => NameInputBox(
                        leftLabel: StrRes.yourName,
                        leftLabelStyle: PageStyle.ts_000000_18sp,
                        hintText: StrRes.plsWriteRealName,
                        hintStyle: PageStyle.ts_000000_opacity40p_18sp,
                        textStyle: PageStyle.ts_000000_18sp,
                        controller: logic.nameCtrl,
                        showClearBtn: logic.showNameClearBtn.value,
                        clearBtnColor: Color(0xFF000000).withOpacity(0.4),
                      )),
                ),
                Positioned(
                  top: 429.h,
                  width: 311.w,
                  child: DebounceButton(
                    onTap: () async => await logic.enterMain(),
                    // your tap handler moved here
                    builder: (context, onTap) {
                      return Button(
                        textStyle: PageStyle.ts_FFFFFF_18sp,
                        text: StrRes.enterApp,
                        background: PageStyle.c_1D6BED,
                        onTap: onTap,
                      );
                    },
                  ),
                  // child: DebounceButton(
                  //   onTap: () => logic.enterMain(),
                  //   builder: (onTap) => Button(
                  //     textStyle: PageStyle.ts_FFFFFF_18sp,
                  //     text: StrRes.enterApp,
                  //     background: PageStyle.c_1D6BED,
                  //     onTap: onTap,
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
