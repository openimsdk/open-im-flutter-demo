import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';

class AddContactsLogic extends GetxController {
  void joinGroup() {
    AppNavigator.startJoinGroup();
    // Get.toNamed(AppRoutes.JOIN_GROUP);
  }

  void toSearchPage() {
    AppNavigator.startAddFriendBySearch();
    // Get.toNamed(AppRoutes.ADD_FRIEND_BY_SEARCH);
  }

  void toScanQrcode() {
    AppNavigator.startScanQrcode();
  }

  void crateGroup() {
    AppNavigator.createGroup();
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
