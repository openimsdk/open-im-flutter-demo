import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/search_box.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:search_keyword_text/search_keyword_text.dart';

import 'search_friend_logic.dart';

class SearchFriendPage extends StatelessWidget {
  final logic = Get.find<SearchFriendLogic>();

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
          hintText: StrRes.searchFriend,
          height: 41.h,
          clearBtn: Container(
            child: Image.asset(
              ImageRes.ic_clearInput,
              color: Color(0xFF999999),
              width: 20.w,
              height: 20.w,
            ),
          ),
          // onSubmitted: (v) => logic.search(),
        ),
      ),
      body: Obx(() => ListView.builder(
            itemCount: logic.resultList.length,
            itemBuilder: (_, index) =>
                _buildItemView(logic.resultList.elementAt(index)),
          )),
    );
  }

  Widget _buildItemView(ContactsInfo info) => Ink(
        height: 64.h,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                AvatarView(
                  url: info.faceURL,
                  size: 44.h,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 14.w),
                    padding: EdgeInsets.only(right: 22.w),
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        bottom: BorderSide(
                          color: Color(0xFFF0F0F0),
                          width: 1,
                        ),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    // child: Text(
                    //   info.getShowName(),
                    //   style: PageStyle.ts_333333_16sp,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    child: SearchKeywordText(
                      text: info.getShowName(),
                      keyText: logic.searchCtrl.text.trim(),
                      style: PageStyle.ts_333333_16sp,
                      keyStyle: PageStyle.ts_1B72EC_16sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
