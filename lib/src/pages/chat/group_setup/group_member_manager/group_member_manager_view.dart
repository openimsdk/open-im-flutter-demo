import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/group_member_info.dart' as me;
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/azlist_view.dart';
import 'package:openim_demo/src/widgets/search_box.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'group_member_manager_logic.dart';

class GroupMemberManagerPage extends StatelessWidget {
  final logic = Get.find<GroupMemberManagerLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: EnterpriseTitleBar.back(
          title: '${StrRes.groupMember}（${logic.allList.length}）',
          actions: [
            PopButton(
              popCtrl: logic.popCtrl,
              menuBgColor: Color(0xFFFFFFFF),
              showArrow: false,
              menuBgShadowColor: Color(0xFF000000).withOpacity(0.16),
              menuBgShadowBlurRadius: 6,
              menuBgShadowSpreadRadius: 2,
              menuItemTextStyle: PageStyle.ts_333333_14sp,
              menuItemHeight: 44.h,
              // menuItemWidth: 170.w,
              menuItemPadding: EdgeInsets.only(left: 20.w, right: 20.w),
              menuBgRadius: 6,
              menus: [
                PopMenuInfo(
                  text: StrRes.inviteMember,
                  onTap: () => logic.addMember(),
                ),
                if (logic.isMyGroup())
                  PopMenuInfo(
                    text: StrRes.removeMember,
                    onTap: () => logic.deleteMember(),
                  ),
              ],
              child: TitleImageButton(
                imageStr: ImageRes.ic_more,
                imageWidth: 20.w,
                imageHeight: 24.h,
                // height: 44.h,
              ),
            ),
          ],
        ),
        backgroundColor: PageStyle.c_FFFFFF,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: PageStyle.c_FFFFFF,
                child: GestureDetector(
                  onTap: () => logic.search(),
                  child: SearchBox(
                    enabled: false,
                    margin: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 12.h),
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                  ),
                ),
              ),
              Expanded(
                child: WrapAzListView<me.GroupMembersInfo>(
                  data: logic.allList.value,
                  itemBuilder: (_, data, index) =>
                      Obx(() => buildAzListItemView(
                            name: data.nickname!,
                            url: data.faceURL,
                            onTap: () => logic.viewUserInfo(index),
                            onlineStatus: logic.onlineStatus[data.userID],
                            tags: [
                              if (data.tagIndex == '↑')
                                _buildTagView(data.roleLevel!),
                            ],
                          )),
                ),
                //  child: ListView.builder(
                //     itemBuilder: (_, index) {
                //       var member = logic.memberList.elementAt(index);
                //       return Obx(() => _buildChildView(
                //             icon: member.faceUrl!,
                //             label: member.nickName!,
                //             onlineStatus: logic.onlineStatus[member.userId],
                //           ));
                //     },
                //   ),
              ),
              /* Container(
                padding: EdgeInsets.only(
                  left: 22.w,
                  right: 22.w,
                  bottom: 11.h,
                  top: 25.h,
                ),
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: PageStyle.c_979797_opacity50p,
                      width: 0.5,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: () => logic.search(),
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      Image.asset(
                        ImageRes.ic_searchGrey,
                        color: PageStyle.c_999999,
                        width: 21.h,
                        height: 21.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        StrRes.search,
                        style: PageStyle.ts_999999_18sp,
                      )
                    ],
                  ),
                ),
              ),*/
              /*Expanded(
                child: GridView.builder(
                  itemCount: logic.length(),
                  // padding: EdgeInsets.zero,
                  padding: EdgeInsets.only(
                    left: 22.w,
                    right: 22.w,
                    top: 20.h,
                    bottom: 20.h,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    // childAspectRatio: 61/42,
                  ),
                  itemBuilder: (context, index) {
                    if (index < logic.memberList.length) {
                      var info = logic.memberList.elementAt(index);
                      return _buildItem(
                        url: info.faceUrl,
                        label: info.nickName,
                        onTap: () => logic.viewUserInfo(index),
                      );
                    } else if (index == logic.memberList.length) {
                      return _buildItem(
                        isMember: false,
                        btnImgRes: ImageRes.ic_memberAdd,
                        onTap: () => logic.addMember(),
                      );
                    } else {
                      return _buildItem(
                        isMember: false,
                        btnImgRes: ImageRes.ic_memberDel,
                        onTap: () => logic.deleteMember(),
                      );
                    }
                  },
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  /// 1 ordinary member, 2 group owners, 3 administrators
  /// 1普通成员, 2群组，3管理员
  Widget _buildTagView(int roleLevel) => Container(
        height: 17.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          color: roleLevel == 2 ? PageStyle.c_FDDFA1 : PageStyle.c_A2C9F8,
          borderRadius: BorderRadius.circular(8.5),
        ),
        child: Text(
          roleLevel == 2 ? StrRes.groupOwner : StrRes.groupAdmin,
          style: roleLevel == 2
              ? PageStyle.ts_FF8C00_10sp
              : PageStyle.ts_2691ED_10sp,
        ),
      );

  Widget _buildChildView({
    required String icon,
    required String label,
    String? onlineStatus,
    Function()? onTap,
  }) =>
      Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Row(
          children: [
            AvatarView(size: 42.h, url: icon),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 18.w),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: Color(0xFFF1F1F1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: PageStyle.ts_333333_16sp,
                        ),
                        if (null != onlineStatus)
                          Text(
                            '[$onlineStatus]',
                            style: PageStyle.ts_999999_12sp,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

/* Widget _buildItem({
    String? url,
    String? btnImgRes,
    String? label,
    bool isMember = true,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: Column(
            children: [
              if (isMember)
                AvatarView(
                  size: 42.h,
                  url: url,
                  lowMemory: true,
                ),
              if (!isMember && null != btnImgRes)
                Image.asset(
                  btnImgRes,
                  width: 42.h,
                  height: 42.h,
                ),
              Container(
                width: 70.w,
                alignment: Alignment.center,
                child: Text(
                  label ?? '',
                  style: PageStyle.ts_999999_12sp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );*/
}
