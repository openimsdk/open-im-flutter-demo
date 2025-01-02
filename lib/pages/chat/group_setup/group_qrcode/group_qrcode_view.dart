import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'group_qrcode_logic.dart';

class GroupQrcodePage extends StatelessWidget {
  final logic = Get.find<GroupQrcodeLogic>();

  GroupQrcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: TitleBar.back(title: StrRes.groupQrcode),
        backgroundColor: Styles.c_F8F9FA,
        body: Container(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 22.h),
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            width: 331.w,
            height: 460.h,
            decoration: BoxDecoration(
              color: Styles.c_FFFFFF,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  blurRadius: 7.r,
                  spreadRadius: 1.r,
                  color: Styles.c_000000.withOpacity(.08),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 30.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AvatarView(
                        width: 48.w,
                        height: 48.h,
                        url: logic.groupSetupLogic.groupInfo.value.faceURL,
                        text: logic.groupSetupLogic.groupInfo.value.groupName,
                        textStyle: Styles.ts_FFFFFF_14sp,
                      ),
                      12.horizontalSpace,
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 180.w),
                        child: (logic.groupSetupLogic.groupInfo.value.groupName ?? '').toText
                          ..style = Styles.ts_0C1C33_20sp
                          ..maxLines = 1
                          ..overflow = TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 140.h,
                  width: 272.w,
                  child: StrRes.groupQrcodeHint.toText
                    ..style = Styles.ts_8E9AB0_15sp
                    ..textAlign = TextAlign.center,
                ),
                Positioned(
                  top: 183.h,
                  width: 272.w,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 180.w,
                      height: 180.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Styles.c_FFFFFF,
                        border: Border.all(color: Styles.c_E8EAEF, width: 4.w),
                      ),
                      child: QrImageView(
                        data: logic.buildQRContent(),
                        size: 140.w,
                        backgroundColor: Styles.c_FFFFFF,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
