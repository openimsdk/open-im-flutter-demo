import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'personal_info_logic.dart';

class PersonalInfoPage extends StatelessWidget {
  final logic = Get.find<PersonalInfoLogic>();

  PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.personalInfo,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                10.verticalSpace,
                _buildCornerBgView(
                  children: [
                    _buildItemView(
                      label: StrRes.avatar,
                      isAvatar: true,
                      value: logic.nickname,
                      url: logic.faceURL,
                    ),
                    _buildItemView(
                      label: StrRes.name,
                      value: logic.nickname,
                    ),
                    _buildItemView(
                      label: StrRes.gender,
                      value: logic.isMale ? StrRes.man : StrRes.woman,
                    ),
                    _buildItemView(
                      label: StrRes.birthDay,
                      value: logic.birth,
                    ),
                  ],
                ),
                10.verticalSpace,
                _buildCornerBgView(
                  children: [
                    _buildItemView(
                      label: StrRes.mobile,
                      value: logic.phoneNumber,
                      onTap: logic.clickPhoneNumber,
                    ),
                    _buildItemView(
                      label: StrRes.email,
                      value: logic.email,
                      onTap: logic.clickEmail,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildCornerBgView({required List<Widget> children}) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.r),
            topRight: Radius.circular(6.r),
            bottomLeft: Radius.circular(6.r),
            bottomRight: Radius.circular(6.r),
          ),
        ),
        child: Column(children: children),
      );

  Widget _buildItemView({
    required String label,
    String? value,
    String? url,
    bool isAvatar = false,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: SizedBox(
          height: 46.h,
          child: Row(
            children: [
              label.toText..style = Styles.ts_0C1C33_17sp,
              const Spacer(),
              if (null != value && !isAvatar)
                value.toText..style = Styles.ts_0C1C33_17sp,
              if (isAvatar)
                AvatarView(
                  width: 32.w,
                  height: 32.h,
                  url: url,
                  text: value,
                  textStyle: Styles.ts_FFFFFF_10sp,
                ),
            ],
          ),
        ),
      );
}
