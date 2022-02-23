import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/core/controller/jpush_controller.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class SplashLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final jPushLogic = Get.find<JPushController>();

  var loginCertificate = DataPersistence.getLoginCertificate();

  bool get isExistLoginCertificate => loginCertificate != null;

  String? get uid => loginCertificate?.userID;

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
      jPushLogic.login(uid!);
      print('---------jpush login success----');
      AppNavigator.startMain();
    } catch (e) {
      IMWidget.showToast('$e');
      AppNavigator.startLogin();
    }
  }
}
