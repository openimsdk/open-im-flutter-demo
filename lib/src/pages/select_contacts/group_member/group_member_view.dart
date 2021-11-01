import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/search_box.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'group_member_logic.dart';

class SelectByGroupMemberPage extends StatelessWidget {
  final logic = Get.find<SelectByGroupMemberLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBox(
            margin: EdgeInsets.fromLTRB(22.w, 21.h, 22.w, 10.h),
            padding: EdgeInsets.symmetric(horizontal: 13.w),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 22.w),
            child: RichText(
              text: TextSpan(
                text: '托云信息技术（成都）有限公司',
                style: PageStyle.ts_333333_16sp,
                children: [
                  WidgetSpan(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        bottom: 2.h,
                      ),
                      child: Image.asset(
                        ImageRes.ic_next,
                        width: 8.w,
                        height: 13.h,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: '群成员',
                    style: PageStyle.ts_999999_16sp,
                  ),
                ],
              ),
            ),
          ),
          /*Expanded(
            child: AzListView(
              data: dataList,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                Languages model = dataList[index];
                return getListItem(context, model);
              },
              itemScrollController: itemScrollController,
              susItemBuilder: (BuildContext context, int index) {
                Languages model = dataList[index];
                return getSusItem(context, model.getSuspensionTag());
              },
              indexBarData: SuspensionUtil.getTagIndexList(_contacts),
              indexBarOptions: IndexBarOptions(
                needRebuild: true,
                selectTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                selectItemDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF333333),
                ),
                indexHintWidth: 96,
                indexHintHeight: 97,
                indexHintDecoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageRes.ic_indexBarBg),
                    fit: BoxFit.contain,
                  ),
                ),
                indexHintAlignment: Alignment.centerRight,
                indexHintTextStyle: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black87,
                ),
                indexHintOffset: Offset(-30, 0),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

// Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
//   return Container(
//     height: susHeight,
//     width: MediaQuery.of(context).size.width,
//     padding: EdgeInsets.only(left: 16.0),
//     color: Color(0xFFF3F4F5),
//     alignment: Alignment.centerLeft,
//     child: Text(
//       '$tag',
//       softWrap: false,
//       style: TextStyle(
//         fontSize: 14.0,
//         color: Color(0xFF666666),
//       ),
//     ),
//   );
// }
//
// Widget getListItem(BuildContext context, Languages model,
//     {double susHeight = 40}) {
//   return ListTile(
//     title: Text(model.name),
//     onTap: () {
//
//     },
//   );
// }
}
