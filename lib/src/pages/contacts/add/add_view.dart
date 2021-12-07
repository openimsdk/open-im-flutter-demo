import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'add_logic.dart';

class AddContactsPage extends StatelessWidget {
  final logic = Get.find<AddContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_F8F8F8,
      appBar: EnterpriseTitleBar.back(
        title: StrRes.add,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChildTitleView(StrRes.createAndJoinGroup),
          _buildItemView(
            icon: ImageRes.ic_createGroup,
            label: StrRes.createGroup,
            describe: StrRes.createGroupDescribe,
            onTap: () => logic.crateGroup(),
          ),
          _buildItemView(
            icon: ImageRes.ic_joinGroup,
            label: StrRes.joinGroup,
            describe: StrRes.joinGroupDescribe,
            onTap: () => logic.joinGroup(),
          ),
          _buildChildTitleView(StrRes.addFriend),
          _buildItemView(
            icon: ImageRes.ic_searchGrey,
            label: StrRes.search,
            describe: StrRes.searchDescribe,
            color: Color(0xFF418AE5),
            onTap: () => logic.toSearchPage(),
          ),
          _buildItemView(
            icon: ImageRes.ic_scan,
            label: StrRes.scan,
            describe: StrRes.scanDescribe,
            onTap: () => logic.toScanQrcode(),
          ),
        ],
      ),
    );
  }

  Widget _buildChildTitleView(String title) => Padding(
        padding: EdgeInsets.only(
          left: 22.w,
          top: 10.h,
          bottom: 10.h,
        ),
        child: Text(
          title,
          style: PageStyle.ts_999999_12sp,
        ),
      );

  Widget _buildItemView({
    required String icon,
    required String label,
    required String describe,
    Color? color,
    Function()? onTap,
  }) =>
      Ink(
        height: 74.h,
        color: PageStyle.c_FFFFFF,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  width: 28.h,
                  height: 28.h,
                  color: color,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 23.w),
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
                              style: PageStyle.ts_333333_18sp,
                            ),
                            Text(
                              describe,
                              style: PageStyle.ts_999999_12sp,
                            ),
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          ImageRes.ic_next,
                          width: 16.w,
                          height: 16.h,
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
}
