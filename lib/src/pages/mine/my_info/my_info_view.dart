import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'my_info_logic.dart';

class MyInfoPage extends StatelessWidget {
  final logic = Get.find<MyInfoLogic>();
  final imLogic = Get.find<IMController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_F8F8F8,
      appBar: EnterpriseTitleBar.back(
        title: StrRes.myInfo,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 12.h,
              ),
              _buildItemView(
                label: StrRes.avatar,
                showAvatar: true,
                url: imLogic.userInfo.value.faceURL,
                onTap: () => logic.openPhotoSheet(),
              ),
              _buildItemView(
                label: StrRes.nickname,
                value: imLogic.userInfo.value.getShowName(),
                onTap: () => logic.setupUserName(),
              ),
              _buildItemView(
                label: StrRes.gender,
                value:
                    imLogic.userInfo.value.isMale ? StrRes.man : StrRes.woman,
                onTap: () => logic.selectGender(),
              ),
              _buildItemView(
                label: StrRes.birthday,
                value: '${imLogic.userInfo.value.birth}',
                onTap: () => logic.openDatePicker(),
              ),
              // if (imLogic.userInfo.value.mobile != null &&
              //     imLogic.userInfo.value.mobile!.isNotEmpty)
              _buildItemView(
                label: StrRes.phoneNum,
                value: imLogic.userInfo.value.phoneNumber,
                showArrow: false,
              ),
              // if (imLogic.userInfo.value.email != null &&
              //     imLogic.userInfo.value.email!.isNotEmpty)
              _buildItemView(
                label: StrRes.email,
                value: imLogic.userInfo.value.email,
                showArrow: false,
              ),
              _buildItemView(
                label: StrRes.qrcodeCarte,
                showQrIcon: true,
                onTap: () => logic.myQrcode(),
              ),
              _buildItemView(
                label: StrRes.idCode,
                onTap: () => logic.myID(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    String? value,
    String? url,
    bool showAvatar = false,
    bool showQrIcon = false,
    bool showArrow = true,
    Function()? onTap,
  }) =>
      Ink(
        height: 58.h,
        color: PageStyle.c_FFFFFF,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            decoration: BoxDecoration(
                border: BorderDirectional(
              bottom: BorderSide(
                color: PageStyle.c_999999_opacity40p,
                width: 0.5,
              ),
            )),
            child: Row(
              children: [
                Text(
                  label,
                  style: PageStyle.ts_333333_18sp,
                ),
                Spacer(),
                if (showAvatar)
                  AvatarView(
                    size: 40.h,
                    url: url,
                  ),
                if (showQrIcon)
                  Image.asset(
                    ImageRes.ic_mineQrCode,
                    width: 22.w,
                    height: 22.h,
                    color: PageStyle.c_999999,
                  ),
                if (null != value && value.isNotEmpty)
                  Text(
                    value,
                    style: PageStyle.ts_999999_16sp,
                  ),
                if (showArrow)
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: Image.asset(
                      ImageRes.ic_next,
                      width: 10.w,
                      height: 17.h,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
