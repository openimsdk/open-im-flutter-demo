import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/widgets/register_page_bg.dart';
import 'package:openim_common/openim_common.dart';

import 'set_self_info_logic.dart';

class SetSelfInfoPage extends StatelessWidget {
  final logic = Get.find<SetSelfInfoLogic>();

  SetSelfInfoPage({super.key});

  @override
  Widget build(BuildContext context) => RegisterBgView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StrRes.plsCompleteInfo.toText..style = Styles.ts_0089FF_22sp_semibold,
            _buildInputItemView(
              label: StrRes.nickname,
              controller: logic.nicknameCtrl,
            ),
            Obx(() => _buildItemView(
                  label: StrRes.avatar,
                  isAvatar: true,
                  nickname: logic.nickname.value,
                  onTap: logic.openPhotoSheet,
                )),
            _buildItemView(label: StrRes.gender),
          ],
        ),
      );

  Widget _buildItemView({
    required String label,
    String? value,
    bool isAvatar = false,
    String? faceURL,
    String? nickname,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          height: 72.h,
          padding: EdgeInsets.only(bottom: 6.h),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(
                color: Styles.c_E8EAEF,
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              label.toText..style = Styles.ts_8E9AB0_17sp,
              const Spacer(),
              if (null != value && !isAvatar) value.toText..style = Styles.ts_0C1C33_17sp,
              if (isAvatar)
                AvatarView(
                  width: 42.w,
                  height: 42.h,
                  text: nickname,
                  url: faceURL,
                ),
              4.horizontalSpace,
              ImageRes.rightArrow.toImage
                ..width = 24.w
                ..height = 24.h,
            ],
          ),
        ),
      );

  Widget _buildInputItemView({
    required String label,
    TextEditingController? controller,
  }) =>
      Container(
        height: 72.h,
        padding: EdgeInsets.only(bottom: 6.h),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(
              color: Styles.c_E8EAEF,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            label.toText..style = Styles.ts_8E9AB0_17sp,
            Expanded(
              child: SizedBox(
                height: 36.h,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.end,
                  maxLength: 16,
                  style: Styles.ts_0C1C33_17sp,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    counter: SizedBox(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
