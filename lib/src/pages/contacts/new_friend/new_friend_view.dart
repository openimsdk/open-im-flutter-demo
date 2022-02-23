import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/search_box.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'new_friend_logic.dart';

class NewFriendPage extends StatelessWidget {
  final logic = Get.find<NewFriendLogic>();

  int _length() => logic.isExpanded.value
      ? logic.applicationList.length
      : (logic.applicationList.length > 4 ? 4 : logic.applicationList.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(title: StrRes.newFriend),
      backgroundColor: PageStyle.c_F8F8F8,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => logic.toSearchPage(),
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: PageStyle.c_FFFFFF,
                child: SearchBox(
                  hintText: StrRes.searchDescribe,
                  margin:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  enabled: false,
                ),
              ),
            ),
            _buildChildTitleView(),
            Obx(
              () => _buildHeightContainer(
                child: ListView.builder(
                  itemCount: _length(),
                  cacheExtent: 76.h,
                  itemBuilder: (_, i) => _buildItemView(
                    logic.applicationList.elementAt(i),
                    onTap: () => logic.onClickItem(i),
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: logic.canSeeMore.value && !logic.isExpanded.value,
                child: Container(
                  margin: EdgeInsets.only(top: 12.h),
                  child: Ink(
                    color: PageStyle.c_FFFFFF,
                    height: 43.h,
                    child: InkWell(
                      onTap: () => logic.expandedAll(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            StrRes.seeAllFriendRequests,
                            style: PageStyle.ts_1D6BED_14sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightContainer({required Widget child}) =>
      logic.isExpanded.value
          ? Expanded(child: child)
          : Container(
              child: child,
              height: (76 * 4).h,
            );

  Widget _buildItemView(FriendApplicationInfo info, {Function()? onTap}) => Ink(
        color: PageStyle.c_FFFFFF,
        height: 76.h,
        child: InkWell(
          onTap: info.isAgreed ? onTap : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                AvatarView(
                  size: 48.h,
                  url: info.fromFaceURL,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 12.w),
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        bottom: BorderSide(
                          color: Color(0xFFF1F1F1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                info.fromNickname!,
                                style: PageStyle.ts_333333_16sp,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (IMUtil.isNotNullStr(info.reqMsg))
                                Text(
                                  info.reqMsg!,
                                  style: PageStyle.ts_666666_12sp,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        if (info.isWaitingHandle)
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: onTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: PageStyle.c_999999,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                StrRes.accept,
                                style: PageStyle.ts_000000_12sp,
                              ),
                            ),
                          ),
                        if (info.isAgreed)
                          Text(
                            StrRes.greet,
                            style: PageStyle.ts_418AE5_12sp,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildChildTitleView() => Padding(
        padding: EdgeInsets.only(
          left: 22.w,
          top: 10.h,
          bottom: 10.h,
        ),
        child: Text(
          StrRes.newFriendApplication,
          style: PageStyle.ts_999999_12sp,
        ),
      );
}
