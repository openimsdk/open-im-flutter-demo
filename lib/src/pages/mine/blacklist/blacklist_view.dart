import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'blacklist_logic.dart';

class BlacklistPage extends StatelessWidget {
  final logic = Get.find<BlacklistLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.blacklist,
        showShadow: false,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: Obx(() => logic.blacklist.isEmpty
          ? Center(
              child: Column(
                // mainAxisSize: MainAxisSize.,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageRes.ic_emptyBlacklist,
                    width: 128.w,
                    height: 99.h,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Text(
                      StrRes.blacklistHint,
                      style: PageStyle.ts_999999_16sp,
                    ),
                  )
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 12.h),
              itemCount: logic.blacklist.length,
              itemBuilder: (_, index) =>
                  _buildContactsItem(index, logic.blacklist.elementAt(index)),
            )),
    );
  }

  Widget _buildContactsItem(int index, UserInfo info) => Dismissible(
      key: Key(info.userID!),
      // background: Container(color: Colors.red),
      confirmDismiss: (direction) async {
        return logic.remove(info);
      },
      child: Container(
        height: 68.h,
        color: PageStyle.c_FFFFFF,
        child: Row(
          children: [
            SizedBox(
              width: 22.w,
            ),
            AvatarView(
              size: 44.h,
              url: info.faceURL,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 14.w),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: PageStyle.c_F0F0F0,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  info.getShowName(),
                  style: PageStyle.ts_333333_16sp,
                ),
              ),
            ),
          ],
        ),
      ));
}
