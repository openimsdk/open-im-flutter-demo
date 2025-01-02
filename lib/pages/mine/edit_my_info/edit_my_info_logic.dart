import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';

enum EditAttr {
  nickname,
  englishName,
  telephone,
  mobile,
  email,
}

class EditMyInfoLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  late TextEditingController inputCtrl;
  late EditAttr editAttr;
  late int maxLength;
  String? title;
  String? defaultValue;
  TextInputType? keyboardType;

  @override
  void onInit() {
    editAttr = Get.arguments['editAttr'];
    maxLength = Get.arguments['maxLength'] ?? 16;
    _initAttr();
    inputCtrl = TextEditingController(text: defaultValue);
    super.onInit();
  }

  _initAttr() {
    switch (editAttr) {
      case EditAttr.nickname:
        title = StrRes.name;
        defaultValue = imLogic.userInfo.value.nickname;
        keyboardType = TextInputType.text;
        break;
      case EditAttr.englishName:
        break;
      case EditAttr.telephone:
        break;
      case EditAttr.mobile:
        title = StrRes.mobile;
        defaultValue = imLogic.userInfo.value.phoneNumber;
        keyboardType = TextInputType.phone;
        break;
      case EditAttr.email:
        title = StrRes.email;
        defaultValue = imLogic.userInfo.value.email;
        keyboardType = TextInputType.emailAddress;
        break;
    }
  }

  void save() async {
    final value = inputCtrl.text.trim();
    if (editAttr == EditAttr.nickname) {
      await LoadingView.singleton.wrap(
        asyncFunction: () => Apis.updateUserInfo(
          userID: OpenIM.iMManager.userID,
          nickname: value,
        ),
      );
      imLogic.userInfo.update((val) {
        val?.nickname = value;
      });
    } else if (editAttr == EditAttr.mobile) {
      await LoadingView.singleton.wrap(
        asyncFunction: () => Apis.updateUserInfo(
          userID: OpenIM.iMManager.userID,
          phoneNumber: value,
        ),
      );
      imLogic.userInfo.update((val) {
        val?.phoneNumber = value;
      });
    } else if (editAttr == EditAttr.email) {
      if (defaultValue?.isNotEmpty == true && value.isEmpty) {
        IMViews.showToast(StrRes.plsEnterEmail);
        return;
      }
      await LoadingView.singleton.wrap(
        asyncFunction: () => Apis.updateUserInfo(
          userID: OpenIM.iMManager.userID,
          email: value,
        ),
      );
      imLogic.userInfo.update((val) {
        val?.email = value;
      });
    }
    Get.back();
  }
}
