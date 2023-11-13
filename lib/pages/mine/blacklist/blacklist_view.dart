import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'blacklist_logic.dart';

class BlacklistPage extends StatelessWidget {
  final logic = Get.find<BlacklistLogic>();

  BlacklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.blacklist),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => logic.blacklist.isEmpty
          ? _emptyListView
          : ListView.builder(
              padding: EdgeInsets.only(top: 10.h),
              itemCount: logic.blacklist.length,
              itemBuilder: (_, index) => _buildItemView(
                logic.blacklist[index],
                underline: index != logic.blacklist.length - 1,
              ),
            )),
    );
  }

  Widget _buildItemView(
    BlacklistInfo info, {
    bool underline = true,
  }) =>
      Ink(
        height: 62.h,
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          border: underline
              ? BorderDirectional(
                  bottom: BorderSide(
                    color: Styles.c_E8EAEF,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: InkWell(
          onTap: () => logic.remove(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                AvatarView(
                  width: 44.w,
                  height: 44.h,
                  text: info.nickname,
                  url: info.faceURL,
                ),
                12.horizontalSpace,
                Expanded(
                  child: (info.nickname ?? '').toText..style = Styles.ts_0C1C33_17sp,
                ),
                StrRes.remove.toText..style = Styles.ts_0089FF_17sp,
              ],
            ),
          ),
        ),
      );

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            157.verticalSpace,
            ImageRes.blacklistEmpty.toImage
              ..width = 120.w
              ..height = 120.h,
            22.verticalSpace,
            StrRes.blacklistEmpty.toText..style = Styles.ts_8E9AB0_16sp,
          ],
        ),
      );
}
