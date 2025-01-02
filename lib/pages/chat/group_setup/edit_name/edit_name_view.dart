import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'edit_name_logic.dart';

class EditGroupNamePage extends StatelessWidget {
  final logic = Get.find<EditGroupNameLogic>();

  EditGroupNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (logic.type == EditNameType.groupNickname) {
      return Scaffold(
        backgroundColor: Colors.white,
          appBar: TitleBar.back(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              67.verticalSpace,
              StrRes.editGroupName.toText..style = Styles.ts_0C1C33_20sp,
              10.verticalSpace,
              StrRes.editGroupTips.toText..style = Styles.ts_8E9AB0_15sp,
              37.verticalSpace,
              Row(
                children: [
                  50.horizontalSpace,
                  AvatarView(
                    url: logic.faceUrl,
                    isGroup: true,
                  ),
                  Expanded(
                    child: TextField(
                      controller: logic.inputCtrl,
                      style: Styles.ts_0C1C33_17sp,
                      autofocus: true,
                      inputFormatters: [LengthLimitingTextInputFormatter(16)],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 12.w,
                        ),
                      ),
                    ),
                  ),
                  40.horizontalSpace,
                ],
              ),
              const Expanded(child: SizedBox.shrink()),
              Button(
                margin: EdgeInsets.symmetric(horizontal: 100.w),
                text: StrRes.save,
                onTap: logic.save,
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ));
    }
    return Scaffold(
      appBar: TitleBar.back(
        title: logic.title,
        right: StrRes.save.toText
          ..style = Styles.ts_0C1C33_17sp
          ..onTap = logic.save,
      ),
      backgroundColor: Styles.c_FFFFFF,
      body: Column(
        children: [
          22.verticalSpace,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Styles.c_E8EAEF,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: TextField(
              controller: logic.inputCtrl,
              style: Styles.ts_0C1C33_17sp,
              autofocus: true,
              inputFormatters: [LengthLimitingTextInputFormatter(16)],
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 12.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
