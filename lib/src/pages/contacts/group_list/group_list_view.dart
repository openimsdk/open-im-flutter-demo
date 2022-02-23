import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/search_box.dart';
import 'package:openim_demo/src/widgets/tabbar.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:sprintf/sprintf.dart';

import 'group_list_logic.dart';

class GroupListPage extends StatelessWidget {
  final logic = Get.find<GroupListLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.myGroup,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => logic.createGroup(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                StrRes.launchGroup,
                style: PageStyle.ts_333333_18sp,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => logic.searchGroup(),
                child: SearchBox(
                  enabled: false,
                  hintText: StrRes.searchGroupHint,
                  margin: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 0),
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                ),
              ),
              CustomTabBar(
                labels: [StrRes.iCreateGroup, StrRes.iJoinGroup],
                index: logic.index.value,
                onTabChanged: (i) => logic.switchTab(i),
              ),
              SizedBox(
                height: 12.h,
              ),
              Expanded(
                child: IndexedStack(
                  index: logic.index.value,
                  children: [
                    _buildICreatedListView(),
                    _buildIJoinedListView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildICreatedListView() => ListView.builder(
        itemCount: logic.iCreatedList.length,
        itemBuilder: (_, index) =>
            _buildItemView(logic.iCreatedList.elementAt(index)),
      );

  Widget _buildIJoinedListView() => ListView.builder(
        itemCount: logic.iJoinedList.length,
        itemBuilder: (_, index) =>
            _buildItemView(logic.iJoinedList.elementAt(index)),
      );

  Widget _buildItemView(GroupInfo info) => Ink(
        height: 68.h,
        color: PageStyle.c_FFFFFF,
        child: InkWell(
          onTap: () => logic.toGroupChat(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                AvatarView(
                  size: 44.h,
                  url: info.faceURL,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16.w),
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        bottom: BorderSide(
                          color: PageStyle.c_F1F1F1,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          info.groupName ?? '',
                          style: PageStyle.ts_333333_16sp,
                        ),
                        Text(
                          sprintf(StrRes.xPerson, [info.memberCount]),
                          style: PageStyle.ts_999999_14sp,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
