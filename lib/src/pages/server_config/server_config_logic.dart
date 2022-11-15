import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/config.dart';
import '../../res/styles.dart';
import '../../utils/data_persistence.dart';
import '../../widgets/bottom_sheet_view.dart';
import '../../widgets/im_widget.dart';

class ServerConfigLogic extends GetxController {
  var checked = true.obs;
  var index = 0.obs;
  var ipCtrl = TextEditingController();
  var authCtrl = TextEditingController();
  var imApiCtrl = TextEditingController();
  var imWsCtrl = TextEditingController();
  var objectStorageCtrl = TextEditingController();
  var isIP = true.obs;

  void switchServer() {
    isIP.value = !isIP.value;
    ipCtrl.clear();
    // ipCtrl.text = "x.x.x";
    final hintText = isIP.value ? 'ip' : '域名';
    if (isIP.value) {
      authCtrl.text = 'http://$hintText:10008';
      imApiCtrl.text = 'http://$hintText:10002';
      imWsCtrl.text = 'ws://$hintText:10001';
    } else {
      authCtrl.text = 'https://$hintText/chat/';
      imApiCtrl.text = 'https://$hintText/api/';
      imWsCtrl.text = 'wss://$hintText/msg_gateway';
    }
  }

  @override
  void onInit() {
    ipCtrl.text = Config.serverIp();
    authCtrl.text = Config.appAuthUrl();
    imApiCtrl.text = Config.imApiUrl();
    imWsCtrl.text = Config.imWsUrl();
    objectStorageCtrl.text = Config.objectStorage();
    isIP.value = RegexUtil.isIP(ipCtrl.text);

    ipCtrl.addListener(() {
      if (isIP.value) {
        authCtrl.text = 'http://${ipCtrl.text}:10008';
        imApiCtrl.text = 'http://${ipCtrl.text}:10002';
        imWsCtrl.text = 'ws://${ipCtrl.text}:10001';
      } else {
        authCtrl.text = 'https://${ipCtrl.text}/chat/';
        imApiCtrl.text = 'https://${ipCtrl.text}/api/';
        imWsCtrl.text = 'wss://${ipCtrl.text}/msg_gateway';
      }
      // if (ipCtrl.text.isEmpty) {
      //   if (isIP.value) {
      //     authCtrl.text = 'http://${Config.serverIp()}:10008';
      //     imApiCtrl.text = 'http://${Config.serverIp()}:10002';
      //     imWsCtrl.text = 'ws://${Config.serverIp()}:10001';
      //   } else {
      //     authCtrl.text = 'https://${Config.serverIp()}/chat/';
      //     imApiCtrl.text = 'https://${Config.serverIp()}/api/';
      //     imWsCtrl.text = 'wss://${Config.serverIp()}/msg_gateway';
      //   }
      // } else {
      //   if (isIP.value) {
      //     authCtrl.text = 'http://${ipCtrl.text}:10008';
      //     imApiCtrl.text = 'http://${ipCtrl.text}:10002';
      //     imWsCtrl.text = 'ws://${ipCtrl.text}:10001';
      //   } else {
      //     authCtrl.text = 'https://${ipCtrl.text}/chat/';
      //     imApiCtrl.text = 'https://${ipCtrl.text}/api/';
      //     imWsCtrl.text = 'wss://${ipCtrl.text}/msg_gateway';
      //   }
      // }
    });
    super.onInit();
  }

  @override
  void onClose() {
    authCtrl.dispose();
    imApiCtrl.dispose();
    imWsCtrl.dispose();
    objectStorageCtrl.dispose();
    ipCtrl.dispose();
    super.onClose();
  }

  void toggleRadio() {
    checked.value = !checked.value;
  }

  void confirm() async {
    if (ipCtrl.text.isEmpty) {
      IMWidget.showToast('请输入服务器地址!');
      return;
    }
    await DataPersistence.putServerConfig({
      'serverIP': ipCtrl.text,
      'authUrl': authCtrl.text,
      'apiUrl': imApiCtrl.text,
      'wsUrl': imWsCtrl.text,
      'objectStorage': objectStorageCtrl.text,
    });
    IMWidget.showToast('重启app后配置生效');
    // Get.reset();
  }

  void toggleTab(i) {
    index.value = i;
  }

  void showObjectStorageSheet() {
    Get.bottomSheet(
      BottomSheetView(
        itemBgColor: PageStyle.c_FFFFFF,
        items: [
          SheetItem(
            label: '图片存储方式选择',
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            textStyle: PageStyle.ts_666666_16sp,
          ),
          SheetItem(
              label: 'minio',
              alignment: MainAxisAlignment.center,
              onTap: () {
                objectStorageCtrl.text = 'minio';
              }),
          SheetItem(
              label: 'cos（腾讯云）',
              alignment: MainAxisAlignment.center,
              onTap: () {
                objectStorageCtrl.text = 'cos';
              }),
          SheetItem(
              label: 'oss（阿里云）',
              alignment: MainAxisAlignment.center,
              onTap: () {
                objectStorageCtrl.text = 'oss';
              }),
        ],
      ),
    );
  }
}
