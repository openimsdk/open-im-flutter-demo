import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/pages/home/home_logic.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'contacts_logic.dart';

class ContactsPage extends StatelessWidget {
  final logic = Get.find<ContactsLogic>();
  final homeLogic = Get.find<HomeLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_FFFFFF,
      appBar: EnterpriseTitleBar.leftTitle(
        title: StrRes.contacts,
        actions: [
          TitleImageButton(
            imageStr: ImageRes.ic_searchGrey,
            imageWidth: 24.w,
            imageHeight: 24.h,
            color: Color(0xFF333333),
          ),
          TitleImageButton(
            imageStr: ImageRes.ic_addBlack,
            imageWidth: 24.w,
            imageHeight: 24.h,
            onTap: () => logic.toAddFriend(),
          ),
        ],
      ),
      body: Obx(() => CustomScrollView(
            slivers: [
              _buildGroupItem(
                icon: ImageRes.ic_newFriend,
                label: StrRes.newFriend,
                onTap: () => logic.toFriendApplicationList(),
                count: homeLogic.unhandledFriendApplicationCount.value,
              ),
              _buildGroupItem(
                icon: ImageRes.ic_groupApplicationNotification,
                label: StrRes.groupApplicationNotification,
                onTap: () => logic.viewGroupApplication(),
                count: homeLogic.unhandledGroupApplicationCount.value,
              ),
              _buildGroupItem(
                icon: ImageRes.ic_myFriend,
                label: StrRes.myFriend,
                onTap: () => logic.toMyFriendList(),
              ),
              _buildGroupItem(
                icon: ImageRes.ic_myGroup,
                label: StrRes.myGroup,
                onTap: () => logic.toMyGroupList(),
                showUnderline: false,
              ),
              _buildSubTitle(),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildContactsItem(
                      logic.frequentContacts.elementAt(index)),
                  childCount: logic.frequentContacts.length,
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildGroupItem({
    required String icon,
    required String label,
    int count = 0,
    Function()? onTap,
    bool showUnderline = true,
  }) =>
      SliverToBoxAdapter(
        child: _buildItemView(
            icon: icon,
            label: label,
            showUnderline: showUnderline,
            showUnreadCount: true,
            showRightArrow: true,
            viewType: 0,
            count: count,
            onTap: onTap),
      );

  Widget _buildContactsItem(UserInfo info) => Obx(() => _buildItemView(
        icon: info.faceURL!,
        label: info.getShowName(),
        showUnderline: true,
        showUnreadCount: false,
        showRightArrow: false,
        viewType: 2,
        key: info.userID,
        onlineStatus: logic.onlineStatusDesc[info.userID],
        onTap: () => logic.viewContactsInfo(info),
        onDismiss: () => logic.removeFrequentContacts(info),
      ));

  Widget _buildSubTitle() => SliverToBoxAdapter(
        child: Container(
          color: PageStyle.c_F8F8F8,
          // color: Color(0xFF1B72EC).withOpacity(0.12),
          padding: EdgeInsets.only(left: 22.w),
          height: 33.h,
          child: Row(
            children: [
              Text(
                StrRes.oftenContacts,
                style: PageStyle.ts_999999_12sp,
              )
            ],
          ),
        ),
      );

  Widget _buildItemView({
    required String icon,
    required String label,
    String? onlineStatus,
    int count = 0,
    Function()? onTap,
    bool showUnderline = true,
    bool showUnreadCount = true,
    bool showRightArrow = true,
    int viewType = 0,
    String? key,
    bool Function()? onDismiss,
  }) =>
      Ink(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: viewType == 2
              ? Dismissible(
                  key: Key(key!),
                  confirmDismiss: (direction) async {
                    return onDismiss!.call();
                  },
                  child: _buildChildView(
                    icon: icon,
                    label: label,
                    onlineStatus: onlineStatus,
                    count: count,
                    onTap: onTap,
                    showUnderline: showUnderline,
                    showRightArrow: showRightArrow,
                    showUnreadCount: showUnreadCount,
                    viewType: viewType,
                  ),
                )
              : _buildChildView(
                  icon: icon,
                  label: label,
                  onlineStatus: onlineStatus,
                  count: count,
                  onTap: onTap,
                  showUnderline: showUnderline,
                  showRightArrow: showRightArrow,
                  showUnreadCount: showUnreadCount,
                  viewType: viewType,
                ),
        ),
      );

  Widget _buildChildView({
    required String icon,
    required String label,
    String? onlineStatus,
    int count = 0,
    Function()? onTap,
    bool showUnderline = true,
    bool showUnreadCount = true,
    bool showRightArrow = true,
    int viewType = 0,
  }) =>
      Container(
        height: 61.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Row(
          children: [
            if (viewType == 2) AvatarView(size: 44.h, url: icon),
            if (viewType == 1)
              Container(
                width: 42.h,
                height: 42.h,
                child: Center(
                  child: Image.asset(icon, width: 24.h, height: 24.h),
                ),
              ),
            if (viewType == 0) Image.asset(icon, width: 42.h, height: 42.h),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: viewType == 2 ? 16.w : 18.w,
                ),
                alignment: Alignment.centerLeft,
                decoration: showUnderline
                    ? BoxDecoration(
                        border: BorderDirectional(
                          bottom: BorderSide(
                            color: Color(0xFFF1F1F1),
                            width: 1,
                          ),
                        ),
                      )
                    : null,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: viewType == 2
                              ? PageStyle.ts_333333_16sp
                              : PageStyle.ts_333333_18sp,
                        ),
                        if (viewType == 2 && null != onlineStatus)
                          Text(
                            onlineStatus,
                            style: PageStyle.ts_999999_12sp,
                          ),
                      ],
                    ),
                    Spacer(),
                    if (showUnreadCount)
                      Container(
                        margin: EdgeInsets.only(right: 5.w),
                        child: UnreadCountView(count: count),
                      ),
                    if (showRightArrow)
                      Image.asset(
                        ImageRes.ic_moreArrow,
                        width: 16.w,
                        height: 16.h,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
