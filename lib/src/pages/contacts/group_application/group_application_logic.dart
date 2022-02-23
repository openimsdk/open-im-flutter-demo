import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';

class GroupApplicationLogic extends GetxController {
  var list = <GroupApplicationInfo>[].obs;
  var groupList = <String, GroupInfo>{}.obs;
  var imLogic = Get.find<IMController>();

  void getApplicationList() async {
    var l = await OpenIM.iMManager.groupManager.getRecvGroupApplicationList();
    list.assignAll(l);
  }

  void getJoinedGroup() {
    OpenIM.iMManager.groupManager.getJoinedGroupList().then((list) {
      var map = <String, GroupInfo>{};
      list.forEach((e) {
        map[e.groupID] = e;
      });
      groupList.addAll(map);
    });
  }

  String getGroupName(gid) {
    return groupList[gid]?.groupName ?? '';
  }

  void handle(GroupApplicationInfo info) async {
    bool refresh = await AppNavigator.startHandleGroupApplication(
        groupList[info.groupID]!, info);
    if (refresh == true) {
      getApplicationList();
    }
  }

  @override
  void onReady() {
    getApplicationList();
    getJoinedGroup();
    super.onReady();
  }

  @override
  void onInit() {
    // imLogic.onGroupApplicationProcessed = (gid, op, agreeOrReject, opReason) {
    //   getApplicationList();
    // };
    super.onInit();
  }
}
