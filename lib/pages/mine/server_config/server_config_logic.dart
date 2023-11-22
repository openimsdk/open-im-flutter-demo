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

  var isIP = true.obs;

  void switchServer(bool isIp) {
    isIP.value = isIp;
    ipCtrl.clear();

    final hintText = isIP.value ? 'ip' : 'host';
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
    ipCtrl.text = Config.serverIp;

    authCtrl.text = Config.appAuthUrl;
    imApiCtrl.text = Config.imApiUrl;
    imWsCtrl.text = Config.imWsUrl;

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
    });
    super.onInit();
  }

  @override
  void onClose() {
    authCtrl.dispose();
    imApiCtrl.dispose();
    imWsCtrl.dispose();
    ipCtrl.dispose();
    super.onClose();
  }

  void toggleRadio() {
    checked.value = !checked.value;
  }

  void confirm() async {
    if (ipCtrl.text.isEmpty) {
      IMViews.showToast('Please enter the server address!');
      return;
    }
    await DataSp.putServerConfig({
      'serverIP': ipCtrl.text,
      'authUrl': authCtrl.text,
      'apiUrl': imApiCtrl.text,
      'wsUrl': imWsCtrl.text,
    });
    IMViews.showToast('The configuration will take effect after restarting the app');
  }

  void toggleTab(i) {
    index.value = i;
  }
}
