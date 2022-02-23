import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'announcement_setup_logic.dart';

class GroupAnnouncementSetupPage extends StatelessWidget {
  final logic = Get.find<GroupAnnouncementSetupLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.groupAnnouncement,
        showShadow: false,
        actions: [
          _buildFinishedButton(),
        ],
      ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: Container(
        padding: EdgeInsets.symmetric(
          // vertical: 20.h,
          horizontal: 22.w,
        ),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                controller: logic.inputCtrl,
                style: PageStyle.ts_333333_18sp,
                decoration: InputDecoration(
                  hintText: StrRes.plsEditGroupAnnouncement,
                  hintStyle: PageStyle.ts_999999_18sp,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedButton() => Obx(
        () => Material(
          child: Ink(
            height: 26.h,
            // width: 46.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: PageStyle.c_1B72EC.withOpacity(
                logic.enabled.value ? 1 : 0.7,
              ),
            ),
            child: InkWell(
              onTap: logic.enabled.value ? () => logic.setAnnouncement() : null,
              child: Container(
                constraints: BoxConstraints(minWidth: 46.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Center(
                  child: Text(
                    StrRes.finished,
                    style: PageStyle.ts_FFFFFF_14sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
