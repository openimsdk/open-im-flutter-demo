import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'qrcode_logic.dart';

class GroupQrcodePage extends StatelessWidget {
  final logic = Get.find<GroupQrcodeLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.groupQrcode,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: Container(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 58.h),
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          width: 332.w,
          height: 444.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 7,
                  spreadRadius: 5,
                  color: Color(0xFF000000).withOpacity(0.08)),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 31.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AvatarView(
                      size: 58.h,
                      url: logic.info.faceURL,
                    ),
                    SizedBox(
                      width: 13.w,
                    ),
                    Text(
                      logic.info.groupName ?? '',
                      style: PageStyle.ts_000000_20sp,
                    )
                  ],
                ),
              ),
              Positioned(
                top: 134.h,
                width: 272.w,
                child: Text(
                  StrRes.groupQrcodeTips,
                  style: PageStyle.ts_999999_14sp,
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: 184.h,
                width: 272.w,
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 180.h,
                    height: 180.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFAAF7D9),
                          Color(0xFF5496E4),
                        ],
                      ),
                    ),
                    child: QrImage(
                      data: logic.buildQRContent(),
                      size: 176.h,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
