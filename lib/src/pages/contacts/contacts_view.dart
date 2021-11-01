import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/pages/home/home_logic.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/avatar_view.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'contacts_logic.dart';

class ContactsPage extends StatelessWidget {
  final logic = Get.find<ContactsLogic>();
  final homeLogic = Get.find<HomeLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                count: homeLogic.unhandledApplicationCount.value,
              ),
              _buildLine(),
              _buildGroupItem(
                icon: ImageRes.ic_myFriend,
                label: StrRes.myFriend,
                onTap: () => logic.toMyFriendList(),
              ),
              _buildLine(),
              _buildGroupItem(
                icon: ImageRes.ic_myGroup,
                label: StrRes.myGroup,
                onTap: () => logic.toMyGroupList(),
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
  }) =>
      SliverToBoxAdapter(
        child: Ink(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 64.h,
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Row(
                children: [
                  Image.asset(
                    icon,
                    width: 42.h,
                    height: 42.h,
                  ),
                  SizedBox(
                    width: 18.w,
                  ),
                  Text(
                    label,
                    style: PageStyle.ts_333333_18sp,
                  ),
                  Spacer(),
                  UnreadCountView(count: count),
                  SizedBox(
                    width: 5.w,
                  ),
                  Image.asset(
                    ImageRes.ic_next,
                    width: 7.w,
                    height: 13.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildLine() => SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 82.w, right: 22.w),
          color: Color(0xFFF1F1F1),
          height: 1,
        ),
      );

  Widget _buildSubTitle() => SliverToBoxAdapter(
        child: Container(
          color: Color(0xFF1B72EC).withOpacity(0.12),
          padding: EdgeInsets.only(left: 22.w),
          height: 23.h,
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

  Widget _buildContactsItem(UserInfo info) => Ink(
        height: 64.h,
        child: InkWell(
          onTap: () => logic.viewContactsInfo(info),
          child: Dismissible(
            key: Key(info.uid),
            confirmDismiss: (direction) async {
              return logic.removeFrequentContacts(info);
            },
            child: Row(
              children: [
                SizedBox(
                  width: 22.w,
                ),
                AvatarView(
                  size: 44.h,
                  url: info.icon,
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
          ),
        ),
      );
}
