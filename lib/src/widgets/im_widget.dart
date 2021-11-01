import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openim_enterprise_chat/src/core/controller/call_controller.dart';
import 'package:openim_enterprise_chat/src/pages/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/utils/http_util.dart';
import 'package:openim_enterprise_chat/src/utils/im_util.dart';

import 'bottom_sheet_view.dart';
import 'call_view.dart';

class IMWidget {
  static final ImagePicker _picker = ImagePicker();

  static void openPhotoSheet({
    Function(String path, String? url)? onData,
    bool crop = true,
    bool toUrl = true,
  }) {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.album,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            onTap: () async {
              final XFile? image = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (null != image?.path) {
                var map = await _uCropPic(
                  image!.path,
                  crop: crop,
                  toUrl: toUrl,
                );
                onData?.call(map['path'], map['url']);
              }
            },
          ),
          SheetItem(
            label: StrRes.camera,
            onTap: () async {
              final XFile? image = await _picker.pickImage(
                source: ImageSource.camera,
              );
              if (null != image?.path) {
                var map = await _uCropPic(
                  image!.path,
                  crop: crop,
                  toUrl: toUrl,
                );
                onData?.call(map['path'], map['url']);
              }
            },
          ),
        ],
      ),
    );
  }

  static Future<Map<String, dynamic>> _uCropPic(
    String path, {
    bool crop = true,
    bool toUrl = true,
  }) async {
    File? cropFile;
    String? url;
    if (crop) {
      cropFile = await IMUtil.uCrop(path);
    }

    if (toUrl) {
      if (null != cropFile) {
        print('-----------crop path: ${cropFile.path}');
        url = await HttpUtil.uploadImage(path: cropFile.path);
      } else {
        print('-----------source path: $path');
        url = await HttpUtil.uploadImage(path: path);
      }
      print('url:$url');
    }
    return {'path': cropFile?.path ?? path, 'url': url};
  }

  static void showToast(String msg) {
    if (msg.trim().isNotEmpty) EasyLoading.showToast(msg);
  }

  static void openIMCallSheet({
    required String uid,
    required String name,
    String? icon,
  }) {
    Get.bottomSheet(
      BottomSheetView(
        itemBgColor: PageStyle.c_FFFFFF,
        items: [
          SheetItem(
            label: '呼叫$name',
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            textStyle: PageStyle.ts_666666_16sp,
            height: 53.h,
          ),
          SheetItem(
            label: StrRes.callVoice,
            icon: ImageRes.ic_callVoice,
            alignment: MainAxisAlignment.start,
            onTap: () {
              // IMCallView.call(
              //   uid: uid,
              //   name: name,
              //   icon: icon,
              //   state: CallState.CALL,
              //   type: 'voice',
              // );
            },
          ),
          SheetItem(
            label: StrRes.callVideo,
            icon: ImageRes.ic_callVideo,
            alignment: MainAxisAlignment.start,
            onTap: () {
              // IMCallView.call(
              //   uid: uid,
              //   name: name,
              //   icon: icon,
              //   state: CallState.CALL,
              //   type: 'video',
              // );
            },
          ),
        ],
      ),
      // barrierColor: Colors.transparent,
    );
  }

  static void openIMGroupCallSheet({required String gid}) {
    Get.bottomSheet(
      BottomSheetView(
        itemBgColor: PageStyle.c_FFFFFF,
        items: [
          SheetItem(
            label: StrRes.callVoice,
            icon: ImageRes.ic_callVoice,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            alignment: MainAxisAlignment.start,
            onTap: () => _groupCall(gid, 'voice'),
          ),
          SheetItem(
            label: StrRes.callVideo,
            icon: ImageRes.ic_callVideo,
            alignment: MainAxisAlignment.start,
            onTap: () => _groupCall(gid, 'video'),
          ),
        ],
      ),
      // barrierColor: Colors.transparent,
    );
  }

  static _groupCall(String gid, String streamType) async {
    var result = await AppNavigator.startGroupMemberList(
      gid: gid,
      defaultCheckedUidList: [OpenIM.iMManager.uid],
      action: OpAction.GROUP_CALL,
    );
    if (result != null) {
      List<String> uidList = result;
      // AppNavigator.startGroupCall(
      //   gid: gid,
      //   senderUid: OpenIM.iMManager.uid,
      //   receiverIds: uidList,
      //   type: streamType,
      //   state: CallState.CALL,
      // );
    }
  }
}
