import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/utils/data_persistence.dart';

class AccountSetupLogic extends GetxController {
  var notDisturbModel = false.obs;
  var curLanguage = "".obs;

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

  void languageSetting() async {
    await AppNavigator.startLanguageSetup();
    updateLanguage();
  }

  void updateLanguage() {
    var index = DataPersistence.getLanguage() ?? 0;
    switch (index) {
      case 1:
        curLanguage.value = StrRes.chinese;
        break;
      case 2:
        curLanguage.value = StrRes.english;
        break;
      default:
        curLanguage.value = StrRes.followSystem;
        break;
    }
  }

  @override
  void onReady() {
    updateLanguage();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
