import 'dart:async';

import 'package:get/get.dart';

import '../../core/controller/im_controller.dart';
import '../../core/controller/push_controller.dart';
import '../../routes/app_navigator.dart';
import '../../utils/data_persistence.dart';
import '../../widgets/im_widget.dart';

class SplashLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();

  var loginCertificate = DataPersistence.getLoginCertificate();

  bool get isExistLoginCertificate => loginCertificate != null;

  String? get uid => loginCertificate?.userID;

  String? get token => loginCertificate?.imToken;

  late StreamSubscription initializedSub;

  @override
  void onInit() {
    initializedSub = imLogic.initializedSubject.listen((value) async {
      print('---------------------initialized---------------------');
      if (isExistLoginCertificate) {
        await _login();
      } else {
        AppNavigator.startLogin();
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  _login() async {
    try {
      print('---------login---------- uid: $uid, token: $token');
      await imLogic.login(uid!, token!);
      print('---------im login success-------');
      pushLogic.login(uid!);
      print('---------jpush login success----');
      AppNavigator.startMain();
    } catch (e) {
      IMWidget.showToast('$e');
      AppNavigator.startLogin();
    }
  }

  @override
  void onClose() {
    initializedSub.cancel();
    super.onClose();
  }
}
