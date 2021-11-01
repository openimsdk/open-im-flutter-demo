import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/call_controller.dart';
import 'package:openim_enterprise_chat/src/widgets/qrcode_view.dart';

import 'app_pages.dart';

class AppNavigator {
  static void startLogin() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  static void startRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  static void startRegisterVerifyPhone({
    required String phoneNumber,
    required String areaCode,
  }) {
    Get.toNamed(AppRoutes.REGISTER_VERIFY_PHONE, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
    });
  }

  static void startRegisterSetupPwd({
    required String phoneNumber,
    required String areaCode,
    required String verifyCode,
  }) {
    Get.toNamed(AppRoutes.REGISTER_SETUP_PWD, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
      'verifyCode': verifyCode,
    });
  }

  static void startRegisterSetupSelfInfo({
    required String phoneNumber,
    required String areaCode,
    required String verifyCode,
    required String password,
  }) {
    Get.toNamed(AppRoutes.REGISTER_SETUP_SELF_INFO, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
      'verifyCode': verifyCode,
      'password': password,
    });
  }

  static void startMain() {
    Get.offAllNamed(AppRoutes.HOME);
  }

  static void startBackMain() {
    Get.until((route) => Get.currentRoute == AppRoutes.HOME);
  }

  static Future<T?>? startChat<T>({
    int type = 0,
    String? uid,
    String? gid,
    String? name,
    String? icon,
    String? draftText,
  }) {
    var arguments = {
      'uid': uid,
      'gid': gid,
      'name': name,
      'icon': icon,
      'draftText': draftText,
    };
    switch (type) {
      case 0:
        return Get.toNamed(AppRoutes.CHAT, arguments: arguments);

      case 1:
        return Get.offNamedUntil(
          AppRoutes.CHAT,
          (route) => route.settings.name == AppRoutes.HOME,
          arguments: arguments,
        );

      default:
        return Get.offNamed(AppRoutes.CHAT, arguments: arguments);
    }
  }

  static void startChatSetup({
    required String uid,
    required String name,
    required String icon,
  }) {
    Get.toNamed(AppRoutes.CHAT_SETUP, arguments: {
      'uid': uid,
      'name': name,
      'icon': icon,
    });
  }

  static void startGroupSetup({
    required String gid,
    required String name,
    required String icon,
  }) {
    Get.toNamed(AppRoutes.GROUP_SETUP, arguments: {
      'gid': gid,
      'name': name,
      'icon': icon,
    });
  }

  static Future<T?>? startSelectContacts<T>({
    required dynamic action,
    dynamic defaultCheckedUidList,
    dynamic excludeUidList,
  }) {
   return Get.toNamed<T>(
      AppRoutes.SELECT_CONTACTS,
      arguments: {
        'action': action,
        'defaultCheckedUidList': defaultCheckedUidList,
        'excludeUidList': excludeUidList,
      },
    );
  }

  static void startAddContacts() {
    Get.toNamed(AppRoutes.ADD_CONTACTS);
  }

  static void startFriendApplicationList() {
    Get.toNamed(AppRoutes.NEW_FRIEND_APPLICATION);
  }

  static void startFriendList() {
    Get.toNamed(AppRoutes.FRIEND_LIST);
  }

  static void startGroupList() {
    Get.toNamed(AppRoutes.GROUP_LIST);
  }

  static Future<T?>? startFriendInfo<T>({required dynamic info}) {
    return Get.toNamed(AppRoutes.FRIEND_INFO, arguments: info);
  }

  static void startFriendIDCode({required dynamic info}) {
    Get.toNamed(AppRoutes.FRIEND_ID_CODE, arguments: info);
  }

  static void startSendFriendRequest({required dynamic info}) {
    Get.toNamed(AppRoutes.SEND_FRIEND_REQUEST, arguments: info);
  }

  static Future<T?>? startSetFriendRemarksName<T>({required dynamic info}) {
    return Get.toNamed(AppRoutes.FRIEND_REMARK, arguments: info);
  }

  static void startAddFriend() {
    Get.toNamed(AppRoutes.ADD_FRIEND);
  }

  static void startAddFriendBySearch() {
    Get.toNamed(AppRoutes.ADD_FRIEND_BY_SEARCH);
  }

  static Future<T?>? startAcceptFriendRequest<T>({dynamic apply}) {
    return Get.toNamed(
      AppRoutes.ACCEPT_FRIEND_REQUEST,
      arguments: apply,
    );
  }

  static void startMyQrcode() {
    Get.toNamed(AppRoutes.MY_QRCODE);
  }

  static void startMyInfo() {
    Get.toNamed(AppRoutes.MY_INFO /*, arguments: userInfo*/);
  }

  static void startMyID() {
    Get.toNamed(AppRoutes.MY_ID);
  }

  static void startSetUserName() {
    Get.toNamed(AppRoutes.SETUP_USER_NAME);
  }

  // static void startCall({dynamic data}) {
  //   Get.toNamed(AppRoutes.CALL, arguments: data);
  // }

  static void startCreateGroupInChatSetup({dynamic members}) {
    Get.offNamed(
      AppRoutes.CREATE_GROUP_IN_CHAT_SETUP,
      arguments: {'members': members},
    );
  }

  static void startGroupNameSet({dynamic info}) {
    Get.toNamed(AppRoutes.GROUP_NAME_SETUP, arguments: info);
  }

  static void startModifyMyNicknameInGroup() {
    Get.toNamed(AppRoutes.MY_GROUP_NICKNAME);
  }

  static void startEditAnnouncement({dynamic info}) {
    Get.toNamed(AppRoutes.GROUP_ANNOUNCEMENT_SETUP, arguments: info);
  }

  static void startViewGroupQrcode({dynamic info}) {
    Get.toNamed(AppRoutes.GROUP_QRCODE, arguments: info);
  }

  static Future<T?>? startGroupMemberManager<T>({dynamic info}) {
    return Get.toNamed(
      AppRoutes.GROUP_MEMBER_MANAGER,
      arguments: info,
    );
  }

  static Future<T?>? startGroupMemberList<T>({
    required String gid,
    dynamic list,
    dynamic action,
    dynamic defaultCheckedUidList,
  }) {
    return Get.toNamed(
      AppRoutes.GROUP_MEMBER_LIST,
      arguments: {
        'gid': gid,
        'list': list,
        'action': action,
        'defaultCheckedUidList': defaultCheckedUidList,
      },
    );
  }

  static void startViewGroupId({dynamic info}) {
    Get.toNamed(AppRoutes.GROUP_ID, arguments: info);
  }

  static void startJoinGroup() {
    Get.toNamed(AppRoutes.JOIN_GROUP);
  }

  static void startAccountSetup() {
    Get.toNamed(AppRoutes.ACCOUNT_SETUP);
  }

  static void startAboutUs() {
    Get.toNamed(AppRoutes.ABOUT_US);
  }

  static void startAddMyMethod() {
    Get.toNamed(AppRoutes.ADD_MY_METHOD);
  }

  static void startBlacklist() {
    Get.toNamed(AppRoutes.BLACKLIST);
  }

  static Future<T?>? startSearchFriend<T>({dynamic list}) {
    return Get.toNamed(AppRoutes.SEARCH_FRIEND, arguments: list);
  }

  static Future<T?>? startSearchGroup<T>({dynamic list}) {
    return Get.toNamed(AppRoutes.SEARCH_GROUP, arguments: list);
  }

  static Future<T?>? startSearchMember<T>({dynamic list}) {
    return Get.toNamed(AppRoutes.SEARCH_MEMBER, arguments: list);
  }

  static void startCallRecords() {
    Get.toNamed(AppRoutes.CALL_RECORDS);
  }

  static void startScanQrcode() {
    Get.to(() => QrcodeView());
  }

  // static void startGroupCall({
  //   required String gid,
  //   required String senderUid,
  //   required List<String> receiverIds,
  //   required String type,
  //   required CallState state,
  // }) {
  //   Get.toNamed(AppRoutes.GROUP_CALL, arguments: {
  //     'gid': gid,
  //     'senderUid': senderUid,
  //     'receiverIds': receiverIds,
  //     'type': type,
  //     'state': state,
  //   });
  // }
}
