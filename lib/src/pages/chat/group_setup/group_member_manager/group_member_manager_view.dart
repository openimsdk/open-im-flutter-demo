import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/avatar_view.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'group_member_manager_logic.dart';

class GroupMemberManagerPage extends StatelessWidget {
  final logic = Get.find<GroupMemberManagerLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: EnterpriseTitleBar.back(
          title: '${StrRes.groupMember}（${logic.memberList.length}）',
        ),
        backgroundColor: PageStyle.c_FFFFFF,
        body: SafeArea(
          child: Column(
            children: [
              Container(
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
            ),
            Expanded(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
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
      );
}
