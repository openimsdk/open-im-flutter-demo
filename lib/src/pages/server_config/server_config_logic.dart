import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/config.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/widgets/bottom_sheet_view.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class ServerConfigLogic extends GetxController {
  var checked = true.obs;
  var index = 0.obs;
  var ipCtrl = TextEditingController();
  var authCtrl = TextEditingController();
  var imApiCtrl = TextEditingController();
  var imWsCtrl = TextEditingController();
  var callCtrl = TextEditingController();
  var objectStorageCtrl = TextEditingController();

  @override
  void onInit() {
    ipCtrl.text = Config.serverIp();
    authCtrl.text = Config.appAuthUrl();
    imApiCtrl.text = Config.imApiUrl();
    imWsCtrl.text = Config.imWsUrl();
    objectStorageCtrl.text = Config.objectStorage();

    ipCtrl.addListener(() {
      if (ipCtrl.text.isEmpty) {
        authCtrl.text = 'http://${Config.serverIp()}:10004';
        imApiCtrl.text = 'http://${Config.serverIp()}:10002';
        imWsCtrl.text = 'ws://${Config.serverIp()}:10001';
        callCtrl.text = '';
      } else {
        authCtrl.text = 'http://${ipCtrl.text}:10004';
        imApiCtrl.text = 'http://${ipCtrl.text}:10002';
        imWsCtrl.text = 'ws://${ipCtrl.text}:10001';
        callCtrl.text = '';
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    authCtrl.dispose();
    imApiCtrl.dispose();
    imWsCtrl.dispose();
    callCtrl.dispose();
    ipCtrl.dispose();
    objectStorageCtrl.dispose();
    super.onClose();
  }

  void toggleRadio() {
    checked.value = !checked.value;
  }

  void confirm() async {
    await DataPersistence.putServerConfig({
      'serverIP': ipCtrl.text,
      'authUrl': authCtrl.text,
      'apiUrl': imApiCtrl.text,
      'wsUrl': imWsCtrl.text,
      'callUrl': callCtrl.text,
      'objectStorage': objectStorageCtrl.text,
    });
    IMWidget.showToast('重启app后配置生效');
    // Get.reset();
  }

  void toggleTab(i) {
    index.value = i;
  }

  void selectObjectStorage() {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: '腾讯云',
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            onTap: () => _updateObjectStorage(1),
          ),
          SheetItem(
            label: 'minio',
            onTap: () => _updateObjectStorage(2),
          ),
          SheetItem(
            label: '阿里云',
            onTap: () => _updateObjectStorage(3),
          ),
        ],
      ),
    );
  }

  void _updateObjectStorage(int objectstorage) {
    if (objectstorage == 1) {
      objectStorageCtrl.text = "cos";
    } else if (objectstorage == 2) {
      objectStorageCtrl.text = "minio";
    } else if (objectstorage == 3) {
      objectStorageCtrl.text = "oss";
    }
  }
}
