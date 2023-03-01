import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/button.dart';
import 'package:openim_demo/src/widgets/debounce_button.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import 'setupinfo_logic.dart';

class SetupSelfInfoPage extends StatelessWidget {
  final logic = Get.find<SetupSelfInfoLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: EnterpriseTitleBar.backButton(left: 16),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    StrRes.plsFullSelfInfo,
                    style: PageStyle.ts_333333_26sp,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  _buildCell(
                    StrRes.nickname,
                    trailing: Text(
                      logic.nickName.value,
                      style: PageStyle.ts_000000_17sp,
                    ),
                    onTap: () {
                      _showDialog();
                    },
                  ),
                  _buildCell(
                    StrRes.avatar,
                    trailing: Obx(() => _buildAvatarButton()),
                    onTap: () {
                      logic.openPhotoSheet();
                    },
                  ),
                  _buildCell(
                    StrRes.gender,
                    trailing: Text(
                      logic.genderStr,
                      style: PageStyle.ts_000000_17sp,
                    ),
                    onTap: () {
                      logic.selectGender();
                    },
                  ),
                  // _buildCell(
                  //   '${StrRes.invitationCode}${logic.needInvitationCodeRegister ? '' : StrRes.optional}',
                  //   trailing: Text(logic.invitationCode.value),
                  //   onTap: () {
                  //     _showDialog(false);
                  //   },
                  // ),
                  45.verticalSpace,
                  DebounceButton(
                    onTap: () async => await logic.enterMain(),
                    // your tap handler moved here
                    builder: (context, onTap) {
                      return Button(
                        textStyle: PageStyle.ts_FFFFFF_18sp,
                        text: StrRes.enterApp,
                        onTap: onTap,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String title, {Widget? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(
              color: PageStyle.c_D8D8D8,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(title, style: PageStyle.ts_000000_17sp),
            Spacer(),
            if (trailing != null) trailing,
            Image.asset(
              ImageRes.ic_moreArrow,
              width: 12,
              height: 12,
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDialog() {
    showDialog<String>(
      context: Get.context!,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: logic.nameCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: StrRes.nickname,
                    hintText: logic.nickName.value,
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(StrRes.cancel),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(StrRes.sure),
              onPressed: () {
                logic.nickName.value = logic.nameCtrl.text.trim();
                Get.back();
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildAvatarButton() {
    late Widget child;
    if (logic.icon.value.isEmpty) {
      if (logic.avatarIndex.value == -1) {
        child = Image.asset(
          ImageRes.ic_smallCamera,
          width: 35.h,
          height: 35.h,
        );
      } else {
        child = ImageUtil.assetImage(
          indexAvatarList[logic.avatarIndex.value],
          width: 35.h,
          height: 35.h,
        );
      }
    } else {
      child = Image.file(
        File(logic.icon.value),
        width: 40.h,
        height: 40.h,
        fit: BoxFit.cover,
      );
    }
    return logic.icon.value.isEmpty && logic.nickName.value.isNotEmpty
        ? AvatarView(
            text: logic.nickName.value,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: child,
          );
  }
}
