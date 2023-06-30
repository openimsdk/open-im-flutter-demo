import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../contacts/contacts_view.dart';
import '../conversation/conversation_view.dart';
import '../mine/mine_view.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Styles.c_FFFFFF,
          body: IndexedStack(
            index: logic.index.value,
            children: [
              ConversationPage(),
              ContactsPage(),
              MinePage(),
            ],
          ),
          bottomNavigationBar: BottomBar(
            index: logic.index.value,
            items: [
              BottomBarItem(
                selectedImgRes: ImageRes.homeTab1Sel,
                unselectedImgRes: ImageRes.homeTab1Nor,
                label: StrRes.home,
                imgWidth: 28.w,
                imgHeight: 28.h,
                onClick: logic.switchTab,
                onDoubleClick: logic.scrollToUnreadMessage,
                count: logic.unreadMsgCount.value,
              ),
              BottomBarItem(
                selectedImgRes: ImageRes.homeTab2Sel,
                unselectedImgRes: ImageRes.homeTab2Nor,
                label: StrRes.contacts,
                imgWidth: 28.w,
                imgHeight: 28.h,
                onClick: logic.switchTab,
                count: logic.unhandledCount.value,
              ),
              BottomBarItem(
                selectedImgRes: ImageRes.homeTab4Sel,
                unselectedImgRes: ImageRes.homeTab4Nor,
                label: StrRes.mine,
                imgWidth: 28.w,
                imgHeight: 28.h,
                onClick: logic.switchTab,
              ),
            ],
          ),
        ));
  }
}
