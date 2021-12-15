import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';

class AddFriendLogic extends GetxController {
  void toSearchPage() {
    AppNavigator.startAddFriendBySearch();
    // Get.toNamed(AppRoutes.ADD_FRIEND_BY_SEARCH);
  }

  void toMyQrcode() {
    AppNavigator.startMyQrcode();
    // Get.toNamed(AppRoutes.MY_QRCODE);
  }

  void toScanQrcode() {
    AppNavigator.startScanQrcode();
  }

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
}
