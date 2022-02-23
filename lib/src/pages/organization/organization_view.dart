import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/search_box.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'organization_logic.dart';

class OrganizationPage extends StatelessWidget {
  final logic = Get.find<OrganizationLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        showShadow: false,
        title: 'xxxx有限公司',
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: PageStyle.c_FFFFFF,
              child: SearchBox(
                enabled: false,
                margin: EdgeInsets.fromLTRB(22.w, 11.h, 22.w, 0),
                padding: EdgeInsets.symmetric(horizontal: 13.w),
              ),
            ),
            _buildLevelTitle(),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView(
                children: [
                  _buildDepartmentView(),
                  _buildDepartmentView(),
                  _buildDepartmentView(),
                  SizedBox(height: 12.h),
                  _buildStaffView(),
                  _buildStaffView(),
                  _buildStaffView(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLevelTitle() {
    var levels = <String>['托云信息技术有限公司', '技术部'];
    var widgets = <Widget>[];
    for (var i = 0; i < levels.length; i++) {
      widgets.add(Container(
        height: 44.h,
        alignment: Alignment.center,
        child: Text(
          levels.elementAt(i),
          style: i == levels.length - 1
              ? PageStyle.ts_1D6BED_14sp
              : PageStyle.ts_000000_14sp,
        ),
      ));
      if (i != levels.length - 1) {
        widgets.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Image.asset(
            ImageRes.ic_subLevel,
            width: 4.w,
            height: 7.h,
          ),
        ));
      }
    }
    return Container(
      height: 44.h,
      color: PageStyle.c_FFFFFF,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        scrollDirection: Axis.horizontal,
        children: widgets,
      ),
    );
  }

  Widget _buildDepartmentView() => Ink(
        color: PageStyle.c_FFFFFF,
        height: 57.h,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '产品部（20）',
                    style: PageStyle.ts_333333_18sp,
                  ),
                ),
                Image.asset(
                  ImageRes.ic_moreArrow,
                  width: 16.w,
                  height: 16.h,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildStaffView() => Ink(
        color: PageStyle.c_FFFFFF,
        // height: 57.h,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                AvatarView(
                  size: 42.h,
                ),
                Expanded(
                  child: Container(
                    height: 57.h,
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        bottom: BorderSide(
                          color: Color(0xFFF0F0F0),
                          width: 1,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 16.w),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '李四',
                              style: PageStyle.ts_333333_16sp,
                            ),
                            Text(
                              '[手机在线]',
                              style: PageStyle.ts_999999_12sp,
                            ),
                          ],
                        ),
                        _buildTagView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildTagView() => Container(
        height: 17.h,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 8.w),
        padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5),
          border: Border.all(
            color: PageStyle.c_A2C9F8,
            width: 1,
          ),
        ),
        child: Text(
          '高级工程师',
          style: PageStyle.ts_2691ED_10sp,
        ),
      );
}
