import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/widgets/qr_view.dart';
import 'package:sprintf/sprintf.dart';

class MyQrcodeLogic extends GetxController {
  // late Rx<UserInfo> userInfo;
  final imLogic = Get.find<IMController>();

  @override
  void onInit() async {
    // userInfo = Get.arguments;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  String buildQRContent() {
    return '${IMQrcodeUrl.addFriend}${imLogic.userInfo.value.userID}';
  }
}
