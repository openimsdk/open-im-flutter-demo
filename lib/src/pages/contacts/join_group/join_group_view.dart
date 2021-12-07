import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'jion_group_logic.dart';

class JoinGroupPage extends StatelessWidget {
  final logic = Get.find<JoinGroupLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.joinGroup,
      ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: Column(
        children: [
          _buildItemView(
            icon: ImageRes.ic_scanGroupQrcode,
            label: StrRes.scanQrcodeJoin,
            describe: StrRes.scanQrCodeJoinHint,
            onTap: logic.scanner,
          ),
          _buildItemView(
            icon: ImageRes.ic_groupID,
            label: StrRes.groupIdJoin,
            describe: StrRes.groupIdJoinHint,
            showUnderline: false,
            onTap: logic.search,
          ),
        ],
      ),
    );
  }

  Widget _buildItemView({
    required String icon,
    required String label,
    required String describe,
    Color? color,
    Function()? onTap,
    bool showUnderline = true,
  }) =>
      Ink(
        height: 77.h,
        color: PageStyle.c_FFFFFF,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  width: 46.h,
                  height: 46.h,
                  color: color,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 14.w),
                    decoration: showUnderline
                        ? BoxDecoration(
                            border: BorderDirectional(
                              bottom: BorderSide(
                                color: Color(0xFFF1F1F1),
                                width: 1,
                              ),
                            ),
                          )
                        : null,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              style: PageStyle.ts_333333_18sp,
                            ),
                            Text(
                              describe,
                              style: PageStyle.ts_999999_12sp,
                            ),
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          ImageRes.ic_next,
                          width: 16.w,
                          height: 16.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
