import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/widgets/qr_view.dart';

class GroupQrcodeLogic extends GetxController {
  late GroupInfo info;

  @override
  void onInit() {
    info = Get.arguments;
    super.onInit();
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

  String buildQRContent() {
    return '${IMQrcodeUrl.joinGroup}${info.groupID}';
  }
}
