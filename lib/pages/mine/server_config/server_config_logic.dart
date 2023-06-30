import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class ServerConfigLogic extends GetxController {
  var checked = true.obs;
  var index = 0.obs;
  var ipCtrl = TextEditingController();
  var authCtrl = TextEditingController();
  var imApiCtrl = TextEditingController();
  var imWsCtrl = TextEditingController();
  // var chatTokenCtrl = TextEditingController();
  var objectStorageCtrl = TextEditingController();
  var isIP = true.obs;

  void switchServer(bool isIp) {
    isIP.value = isIp;
    ipCtrl.clear();
    // ipCtrl.text = "x.x.x";
    final hintText = isIP.value ? 'ip' : '域名';
    if (isIP.value) {
      // chatTokenCtrl.text = 'http://$hintText:10009';
      authCtrl.text = 'http://$hintText:10008';
      imApiCtrl.text = 'http://$hintText:10002';
      imWsCtrl.text = 'ws://$hintText:10001';
    } else {
      // chatTokenCtrl.text = 'https://$hintText/complete_admin/';
      authCtrl.text = 'https://$hintText/chat/';
      imApiCtrl.text = 'https://$hintText/api/';
      imWsCtrl.text = 'wss://$hintText/msg_gateway';
    }
  }

  @override
  void onInit() {
    ipCtrl.text = Config.serverIp;
    // chatTokenCtrl.text = Config.chatTokenUrl;
    authCtrl.text = Config.appAuthUrl;
    imApiCtrl.text = Config.imApiUrl;
    imWsCtrl.text = Config.imWsUrl;
    objectStorageCtrl.text = Config.objectStorage;

    isIP.value = RegexUtil.isIP(ipCtrl.text);

    ipCtrl.addListener(() {
      if (isIP.value) {
        // chatTokenCtrl.text = 'http://${ipCtrl.text}:10009';
        authCtrl.text = 'http://${ipCtrl.text}:10008';
        imApiCtrl.text = 'http://${ipCtrl.text}:10002';
        imWsCtrl.text = 'ws://${ipCtrl.text}:10001';
      } else {
        // chatTokenCtrl.text = 'https://${ipCtrl.text}/complete_admin/';
        authCtrl.text = 'https://${ipCtrl.text}/chat/';
        imApiCtrl.text = 'https://${ipCtrl.text}/api/';
        imWsCtrl.text = 'wss://${ipCtrl.text}/msg_gateway';
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    // chatTokenCtrl.dispose();
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
      IMViews.showToast('请输入服务器地址!');
      return;
    }
    await DataSp.putServerConfig({
      'serverIP': ipCtrl.text,
      // 'chatTokenUrl': chatTokenCtrl.text,
      'authUrl': authCtrl.text,
      'apiUrl': imApiCtrl.text,
      'wsUrl': imWsCtrl.text,
      'objectStorage': objectStorageCtrl.text,
    });
    IMViews.showToast('重启app后配置生效');
  }

  void toggleTab(i) {
    index.value = i;
  }

  void showObjectStorageSheet() {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: 'minio',
            onTap: () {
              objectStorageCtrl.text = 'minio';
            },
          ),
          SheetItem(
            label: 'cos（腾讯云）',
            onTap: () {
              objectStorageCtrl.text = 'cos';
            },
          ),
          SheetItem(
            label: 'oss（阿里云）',
            onTap: () {
              objectStorageCtrl.text = 'oss';
            },
          ),
        ],
      ),
    );
  }
}
