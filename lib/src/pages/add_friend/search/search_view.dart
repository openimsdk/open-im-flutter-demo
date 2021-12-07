import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/search_box.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'search_logic.dart';

class AddFriendBySearchPage extends StatelessWidget {
  final logic = Get.find<AddFriendBySearchLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.searchTitle(
        searchBox: SearchBox(
          controller: logic.searchCtrl,
          focusNode: logic.focusNode,
          enabled: true,
          autofocus: true,
          // margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 22.w),
          // margin: EdgeInsets.fromLTRB(12.w, 0, 0, 0),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          hintText: logic.isSearchUser
              ? StrRes.searchUserDescribe
              : StrRes.searchGroupDescribe,
          height: 41.h,
          clearBtn: Container(
            child: Image.asset(
              ImageRes.ic_clearInput,
              color: Color(0xFF999999),
              width: 20.w,
              height: 20.w,
            ),
          ),
          onSubmitted: (v) => logic.search(),
        ),
      ),
      body: StreamBuilder(
        stream: logic.resultSub.stream,
        builder: (context, AsyncSnapshot<String> sh) {
          if (logic.searchCtrl.text.isNotEmpty && sh.hasData) {
            if (sh.data!.isNotEmpty) {
              return _buildResultView(sh.data!);
            }
            return _buildNoResultView();
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildResultView(String id) => Ink(
        height: 59.h,
        color: PageStyle.c_FFFFFF,
        child: InkWell(
          onTap: logic.viewInfo,
          child: Container(
            margin: EdgeInsets.only(top: 16.h),
            padding: EdgeInsets.only(left: 22.w),
            child: Row(
              children: [
                Image.asset(
                  ImageRes.ic_searchUResult,
                  width: 22.w,
                  height: 22.h,
                ),
                SizedBox(
                  width: 10.w,
                ),
                RichText(
                  text: TextSpan(
                    text: StrRes.searchPrefix,
                    style: PageStyle.ts_333333_16sp,
                    children: [
                      TextSpan(
                        text: id,
                        style: PageStyle.ts_333333_14sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildNoResultView() => Container(
        height: 75.h,
        color: PageStyle.c_FFFFFF,
        padding: EdgeInsets.only(bottom: 29.h),
        alignment: Alignment.bottomCenter,
        child: Text(
          logic.isSearchUser
              ? StrRes.searchFriendNoResult
              : StrRes.notFindGroup,
          style: PageStyle.ts_666666_16sp,
        ),
      );
}
