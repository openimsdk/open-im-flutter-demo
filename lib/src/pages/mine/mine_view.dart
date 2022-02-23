import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';

import 'mine_logic.dart';

class MinePage extends StatelessWidget {
  final logic = Get.find<MineLogic>();
  final imLogic = Get.find<IMController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      body: Column(
        children: [
          Obx(
            () => Container(
              height: 222.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageRes.ic_mineHeadBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 63.h,
                    child: AvatarView(
                      size: 76.h,
                      url: imLogic.userInfo.value.faceURL,
                    ),
                  ),
                  Positioned(
                    top: 147.h,
                    child: Text(
                      imLogic.userInfo.value.getShowName(),
                      style: PageStyle.ts_FFFFFF_20sp,
                    ),
                  ),
                  Positioned(
                    top: 182.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => logic.copyID(),
                          child: Text(
                            'ID：${imLogic.userInfo.value.userID}',
                            style: PageStyle.ts_FFFFFF_14sp,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => logic.viewMyQrcode(),
                          child: Row(
                            children: [
                              Image.asset(
                                ImageRes.ic_mineQrCode,
                                width: 18.w,
                                height: 18.h,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Image.asset(
                                ImageRes.ic_next,
                                width: 7.w,
                                height: 13.h,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          _buildItemView(
            icon: ImageRes.ic_myInfo,
            label: StrRes.myInfo,
            onTap: () => logic.viewMyInfo(),
          ),
          // _buildItemView(
          //   icon: ImageRes.ic_newsNotify,
          //   label: StrRes.newsNotify,
          // ),
          _buildItemView(
            icon: ImageRes.ic_accountSetup,
            label: StrRes.accountSetup,
            onTap: () => logic.accountSetup(),
          ),
          _buildItemView(
            icon: ImageRes.ic_aboutUs,
            label: StrRes.aboutUs,
            onTap: () => logic.aboutUs(),
          ),
          _buildItemView(
            icon: ImageRes.ic_logout,
            label: StrRes.logout,
            onTap: () => logic.logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemView({
    required String icon,
    required String label,
    Function()? onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(icon, width: 22.w, height: 22.h),
              SizedBox(width: 13.w),
              Text(
                label,
                style: PageStyle.ts_333333_16sp,
              ),
              Spacer(),
              Image.asset(ImageRes.ic_next, width: 7.w, height: 13.h),
            ],
          ),
        ),
      );
}
