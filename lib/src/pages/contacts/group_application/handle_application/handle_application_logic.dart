import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';

class HandleGroupApplicationLogic extends GetxController {
  late GroupInfo gInfo;
  late GroupApplicationInfo aInfo;

  @override
  void onInit() {
    gInfo = Get.arguments['gInfo'];
    aInfo = Get.arguments['aInfo'];
    super.onInit();
  }

  void approve() {
    LoadingView.singleton
        .wrap(
            asyncFunction: () =>
                OpenIM.iMManager.groupManager.acceptGroupApplication(
                  gid: aInfo.groupID!,
                  uid: aInfo.userID!,
                  handleMsg: "reason",
                ))
        .then((value) => Get.back(result: true));
  }

  void reject() {
    LoadingView.singleton
        .wrap(
            asyncFunction: () =>
                OpenIM.iMManager.groupManager.refuseGroupApplication(
                  gid: aInfo.groupID!,
                  uid: aInfo.userID!,
                  handleMsg: "reason",
                ))
        .then((value) => Get.back(result: true));
  }
}
