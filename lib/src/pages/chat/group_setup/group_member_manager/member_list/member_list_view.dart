import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/group_member_info.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/azlist_view.dart';
import 'package:openim_demo/src/widgets/search_box.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:sprintf/sprintf.dart';

import 'member_list_logic.dart';

class GroupMemberListPage extends StatelessWidget {
  final logic = Get.find<GroupMemberListLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(),
      body: SafeArea(
        child: Obx(() => Column(
              children: [
                GestureDetector(
                  onTap: () => logic.search(),
                  behavior: HitTestBehavior.translucent,
                  child: SearchBox(
                    enabled: false,
                    margin: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 20.h),
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                  ),
                ),
                Expanded(
                  child: WrapAzListView<GroupMembersInfo>(
                    data: logic.memberList.value,
                    itemBuilder: (context, data, index) {
                      var disabled =
                          logic.defaultCheckedUidList.contains(data.userID);
                      return InkWell(
                        onTap:
                            disabled ? null : () => logic.selectedMember(index),
                        child: buildAzListItemView(
                          isMultiModel: logic.isMultiModel(),
                          name: data.nickname!,
                          url: data.faceURL,
                          checked: disabled
                              ? true
                              : logic.currentCheckedList.contains(data),
                          enabled: !disabled,
                        ),
                      );
                    },
                  ),
                ),
                if (logic.isMultiModel()) _buildCountView(),
              ],
            )),
      ),
    );
  }

  Widget _buildCountView() => Container(
        height: 47.h,
        color: PageStyle.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (logic.currentCheckedList.isNotEmpty)
                  Get.to(() => _ConfirmView());
              },
              behavior: HitTestBehavior.translucent,
              child: RichText(
                text: TextSpan(
                  text: sprintf(
                      StrRes.selectedNum, [logic.currentCheckedList.length]),
                  style: PageStyle.ts_1B72EC_14sp,
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.only(left: 7.w),
                        child: Image.asset(
                          ImageRes.ic_arrowUpBlue,
                          width: 12.w,
                          height: 12.h,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => logic.confirmSelected(),
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  top: 4.h,
                  bottom: 5.h,
                ),
                decoration: BoxDecoration(
                    color: PageStyle.c_1B72EC.withOpacity(
                      logic.currentCheckedList.isNotEmpty ? 1 : 0.7,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: PageStyle.c_000000_opacity15p,
                        blurRadius: 4,
                      ),
                    ]),
                child: Text(
                  logic.isMultiModelConfirm()
                      ? sprintf(
                          StrRes.confirmNum, [logic.curCount, logic.maxCount])
                      : StrRes.delete,
                  style: PageStyle.ts_FFFFFF_14sp,
                ),
              ),
            ),
          ],
        ),
      );
}

class _ConfirmView extends StatelessWidget {
  final logic = Get.find<GroupMemberListLogic>();

  _ConfirmView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_F6F6F6,
      appBar: EnterpriseTitleBar.back(
        showBackArrow: false,
        showShadow: false,
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: 28.h,
              width: 52.w,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                color: PageStyle.c_1B72EC,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                StrRes.sure,
                style: PageStyle.ts_FFFFFF_16sp,
                // style: TextStyle(
                //   background: Paint()..color = Colors.transparent,
                //   color: Colors.white,
                //   fontSize: 16.sp,
                // ),
              ),
            ),
          )
        ],
      ),
      body: Obx(() => ListView.builder(
            padding: EdgeInsets.only(top: 10.h),
            itemCount: logic.currentCheckedList.length,
            itemBuilder: (_, index) =>
                _buildItemView(logic.currentCheckedList.elementAt(index)),
          )),
    );
  }

  Widget _buildItemView(GroupMembersInfo info) => Container(
        color: PageStyle.c_FFFFFF,
        height: 75.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Row(
          children: [
            AvatarView(
              size: 44.h,
              url: info.faceURL,
            ),
            Expanded(
              child: Container(
                height: 75.h,
                margin: EdgeInsets.only(left: 14.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: PageStyle.c_F0F0F0,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      info.nickname!,
                      style: PageStyle.ts_333333_16sp,
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => logic.removeContacts(info),
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        height: 75.h,
                        alignment: Alignment.center,
                        child: Text(
                          StrRes.remove,
                          style: PageStyle.ts_E80000_16sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
