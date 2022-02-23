import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/azlist_view.dart';
import 'package:openim_demo/src/widgets/search_box.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'friend_list_logic.dart';

class MyFriendListPage extends StatelessWidget {
  final logic = Get.find<MyFriendListLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.myFriend,
      ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => logic.searchFriend(),
              behavior: HitTestBehavior.translucent,
              child: Container(
                // color: PageStyle.listViewItemBgColor,
                child: SearchBox(
                  hintText: StrRes.searchFriend,
                  margin:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  enabled: false,
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => WrapAzListView<ContactsInfo>(
                  data: logic.friendList.value,
                  itemBuilder: (_, data, index) =>
                      Obx(() => buildAzListItemView(
                            name: data.getShowName(),
                            url: data.faceURL,
                            onTap: () => logic.viewFriendInfo(index),
                            onlineStatus: logic.onlineStatus[data.userID],
                          )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
