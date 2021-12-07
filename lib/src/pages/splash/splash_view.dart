import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';

import 'splash_logic.dart';

class SplashPage extends StatelessWidget {
  final logic = Get.find<SplashLogic>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned(
            top: 603.h,
            width: 375.w,
            child: Center(
              child: Image.asset(
                ImageRes.ic_app,
                width: 52.w,
                height: 53.h,
              ),
            ),
          ),
          Positioned(
            top: 673.h,
            width: 375.w,
            child: Center(
              child: Text(
                StrRes.welcomeHint,
                style: PageStyle.ts_333333_16sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
