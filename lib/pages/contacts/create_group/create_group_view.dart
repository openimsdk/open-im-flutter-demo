import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'create_group_logic.dart';

class CreateGroupPage extends StatelessWidget {
  final logic = Get.find<CreateGroupLogic>();

  CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.back(title: StrRes.createGroup),
        backgroundColor: Styles.c_F8F9FA,
        body: SingleChildScrollView(
          child: SizedBox(
            height: 1.sh - 44.h - 10.h - 34.h,
            child: Column(
              children: [
                _buildGroupBaseInfoView(),
                _buildGroupMemberView(),
                const Spacer(),
                Container(
                  color: Styles.c_FFFFFF,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Button(
                    text: StrRes.completeCreation,
                    onTap: logic.completeCreation,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupBaseInfoView() => Container(
        margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Obx(() => Row(
              children: [
                if (logic.faceURL.isNotEmpty)
                  AvatarView(
                    width: 48.w,
                    height: 48.h,
                    url: logic.faceURL.value,
                    onTap: logic.selectAvatar,
                  )
                else
                  ImageRes.cameraGray.toImage
                    ..width = 48.w
                    ..height = 48.h
                    ..onTap = logic.selectAvatar,
                12.horizontalSpace,
                Flexible(
                  child: TextField(
                    style: Styles.ts_0C1C33_17sp,
                    autofocus: true,
                    controller: logic.nameCtrl,
                    inputFormatters: [LengthLimitingTextInputFormatter(16)],
                    decoration: InputDecoration(
                      hintStyle: Styles.ts_8E9AB0_17sp,
                      hintText: StrRes.plsEnterGroupNameHint,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            )),
      );

  Widget _buildGroupMemberView() => Obx(() => Container(
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  StrRes.groupMember.toText..style = Styles.ts_8E9AB0_17sp,
                  const Spacer(),
                  sprintf(StrRes.nPerson, [logic.allList.length]).toText..style = Styles.ts_8E9AB0_17sp,
                ],
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logic.length(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 68.w / 78.h,
              ),
              itemBuilder: (BuildContext context, int index) {
                return logic.itemBuilder(
                  index: index,
                  builder: (info) => Column(
                    children: [
                      AvatarView(
                        width: 48.w,
                        height: 48.h,
                        url: info.faceURL,
                        text: info.nickname,
                        textStyle: Styles.ts_FFFFFF_14sp,
                      ),
                      2.verticalSpace,
                      (info.nickname ?? '').toText
                        ..style = Styles.ts_8E9AB0_10sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                    ],
                  ),
                  addButton: () => const SizedBox.shrink(),
                  delButton: () => const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ));
}
