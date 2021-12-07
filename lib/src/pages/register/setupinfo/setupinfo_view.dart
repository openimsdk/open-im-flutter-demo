import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/button.dart';
import 'package:openim_enterprise_chat/src/widgets/debounce_button.dart';
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
                    child: Obx(() => _buildAvatarButton()),
                    /* child: Obx(() => logic.icon.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: ImageButton(
                              // imgStrRes: logic.getIndexAvatar(),
                              imgStrRes: ImageRes.ic_smallCamera,
                              imgWidth: 90.h,
                              imgHeight: 90.h,
                              onTap: () => logic.pickerPic(),
                              // package: 'flutter_openim_widget',
                            ),
                          )
                        : AvatarView(
                            size: 90.h,
                            url: logic.icon.value,
                            onTap: () => logic.pickerPic(),
                          )),*/
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

  Widget _buildAvatarButton() {
    late Widget child;
    if (logic.icon.isEmpty) {
      if (logic.avatarIndex.value == -1) {
        child = Image.asset(
          ImageRes.ic_smallCamera,
          width: 46.h,
          height: 46.h,
        );
      } else {
        child = Ink(
          height: 90.h,
          width: 90.h,
          decoration: BoxDecoration(
            color: PageStyle.c_D8D8D8,
            borderRadius: BorderRadius.circular(6),
          ),
          child: IconUtil.assetImage(
            indexAvatarList[logic.avatarIndex.value],
            width: 90.h,
            height: 90.h,
          ),
        );
      }
    } else {
      child = CachedNetworkImage(
        imageUrl: logic.icon.value,
        width: 90.h,
        height: 90.h,
        fit: BoxFit.fill,
      );
    }
    return Ink(
      height: 90.h,
      width: 90.h,
      decoration: BoxDecoration(
        color: PageStyle.c_D8D8D8,
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () => logic.pickerPic(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
