import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/core/controller/jpush_controller.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/custom_dialog.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';

class MineLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final jPushLogic = Get.find<JPushController>();

  // Rx<UserInfo>? userInfo;

  // void getMyInfo() async {
  //   var info = await OpenIM.iMManager.getLoginUserInfo();
  //   userInfo?.value = info;
  // }

  void viewMyQrcode() {
    AppNavigator.startMyQrcode();
    // Get.toNamed(AppRoutes.MY_QRCODE /*, arguments: imLogic.loginUserInfo*/);
  }

  void viewMyInfo() {
    AppNavigator.startMyInfo();
    // Get.toNamed(AppRoutes.MY_INFO /*, arguments: userInfo*/);
  }

  void copyID() {
    IMUtil.copy(text: 'text');
  }

  void accountSetup() {
    AppNavigator.startAccountSetup();
    // Get.toNamed(AppRoutes.ACCOUNT_SETUP);
  }

  void aboutUs() {
    AppNavigator.startAboutUs();
    // Get.toNamed(AppRoutes.ABOUT_US);
  }

  void logout() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.confirmLogout,
    ));
    if (confirm == true) {
      try {
        await LoadingView.singleton.wrap(asyncFunction: () async {
          await imLogic.logout();
          await DataPersistence.removeLoginCertificate();
          await jPushLogic.logout();
        });
        AppNavigator.startLogin();
      } catch (e) {
        // AppNavigator.startLogin();
        IMWidget.showToast('e:$e');
      }
    }
  }

  void kickedOffline() async {
    await DataPersistence.removeLoginCertificate();
    await jPushLogic.logout();
    AppNavigator.startLogin();
  }

  @override
  void onInit() {
    // imLogic.selfInfoUpdatedSubject.listen((value) {
    //   userInfo?.value = value;
    // });
    imLogic.onKickedOfflineSubject.listen((value) {
      // Get.snackbar('提示!', '你的账号已在其他设备登录，请及时修改密码。');
      // kickedOffline();
    });
    super.onInit();
  }

  @override
  void onReady() {
    // getMyInfo();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
