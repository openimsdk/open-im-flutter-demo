import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'search_add_group_logic.dart';

class SearchAddGroupPage extends StatelessWidget {
  final logic = Get.find<SearchAddGroupLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        showShadow: false,
      ),
      backgroundColor: PageStyle.c_F6F6F6,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 100.h,
                  color: PageStyle.c_FFFFFF,
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Row(
                    children: [
                      AvatarView(
                        size: 48.h,
                        url: logic.info.value.faceURL,
                      ),
                      SizedBox(
                        width: 26.w,
                      ),
                      Text(
                        '${logic.info.value.groupName ?? ''}(${logic.info.value.memberCount ?? 0})',
                        style: PageStyle.ts_333333_20sp,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.sw,
                  height: 55.h,
                  color: PageStyle.c_FFFFFF,
                  margin: EdgeInsets.only(top: 12.h),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Text.rich(TextSpan(
                      text: StrRes.groupIDCode,
                      style: PageStyle.ts_333333_18sp,
                      children: [
                        WidgetSpan(
                          child: SizedBox(
                            width: 10.w,
                          ),
                        ),
                        TextSpan(
                          text: logic.info.value.groupID,
                          style: PageStyle.ts_ADADAD_18sp,
                        ),
                      ])),
                ),
                Container(
                  height: 93.h,
                  color: PageStyle.c_FFFFFF,
                  margin: EdgeInsets.only(top: 12.h),
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 9.h,
                        child: Text(
                          StrRes.groupMember,
                          style: PageStyle.ts_000000_13sp,
                        ),
                      ),
                      Positioned(
                        top: 39.h,
                        child: Obx(() => Row(
                              children: List.generate(
                                  logic.members.length > 5
                                      ? 5
                                      : logic.members.length,
                                  (index) => Container(
                                        margin: EdgeInsets.only(
                                          right: index == 4 ? 0 : 6.w,
                                        ),
                                        child: AvatarView(
                                          size: 42.h,
                                          url: logic.members
                                              .elementAt(index)
                                              .faceURL,
                                        ),
                                      )),
                            )),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: logic.enterGroup,
                  child: Container(
                    height: 43.h,
                    margin: EdgeInsets.only(top: 171.h),
                    color: PageStyle.c_FFFFFF,
                    alignment: Alignment.center,
                    child: Text(
                      logic.isJoined.value
                          ? StrRes.enterGroup
                          : StrRes.applyJoin,
                      style: PageStyle.ts_1D6BED_14sp,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
