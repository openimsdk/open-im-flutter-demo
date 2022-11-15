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
      body: Container(
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
              _buildCell(StrRes.nickname, trailing: Text(logic.nickName.value),
                  onTap: () {
                _showDialog();
              }),
              _buildCell(StrRes.avatar,
                  trailing: Obx(() => _buildAvatarButton()), onTap: () {
                logic.openPhotoSheet();
              }),
              _buildCell(StrRes.gender, trailing: Text(logic.genderStr),
                  onTap: () {
                logic.selectGender();
              }),
              _buildCell(StrRes.invitationCode + '(选填)',
                  trailing: Text(logic.invitationCode.value), onTap: () {
                _showDialog(false);
              }),
              SizedBox(
                height: 24.h,
              ),
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
    ));
  }

  Widget _buildCell(String title, {Widget? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      child: Container(
        height: 70.h,
        color: Colors.transparent,
        child: Column(
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (trailing != null) trailing,
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: PageStyle.c_666666,
                    )
                  ],
                )
              ],
            ),
            Spacer(),
            Divider(
              thickness: 2,
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDialog([bool forNickName = true]) {
    showDialog<String>(
      context: Get.context!,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller:
                      forNickName ? logic.nameCtrl : logic.invitationCodeCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText:
                          forNickName ? StrRes.nickname : StrRes.invitationCode,
                      hintText: forNickName
                          ? logic.nickName.value
                          : logic.invitationCode.value),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: Text(StrRes.cancel),
                onPressed: () {
                  Get.back();
                }),
            TextButton(
                child: Text(StrRes.sure),
                onPressed: () {
                  forNickName
                      ? logic.nickName.value = logic.nameCtrl.text.trim()
                      : logic.invitationCode.value =
                          logic.invitationCodeCtrl.text.trim();
                  Get.back();
                })
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
