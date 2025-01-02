import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'oa_notification_logic.dart';

class OANotificationPage extends StatelessWidget {
  final logic = Get.find<OANotificationLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: logic.info.showName,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SmartRefresher(
            controller: logic.refreshController,
            header: IMViews.buildHeader(),
            footer: IMViews.buildFooter(),
            enablePullDown: false,
            enablePullUp: true,
            onLoading: () => logic.loadNotification(),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              itemCount: logic.messageList.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final message = logic.messageList.reversed.elementAt(index);
                return _buildItemView(index, message, logic.parse(message));
              },
            ),
          )),
    );
  }

  Widget _buildItemView(int index, Message message, OANotification oa) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 15.h,
          ),
          Text(
            IMUtils.getChatTimeline(message.sendTime!),
            style: Styles.ts_8E9AB0_10sp,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarView(
                url: oa.notificationFaceURL,
                builder: oa.notificationFaceURL == null ? () => _buildCustomAvatar() : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(oa.notificationName!, style: Styles.ts_0C1C33_14sp),
                    GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        margin: EdgeInsets.only(top: 8.h),
                        decoration: BoxDecoration(
                          color: Styles.c_FFFFFF,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              oa.notificationName!,
                              style: Styles.ts_8E9AB0_14sp,
                            ),
                            Text(
                              oa.text!,
                              style: Styles.ts_8E9AB0_12sp,
                            ),
                            if (oa.mixType == 1 || oa.mixType == 2 || oa.mixType == 3)
                              Container(
                                margin: EdgeInsets.only(top: 12.h),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (oa.mixType == 1) _buildPictureView(message, oa, index),
                                    if (oa.mixType == 2) _buildVideoView(message, oa, index),
                                    if (oa.mixType == 3) _buildFileView(message, oa, index),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      );

  Widget _buildPictureView(Message message, OANotification oa, int index) => GestureDetector(
        onTap: () async {
          final url = oa.externalUrl;
          final canLunch = await canLaunchUrlString(url!);

          if (url.isNotEmpty == true && canLunch) {
            launchUrlString(url);
          }
        },
        child: ChatPictureView(
          message: message..pictureElem = oa.pictureElem,
          isISend: false,
        ),
      );

  Widget _buildVideoView(Message message, OANotification oa, int index) => GestureDetector(
        onTap: () {
          IMUtils.previewMediaFile(
            context: Get.context!,
            message: message,
            onAutoPlay: (p0) => true,
            onlySave: true,
          );
        },
        child: ChatVideoView(
          message: message..videoElem = oa.videoElem,
          isISend: false,
        ),
      );

  Widget _buildFileView(Message message, OANotification oa, int index) => GestureDetector(
        onTap: () {
          IMUtils.previewFile(message);
        },
        child: ChatFileView(
          message: message..fileElem = oa.fileElem,
          isISend: false,
        ),
      );

  Widget? _buildCustomAvatar() => Container(
        color: Styles.c_0089FF,
        height: 48.h,
        width: 48.h,
        alignment: Alignment.center,
        child: FaIcon(
          FontAwesomeIcons.solidBell,
          color: Styles.c_FFFFFF,
        ),
      );
}
