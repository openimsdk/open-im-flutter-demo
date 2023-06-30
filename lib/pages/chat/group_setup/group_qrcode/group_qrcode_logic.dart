import 'package:get/get.dart';
import 'package:openim/pages/chat/group_setup/group_setup_logic.dart';
import 'package:openim_common/openim_common.dart';

class GroupQrcodeLogic extends GetxController {
  final groupSetupLogic = Get.find<GroupSetupLogic>();

  String buildQRContent() {
    return '${Config.groupScheme}${groupSetupLogic.groupInfo.value.groupID}';
  }
}
