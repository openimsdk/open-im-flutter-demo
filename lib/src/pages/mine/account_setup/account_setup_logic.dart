import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';

class AccountSetupLogic extends GetxController {
  var notDisturbModel = false.obs;

  void toggleNotDisturbModel() {
    notDisturbModel.value = !notDisturbModel.value;
  }

  void setAddMyMethod() {
    AppNavigator.startAddMyMethod();
    // Get.toNamed(AppRoutes.ADD_MY_METHOD);
  }

  void blacklist() {
    AppNavigator.startBlacklist();
    // Get.toNamed(AppRoutes.BLACKLIST);
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
