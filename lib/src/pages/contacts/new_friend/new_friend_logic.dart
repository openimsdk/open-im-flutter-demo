import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';

class NewFriendLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  var applicationList = <FriendApplicationInfo>[].obs;
  var canSeeMore = false.obs;
  var isExpanded = false.obs;

  /// 获取好友申请列表
  void getFriendApplicationList() async {
    var list =
        await OpenIM.iMManager.friendshipManager.getRecvFriendApplicationList();
    applicationList
      ..clear()
      ..addAll(list /*.map((e) => e)*/);
    canSeeMore.value = list.length > 4;
  }

  /// 接受好友申请
  void acceptFriendApplication(int index) async {
    var apply = applicationList.elementAt(index);
    var result = await AppNavigator.startAcceptFriendRequest(apply: apply);
    // var result = await Get.toNamed(
    //   AppRoutes.ACCEPT_FRIEND_REQUEST,
    //   arguments: apply,
    // );
    if (result == true) {
      apply.handleResult = 1;
      applicationList.refresh();
    }

    /* var apply = applicationList.elementAt(index);
    OpenIM.iMManager.friendshipManager
        .acceptFriendApplication(uid: apply.uid)
        .then((_) => Fluttertoast.showToast(msg: StrRes.addSuccessfully))
        .catchError((_) => Fluttertoast.showToast(msg: StrRes.addFailed));

    await OpenIM.iMManager.friendshipManager.acceptFriendApplication(
      uid: apply.uid,
    );
    apply.flag = 1;
    applicationList.refresh();*/
  }

  /// 拒绝好友申请
  void refuseFriendApplication(int index) async {
    var apply = applicationList.elementAt(index);
    await OpenIM.iMManager.friendshipManager.refuseFriendApplication(
      uid: apply.fromUserID!,
    );
    apply.handleResult = -1;
    applicationList.refresh();
  }

  void onClickItem(int index) {
    var info = applicationList.elementAt(index);
    if (info.isWaitingHandle) {
      acceptFriendApplication(index);
    } else if (info.isAgreed) {
      //
      AppNavigator.startFriendInfo(
          info: UserInfo.fromJson({
        "userID": info.fromUserID,
        "nickname": info.fromNickname,
        "faceURL": info.fromFaceURL,
      }));
    }
  }

  void expandedAll() {
    isExpanded.value = true;
  }

  void toSearchPage() {
    AppNavigator.startAddFriendBySearch();
    // Get.toNamed(AppRoutes.ADD_FRIEND_BY_SEARCH);
  }

  @override
  void onInit() {
    imLogic.friendApplicationChangedSubject.listen((value) {
      getFriendApplicationList();
    });
    super.onInit();
  }

  @override
  void onReady() {
    getFriendApplicationList();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
