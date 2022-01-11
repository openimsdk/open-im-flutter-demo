import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class MyInfoLogic extends GetxController {
  // late Rx<UserInfo> userInfo;

  @override
  void onInit() {
    // userInfo = Get.arguments;
    super.onInit();
  }

  void setupUserName() {
    AppNavigator.startSetUserName();
    // Get.toNamed(AppRoutes.SETUP_USER_NAME);
  }

  void myQrcode() {
    AppNavigator.startMyQrcode();
    // Get.toNamed(AppRoutes.MY_QRCODE);
  }

  void myID() {
    AppNavigator.startMyID();
    // Get.toNamed(AppRoutes.MY_ID);
  }

  void openPhotoSheet() {
    IMWidget.openPhotoSheet(onData: (path, url) {
      if (url != null) {
        OpenIM.iMManager.setSelfInfo(icon: url);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
