import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/app_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsLogic extends GetxController {
  var version = "".obs;
  var appLogic = Get.find<AppController>();

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String buildNumber = packageInfo.buildNumber;
    version.value = packageInfo.version;
  }

  void checkUpdate() {
    appLogic.checkUpdate();
  }

  @override
  void onReady() {
    getPackageInfo();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
