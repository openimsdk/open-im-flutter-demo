import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';

class JoinGroupLogic extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void scanner() {
    AppNavigator.startScanQrcode();
  }

  void search() {
    AppNavigator.startAddGroupBySearch();
  }
}
