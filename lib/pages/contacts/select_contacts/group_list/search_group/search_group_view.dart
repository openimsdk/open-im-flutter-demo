import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:search_keyword_text/search_keyword_text.dart';
import 'package:sprintf/sprintf.dart';

import '../../select_contacts_logic.dart';
import 'search_group_logic.dart';

class SelectContactsFromSearchGroupPage extends StatelessWidget {
  final logic = Get.find<SelectContactsFromSearchGroupLogic>();
  final selectContactsLogic = Get.find<SelectContactsLogic>();

  SelectContactsFromSearchGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.search(
          focusNode: logic.focusNode,
          controller: logic.searchCtrl,
          onSubmitted: (_) => logic.search(),
          onCleared: () => logic.focusNode.requestFocus(),
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: Obx(() => logic.isSearchNotResult
            ? _emptyListView
            : ListView.builder(
                itemCount: logic.resultList.length,
                itemBuilder: (_, index) => _buildItemView(logic.resultList[index]),
              )),
      ),
    );
  }

  Widget _buildItemView(GroupInfo info) {
    Widget buildChild() => Ink(
          height: 64.h,
          color: Styles.c_FFFFFF,
          child: InkWell(
            onTap: () {
              selectContactsLogic.toggleChecked(info);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  if (selectContactsLogic.isMultiModel)
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: ChatRadio(
                        checked: selectContactsLogic.isChecked(info),
                      ),
                    ),
                  AvatarView(
                    url: info.faceURL,
                    text: info.groupName,
                    isGroup: true,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SearchKeywordText(
                          text: info.groupName ?? '',
                          keyText: logic.searchCtrl.text.trim(),
                          style: Styles.ts_0C1C33_17sp,
                          keyStyle: Styles.ts_0089FF_17sp,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        sprintf(StrRes.nPerson, [info.memberCount]).toText..style = Styles.ts_8E9AB0_14sp,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    return selectContactsLogic.isMultiModel ? Obx(buildChild) : buildChild();
  }

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            44.verticalSpace,
            StrRes.searchNotFound.toText..style = Styles.ts_8E9AB0_17sp,
          ],
        ),
      );
}
