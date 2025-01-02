import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/controller/app_controller.dart';
import '../../../core/controller/im_controller.dart';

class AboutUsLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final imLogic = Get.find<IMController>();
  final lineTextController = TextEditingController(text: '1000');
  final displayVersion = ''.obs;

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final appName = packageInfo.appName;
    final buildNumber = packageInfo.buildNumber;

    displayVersion.value = '$appName $version+$buildNumber SDK: ${OpenIM.version}';
  }

  void checkUpdate() {
    appLogic.checkUpdate();
  }

  void copyVersion() {
    IMViews.showToast(StrRes.copySuccessfully);
    Clipboard.setData(ClipboardData(text: displayVersion.value));
  }

  void uploadLogs([int line = 0]) async {
    EasyLoading.showProgress(0);
    await OpenIM.iMManager.uploadLogs(line: line);
    EasyLoading.dismiss();
  }

  @override
  void onReady() {
    getPackageInfo();

    imLogic.onUploadProgress = (current, size) {
      final p = current / size;
      final pStr = '${(p * 100.0).truncate()}%';
      EasyLoading.showProgress(p, status: pStr);
    };
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
