import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'language_setup_logic.dart';

class LanguageSetupPage extends StatelessWidget {
  final logic = Get.find<LanguageSetupLogic>();

  LanguageSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.languageSetup),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => Column(
            children: [
              12.verticalSpace,
              _buildItemView(
                label: StrRes.followSystem,
                isChecked: logic.isFollowSystem.value,
                onTap: () => logic.switchLanguage(0),
                isTopRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: Styles.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrRes.chinese,
                isChecked: logic.isChinese.value,
                onTap: () => logic.switchLanguage(1),
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: Styles.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrRes.english,
                isChecked: logic.isEnglish.value,
                onTap: () => logic.switchLanguage(2),
                isBottomRadius: true,
              ),
            ],
          )),
    );
  }

  Widget _buildItemView({
    required String label,
    bool isChecked = false,
    bool isTopRadius = false,
    bool isBottomRadius = false,
    Function()? onTap,
  }) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Ink(
          height: 60.h,
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isTopRadius ? 6.r : 0),
              topRight: Radius.circular(isTopRadius ? 6.r : 0),
              bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
              bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  label.toText..style = Styles.ts_0C1C33_17sp,
                  const Spacer(),
                  if (isChecked)
                    ImageRes.checked.toImage
                      ..width = 24.w
                      ..height = 24.h,
                ],
              ),
            ),
          ),
        ),
      );
}
