import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/models/call_records.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/utils/im_util.dart';
import 'package:openim_enterprise_chat/src/widgets/avatar_view.dart';
import 'package:openim_enterprise_chat/src/widgets/search_box.dart';
import 'package:openim_enterprise_chat/src/widgets/tabbar.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'call_records_logic.dart';

class CallRecordsPage extends StatelessWidget {
  final logic = Get.find<CallRecordsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.call,
      ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: Obx(
        () => Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                // color: PageStyle.listViewItemBgColor,
                child: SearchBox(
                  hintText: StrRes.search,
                  margin:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  enabled: false,
                ),
              ),
            ),
            CustomTabBar(
              index: logic.index.value,
              labels: [StrRes.allCall, StrRes.missedCall],
              onTabChanged: (index) => logic.switchTab(index),
              selectedStyle: PageStyle.ts_333333_16sp,
              unselectedStyle: PageStyle.ts_333333_16sp,
              indicatorColor: PageStyle.c_1D6BED,
              indicatorHeight: 3.h,
              indicatorWidth: 34.w,
              showUnderline: true,
            ),
            Expanded(
              child: IndexedStack(
                index: logic.index.value,
                children: [
                  ListView.builder(
                    itemCount: logic.list.length,
                    cacheExtent: 70.h,
                    itemBuilder: (_, index) =>
                        _buildItemView(logic.list.elementAt(index)),
                  ),
                  ListView.builder(
                    itemCount: logic.missedList.length,
                    cacheExtent: 70.h,
                    itemBuilder: (_, index) =>
                        _buildItemView(logic.missedList.elementAt(index)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView(CallRecords records) => Dismissible(
        key: Key('${records.uid}_${records.date}'),
        confirmDismiss: (direction) async {
          return logic.remove(records);
        },
        child: GestureDetector(
          onTap: () => logic.call(records),
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: 70.h,
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              children: [
                AvatarView(
                  size: 48.h,
                  url: records.icon,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        records.name,
                        style: records.success
                            ? PageStyle.ts_333333_15sp
                            : PageStyle.ts_F33E37_15sp,
                      ),
                      Text(
                        '[${records.type == 'video' ? StrRes.video : StrRes.voice}]${IMUtil.getCallTimeline(records.date)}',
                        style: records.success
                            ? PageStyle.ts_666666_13sp
                            : PageStyle.ts_F33E37_13sp,
                      ),
                    ],
                  ),
                ),
                Text(
                  records.success
                      ? IMUtil.seconds2HMS(records.duration)
                      : (records.incomingCall
                          ? StrRes.incomingCall
                          : StrRes.outgoingCall),
                  style: records.success
                      ? PageStyle.ts_666666_13sp
                      : PageStyle.ts_F33E37_13sp,
                ),
              ],
            ),
          ),
        ),
      );
}
