import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/search_box.dart';
import 'package:openim_demo/src/widgets/tabbar.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:sprintf/sprintf.dart';

import 'friend_list/friend_list_view.dart';
import 'group_list/group_list_view.dart';
import 'select_contacts_logic.dart';

class SelectContactsPage extends StatelessWidget {
  final logic = Get.find<SelectContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(),
      backgroundColor: PageStyle.c_FFFFFF,
      body: SafeArea(
        child: Obx(() => Column(
              children: [
                SearchBox(
                  enabled: false,
                  margin: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 0),
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                ),
                if (!logic.isMultiModel())
                  CustomTabBar(
                    labels: [StrRes.selectByFriends, StrRes.selectByGroup],
                    index: logic.index.value,
                    onTabChanged: (i) => logic.switchTab(i),
                  ),
                if (logic.isMultiModel())
                  CustomTabBar2(
                    index: logic.index.value,
                    onTabChanged: (i) => logic.switchTab(i),
                    margin: EdgeInsets.only(top: 21.h, bottom: 13.h),
                    tabs: [
                      TabInfo(
                        label: StrRes.selectByFriends,
                        styleSel: PageStyle.ts_333333_14sp,
                        styleUnsel: PageStyle.ts_333333_14sp,
                        iconSel: ImageRes.ic_tabSelFriend,
                        iconUnsel: ImageRes.ic_tabUnselFriend,
                        iconHeight: 50.h,
                        iconWidth: 50.w,
                      ),
                      TabInfo(
                        label: StrRes.selectByGroup,
                        styleSel: PageStyle.ts_333333_14sp,
                        styleUnsel: PageStyle.ts_333333_14sp,
                        iconSel: ImageRes.ic_tabSelGroup,
                        iconUnsel: ImageRes.ic_tabUnselGroup,
                        iconHeight: 50.h,
                        iconWidth: 50.w,
                      ),
                    ],
                  ),
                Expanded(
                  child: IndexedStack(
                    index: logic.index.value,
                    children: [
                      FriendListView(),
                      GroupListView(),
                    ],
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
                if (logic.checkedList.isNotEmpty) Get.to(() => _ConfirmView());
              },
              behavior: HitTestBehavior.translucent,
              child: RichText(
                text: TextSpan(
                  text: sprintf(StrRes.selectedNum, [logic.checkedList.length]),
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
                  left: 6.w,
                  right: 3.w,
                  top: 4.h,
                  bottom: 5.h,
                ),
                decoration: BoxDecoration(
                    color: PageStyle.c_1B72EC.withOpacity(
                      logic.checkedList.isNotEmpty ? 1 : 0.7,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: PageStyle.c_000000_opacity15p,
                        blurRadius: 4,
                      ),
                    ]),
                child: Text(
                  sprintf(StrRes.confirmNum, [logic.checkedList.length, 998]),
                  style: PageStyle.ts_FFFFFF_14sp,
                ),
              ),
            ),
          ],
        ),
      );
}

class _ConfirmView extends StatelessWidget {
  final logic = Get.find<SelectContactsLogic>();

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
            itemCount: logic.checkedList.length,
            itemBuilder: (_, index) =>
                _buildItemView(logic.checkedList.elementAt(index)),
          )),
    );
  }

  Widget _buildItemView(ContactsInfo info) => Container(
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
                      info.getShowName(),
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
