import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class AcceptFriendRequestLogic extends GetxController {
  late FriendApplicationInfo userInfo;

  @override
  void onInit() {
    userInfo = Get.arguments;
    super.onInit();
  }

  /// 接受好友申请
  void acceptFriendApplication() async {
    OpenIM.iMManager.friendshipManager
        .acceptFriendApplication(uid: userInfo.fromUserID!)
        .then(
      (value) {
        IMWidget.showToast(StrRes.addSuccessfully);
        Get.back(result: true);
        return value;
      },
    ).catchError((_) => IMWidget.showToast(StrRes.addFailed));
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
}
