import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';

class AddContactsLogic extends GetxController {
  void joinGroup() {
    AppNavigator.startJoinGroup();
    // Get.toNamed(AppRoutes.JOIN_GROUP);
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
