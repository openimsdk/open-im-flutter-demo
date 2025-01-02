import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import 'group_member_list_logic.dart';

class GroupMemberListPage extends StatelessWidget {
  final logic = Get.find<GroupMemberListLogic>(tag: (Get.arguments['opType'] as GroupMemberOpType).name);

  GroupMemberListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: logic.opType == GroupMemberOpType.del ? StrRes.removeGroupMember : StrRes.groupMember,
            right: logic.opType == GroupMemberOpType.view
                ? PopButton(
                    popCtrl: logic.poController,
                    horizontalMargin: 1.w,
                    menus: [
                      PopMenuInfo(text: StrRes.addMember, onTap: logic.addMember),
                      if (logic.isOwnerOrAdmin) PopMenuInfo(text: StrRes.delMember, onTap: logic.delMember),
                    ],
                    child: ImageRes.moreBlack.toImage
                      ..width = 28.w
                      ..height = 28.h)
                : null,
          ),
          backgroundColor: Styles.c_F8F9FA,
          body: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: logic.search,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  color: Styles.c_FFFFFF,
                  child: const SearchBox(),
                ),
              ),
              if (logic.opType == GroupMemberOpType.at && logic.isOwnerOrAdmin)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: logic.selectEveryone,
                  child: Container(
                    height: 64.h,
                    color: Styles.c_FFFFFF,
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        AvatarView(
                          width: 44.w,
                          height: 44.h,
                          text: '@',
                          textStyle: Styles.ts_FFFFFF_21sp,
                        ),
                        10.horizontalSpace,
                        StrRes.everyone.toText..style = Styles.ts_0C1C33_17sp,
                      ],
                    ),
                  ),
                ),
              Flexible(
                child: SmartRefresher(
                  controller: logic.controller,
                  onLoading: logic.onLoad,
                  enablePullDown: false,
                  enablePullUp: true,
                  header: IMViews.buildHeader(),
                  footer: IMViews.buildFooter(),
                  child: ListView.builder(
                    itemCount: logic.memberList.length,
                    itemBuilder: (_, index) => Obx(() => _buildItemView(logic.memberList[index])),
                  ),
                ),
              ),
              if (logic.isMultiSelMode) _buildCheckedConfirmView(),
            ],
          ),
        ));
  }

  Widget _buildItemView(GroupMembersInfo membersInfo) => logic.hiddenMember(membersInfo)
      ? const SizedBox()
      : GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => logic.clickMember(membersInfo),
          child: Container(
            height: 64.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            color: Styles.c_FFFFFF,
            child: Row(
              children: [
                if (logic.isMultiSelMode)
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: ChatRadio(checked: logic.isChecked(membersInfo)),
                  ),
                AvatarView(
                  url: membersInfo.faceURL,
                  text: membersInfo.nickname,
                ),
                10.horizontalSpace,
                Expanded(
                  child: (membersInfo.nickname ?? '').toText
                    ..style = Styles.ts_0C1C33_17sp
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis,
                ),
                if (membersInfo.roleLevel == GroupRoleLevel.owner)
                  StrRes.groupOwner.toText..style = Styles.ts_8E9AB0_17sp,
                if (membersInfo.roleLevel == GroupRoleLevel.admin)
                  StrRes.groupAdmin.toText..style = Styles.ts_8E9AB0_17sp,
              ],
            ),
          ),
        );

  Widget _buildCheckedConfirmView() => Container(
        height: 66.h,
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1.h),
              blurRadius: 4.r,
              spreadRadius: 1.r,
              color: Styles.c_000000_opacity4,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Get.bottomSheet(
                  SelectedMemberListView(),
                  isScrollControlled: true,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        sprintf(StrRes.selectedPeopleCount, [logic.checkedList.length]).toText
                          ..style = Styles.ts_0089FF_14sp,
                        ImageRes.expandUpArrow.toImage
                          ..width = 24.w
                          ..height = 24.h,
                      ],
                    ),
                    if (logic.checkedList.isNotEmpty) 4.verticalSpace,
                    logic.checkedList.map((e) => e.nickname ?? '').join('、').toText
                      ..style = Styles.ts_8E9AB0_14sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis,
                  ],
                ),
              ),
            ),
            Button(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              text: sprintf(StrRes.confirmSelectedPeople, [
                logic.checkedList.length,
                logic.maxLength,
              ]),
              textStyle: Styles.ts_FFFFFF_14sp,
              onTap: logic.confirmSelectedMember,
            ),
          ],
        ),
      );
}

class SelectedMemberListView extends StatelessWidget {
  SelectedMemberListView({Key? key}) : super(key: key);
  final logic = Get.find<GroupMemberListLogic>(tag: (Get.arguments['opType'] as GroupMemberOpType).name);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 548.h),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.r),
          topRight: Radius.circular(6.r),
        ),
      ),
      child: Obx(() => Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(color: Styles.c_E8EAEF, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    sprintf(StrRes.selectedPeopleCount, [logic.checkedList.length]).toText
                      ..style = Styles.ts_0C1C33_17sp_medium,
                    const Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.back(),
                      child: Container(
                        height: 52.h,
                        alignment: Alignment.center,
                        child: StrRes.confirm.toText..style = Styles.ts_0089FF_17sp,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: logic.checkedList.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) => _buildItemView(logic.checkedList[index]),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildItemView(GroupMembersInfo membersInfo) => Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        color: Styles.c_FFFFFF,
        child: Row(
          children: [
            AvatarView(
              url: membersInfo.faceURL,
              text: membersInfo.nickname,
            ),
            10.horizontalSpace,
            Expanded(
              child: (membersInfo.nickname ?? '').toText
                ..style = Styles.ts_0C1C33_17sp
                ..maxLines = 1
                ..overflow = TextOverflow.ellipsis,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => logic.removeSelectedMember(membersInfo),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r),
                  border: Border.all(
                    color: Styles.c_E8EAEF,
                    width: 1,
                  ),
                ),
                child: StrRes.remove.toText..style = Styles.ts_0089FF_17sp,
              ),
            ),
          ],
        ),
      );
}
