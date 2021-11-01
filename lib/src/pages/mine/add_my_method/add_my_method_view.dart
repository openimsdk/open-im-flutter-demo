import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/switch_button.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'add_my_method_logic.dart';

class AddMyMethodPage extends StatelessWidget {
  final logic = Get.find<AddMyMethodLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.addMyMethod,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: Column(
        children: [
          Container(
            height: 40.h,
            padding: EdgeInsets.only(left: 22.w),
            alignment: Alignment.centerLeft,
            child: Text(
              StrRes.addMyMethodHint,
              style: PageStyle.ts_999999_14sp,
            ),
          ),
          Obx(() => _buildItemView(
                label: StrRes.phoneNum,
                on: logic.enabledPhone.value,
                onTap: () => logic.togglePhone(),
              )),
          Obx(() => _buildItemView(
                label: StrRes.idCode,
                on: logic.enabledIDCode.value,
                onTap: () => logic.toggleIDCode(),
              )),
        ],
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    Function()? onTap,
    bool on = false,
  }) =>
      Ink(
        height: 58.h,
        color: PageStyle.c_FFFFFF,
        child: InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(
                  color: PageStyle.c_999999_opacity40p,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: PageStyle.ts_333333_18sp,
                ),
                Spacer(),
                SwitchButton(
                  width: 42.w,
                  height: 25.h,
                  on: on,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ),
      );
}
