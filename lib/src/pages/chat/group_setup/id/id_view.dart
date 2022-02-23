import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'id_logic.dart';

class GroupIDPage extends StatelessWidget {
  final logic = Get.find<GroupIDLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.groupIDCode,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 58.h, left: 22.w, right: 22.w),
            decoration: BoxDecoration(
              color: PageStyle.c_FFFFFF,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: PageStyle.c_000000_opacity8p,
                  blurRadius: 7,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 35.w,
                    right: 35.w,
                    top: 35.w,
                    bottom: 67.h,
                  ),
                  child: Row(
                    children: [
                      AvatarView(
                        size: 50.h,
                        url: logic.info.faceURL,
                      ),
                      SizedBox(
                        width: 18.w,
                      ),
                      Text(
                        logic.info.groupName ?? '',
                        style: PageStyle.ts_000000_20sp,
                      ),
                    ],
                  ),
                ),
                Text(
                  StrRes.groupIDTips,
                  style: PageStyle.ts_999999_14sp,
                ),
                SizedBox(
                  height: 28.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 47.w),
                  child: Text(
                    logic.info.groupID,
                    style: PageStyle.ts_333333_28sp,
                  ),
                ),
                SizedBox(
                  height: 89.h,
                ),
                Material(
                  child: Ink(
                    height: 44.h,
                    width: 230.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: PageStyle.c_1B72EC,
                    ),
                    child: InkWell(
                      onTap: () => logic.copy(),
                      child: Center(
                        child: Text(
                          StrRes.copyGroupID,
                          style: PageStyle.ts_FFFFFF_18sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 78.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
