import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../select_contacts_logic.dart';
import 'friend_list_logic.dart';

class SelectContactsFromFriendsPage extends StatelessWidget {
  final logic = Get.find<SelectContactsFromFriendsLogic>();
  final selectContactsLogic = Get.find<SelectContactsLogic>();

  SelectContactsFromFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.myFriend),
      backgroundColor: Styles.c_F8F9FA,
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: logic.searchFriend,
            child: Container(
              color: Styles.c_FFFFFF,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: const SearchBox(),
            ),
          ),
          if (selectContactsLogic.isMultiModel)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Ink(
                height: 64.h,
                color: Styles.c_FFFFFF,
                child: InkWell(
                  onTap: logic.selectAll,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Obx(() => Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: ChatRadio(checked: logic.isSelectAll),
                        )),
                        10.horizontalSpace,
                        StrRes.selectAll.toText..style = Styles.ts_0C1C33_17sp,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Flexible(
            child: Obx(
                  () => WrapAzListView<ISUserInfo>(
                data: logic.friendList,
                itemCount: logic.friendList.length,
                itemBuilder: (_, data, index) => _buildItemView(data),
              ),
            ),
          ),
          selectContactsLogic.checkedConfirmView,
        ],
      ),
    );
  }

  Widget _buildItemView(ISUserInfo info) {
    Widget buildChild() => Ink(
      height: 64.h,
      color: Styles.c_FFFFFF,
      child: InkWell(
        onTap: selectContactsLogic.onTap(info),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              if (selectContactsLogic.isMultiModel)
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: ChatRadio(
                    checked: selectContactsLogic.isChecked(info),
                    enabled: !selectContactsLogic.isDefaultChecked(info),
                  ),
                ),
              AvatarView(
                url: info.faceURL,
                text: info.showName,
              ),
              10.horizontalSpace,
              info.showName.toText..style = Styles.ts_0C1C33_17sp,
            ],
          ),
        ),
      ),
    );
    return selectContactsLogic.isMultiModel ? Obx(buildChild) : buildChild();
  }
}
