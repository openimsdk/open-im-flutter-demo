import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/core/controller/jpush_controller.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/utils/data_persistence.dart';

class SplashLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  // final callLogic = Get.find<CallController>();
  final jPushLogic = Get.find<JPushController>();

  var loginCertificate = DataPersistence.getLoginCertificate();

  bool get isExistLoginCertificate => loginCertificate != null;

  String? get uid => loginCertificate?.uid;

  String? get token => loginCertificate?.token;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    imLogic.initializedSubject.listen((value) async {
      print('---------------------initialized---------------------');
      if (isExistLoginCertificate) {
        await _login();
      } else {
        AppNavigator.startLogin();
      }
    });
    super.onReady();
  }

  _login() async {
    try {
      print('---------login---------- uid: $uid, token: $token');
      await imLogic.login(uid!, token!);
      print('---------im login success-------');
      // await callLogic.login(uid!, token!);
      // print('---------ion login success------');
      await jPushLogic.login(uid!);
      print('---------jpush login success----');
      AppNavigator.startMain();
    } catch (e) {
      AppNavigator.startLogin();
    }
  }
}
