import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class BlacklistLogic extends GetxController {
  final blacklist = <BlacklistInfo>[].obs;

  void _getBlacklist() async {
    var list = await OpenIM.iMManager.friendshipManager.getBlacklist();
    blacklist.addAll(list);
  }

  remove(BlacklistInfo info) async {
    await OpenIM.iMManager.friendshipManager.removeBlacklist(
      userID: info.userID!,
    );
    blacklist.remove(info);
  }

  @override
  void onReady() {
    _getBlacklist();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
