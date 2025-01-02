import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:search_keyword_text/search_keyword_text.dart';

import 'search_group_member_logic.dart';

class SearchGroupMemberPage extends StatelessWidget {
  final logic = Get.find<SearchGroupMemberLogic>();

  SearchGroupMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.search(
          focusNode: logic.focusNode,
          controller: logic.searchCtrl,
          onSubmitted: (_) => logic.search(),
          onCleared: () => logic.focusNode.requestFocus(),
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: Obx(() => logic.isSearchNotResult
            ? _emptyListView
            : SmartRefresher(
                controller: logic.controller,
                enablePullUp: true,
                enablePullDown: false,
                footer: IMViews.buildFooter(),
                onLoading: logic.load,
                child: ListView.builder(
                  itemCount: logic.memberList.length,
                  itemBuilder: (_, index) {
                    final info = logic.memberList.elementAt(index);
                    if (logic.hiddenMembers(info)) {
                      return const SizedBox();
                    } else {
                      return _buildItemView(info);
                    }
                  },
                ),
              )),
      ),
    );
  }

  Widget _buildItemView(GroupMembersInfo membersInfo) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => logic.clickMember(membersInfo),
        child: Container(
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
                child: SearchKeywordText(
                  text: membersInfo.nickname ?? '',
                  keyText: logic.searchCtrl.text.trim(),
                  style: Styles.ts_0C1C33_17sp,
                  keyStyle: Styles.ts_0089FF_17sp,
                ),
              ),
              if (membersInfo.roleLevel == GroupRoleLevel.owner)
                StrRes.groupOwner.toText..style = Styles.ts_8E9AB0_17sp,
              if (membersInfo.roleLevel == GroupRoleLevel.admin)
                StrRes.groupAdmin.toText..style = Styles.ts_8E9AB0_17sp,
            ],
          ),
        ),
      );

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            44.verticalSpace,
            StrRes.searchNotFound.toText..style = Styles.ts_8E9AB0_17sp,
          ],
        ),
      );
}
