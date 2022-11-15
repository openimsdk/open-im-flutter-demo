import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/pages/add_friend/search/search_logic.dart';
import 'package:openim_demo/src/pages/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import 'package:openim_demo/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_demo/src/widgets/qr_view.dart';

import 'app_pages.dart';

class AppNavigator {
  static void backLogin() {
    Get.until((route) => Get.currentRoute == AppRoutes.LOGIN);
  }

  static void startLogin() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  static void startRegister(String way) {
    Get.toNamed(AppRoutes.REGISTER, arguments: {'registerWay': way});
  }

  static void startRegisterVerifyPhoneOrEmail({
    String? email,
    String? phoneNumber,
    String? areaCode,
    required int usedFor,
    String? invitationCode,
  }) {
    Get.toNamed(AppRoutes.REGISTER_VERIFY_PHONE, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
      'email': email,
      'usedFor': usedFor,
      'invitationCode': invitationCode
    });
  }

  /// [usedFor] 1：注册，2：重置密码
  static void startSetupPwd(
      {String? phoneNumber,
      String? areaCode,
      String? email,
      required String verifyCode,
      required int usedFor,
      String? invitationCode}) {
    Get.toNamed(AppRoutes.REGISTER_SETUP_PWD, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
      'email': email,
      'verifyCode': verifyCode,
      'usedFor': usedFor,
      'invitationCode': invitationCode
    });
  }

  static void startRegisterSetupPwd({
    String? phoneNumber,
    String? areaCode,
    String? email,
    required String verifyCode,
  }) {
    Get.toNamed(AppRoutes.REGISTER_SETUP_PWD, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
      'email': email,
      'verifyCode': verifyCode,
    });
  }

  static void startRegisterSetupSelfInfo(
      {String? phoneNumber,
      String? areaCode,
      String? email,
      required String verifyCode,
      required String password,
      String? invitationCode}) {
    Get.toNamed(AppRoutes.REGISTER_SETUP_SELF_INFO, arguments: {
      'phoneNumber': phoneNumber,
      'areaCode': areaCode,
      'email': email,
      'verifyCode': verifyCode,
      'password': password,
      'invitationCode': invitationCode
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
  }) async {
    var arguments = {
      'uid': uid,
      'gid': gid,
      'name': name,
      'icon': icon,
      'draftText': draftText,
    };
    // var result = await navigator?.push(
    //   CustomMaterialPageRoute(
    //     settings: RouteSettings(name: AppRoutes.CHAT, arguments: arguments),
    //     builder: (_) {
    //       return GetBuilder(
    //         init: ChatLogic(),
    //         builder: (controller) => ChatPage(),
    //       );
    //     },
    //   ),
    // );
    // return result;
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
    required SelAction action,
    List<String>? defaultCheckedUidList,
    List<String>? excludeUidList,
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

  static Future<T?>? startFriendInfo<T>({required UserInfo info}) {
    return Get.toNamed(AppRoutes.FRIEND_INFO, arguments: info);
  }

  /// 扫一扫进去
  static Future<T?>? startFriendInfo2<T>({required UserInfo info}) {
    return Get.offAndToNamed(AppRoutes.FRIEND_INFO, arguments: info);
    // return Get.toNamed(AppRoutes.FRIEND_INFO, arguments: info);
  }

  static Future<T?>? startSearchAddGroup<T>({required GroupInfo info}) {
    return Get.toNamed(AppRoutes.SEARCH_ADD_GROUP, arguments: info);
  }

  static Future<T?>? startSearchAddGroup2<T>({required GroupInfo info}) {
    return Get.offAndToNamed(AppRoutes.SEARCH_ADD_GROUP, arguments: info);
    // return Get.toNamed(AppRoutes.FRIEND_INFO, arguments: info);
  }

  static void startFriendIDCode({required UserInfo info}) {
    Get.toNamed(AppRoutes.FRIEND_ID_CODE, arguments: info);
  }

  static void startSendFriendRequest({required UserInfo info}) {
    Get.toNamed(AppRoutes.SEND_FRIEND_REQUEST, arguments: info);
  }

  static Future<T?>? startSetFriendRemarksName<T>({required UserInfo info}) {
    return Get.toNamed(AppRoutes.FRIEND_REMARK, arguments: info);
  }

  static void startAddFriend() {
    Get.toNamed(AppRoutes.ADD_FRIEND);
  }

  static void startAddFriendBySearch() {
    Get.toNamed(
      AppRoutes.ADD_FRIEND_BY_SEARCH,
      arguments: {'searchType': SearchType.user},
    );
  }

  static void startAddGroupBySearch() {
    Get.toNamed(
      AppRoutes.ADD_FRIEND_BY_SEARCH,
      arguments: {'searchType': SearchType.group},
    );
  }

  static Future<T?>? startAcceptFriendRequest<T>(
      {required FriendApplicationInfo apply}) {
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

  static void startCreateGroupInChatSetup(
      {required List<ContactsInfo> members}) {
    Get.offNamed(
      AppRoutes.CREATE_GROUP_IN_CHAT_SETUP,
      arguments: {'members': members},
    );
  }

  static void startGroupNameSet({required GroupInfo info}) {
    Get.toNamed(AppRoutes.GROUP_NAME_SETUP, arguments: info);
  }

  static void startModifyMyNicknameInGroup() {
    Get.toNamed(AppRoutes.MY_GROUP_NICKNAME);
  }

  static void startEditAnnouncement({required GroupInfo info}) {
    Get.toNamed(AppRoutes.GROUP_ANNOUNCEMENT_SETUP, arguments: info);
  }

  static void startViewGroupQrcode({required GroupInfo info}) {
    Get.toNamed(AppRoutes.GROUP_QRCODE, arguments: info);
  }

  static Future<T?>? startGroupMemberManager<T>({required GroupInfo info}) {
    return Get.toNamed(
      AppRoutes.GROUP_MEMBER_MANAGER,
      arguments: info,
    );
  }

  static Future<T?>? startGroupMemberList<T>({
    required String gid,
    required OpAction action,
    List<GroupMembersInfo>? list,
    List<String>? defaultCheckedUidList,
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

  static void startViewGroupId({required GroupInfo info}) {
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

  static Future<T?>? startSearchFriend<T>({required List<ContactsInfo> list}) {
    return Get.toNamed(AppRoutes.SEARCH_FRIEND, arguments: list);
  }

  static Future<T?>? startSearchGroup<T>({required List<GroupInfo> list}) {
    return Get.toNamed(AppRoutes.SEARCH_GROUP, arguments: list);
  }

  static Future<T?>? startSearchMember<T>(
      {required List<GroupMembersInfo> list}) {
    return Get.toNamed(AppRoutes.SEARCH_MEMBER, arguments: list);
  }

  static void startCallRecords() {
    Get.toNamed(AppRoutes.CALL_RECORDS);
  }

  static void startScanQrcode() {
    Get.to(() => QrcodeView());
  }

  static Future<T?>? startLanguageSetup<T>() {
    return Get.toNamed(AppRoutes.LANGUAGE_SETUP);
  }

  static void createGroup() => startSelectContacts(
        action: SelAction.CRATE_GROUP,
        defaultCheckedUidList: [OpenIM.iMManager.uid],
      );

  static void applyEnterGroup(GroupInfo info) {
    Get.toNamed(AppRoutes.APPLY_ENTER_GROUP, arguments: info);
  }

  static void startGroupApplication() {
    Get.toNamed(AppRoutes.GROUP_APPLICATION);
  }

  static Future<T?>? startHandleGroupApplication<T>(
    GroupInfo gInfo,
    GroupApplicationInfo aInfo,
  ) {
    return Get.toNamed(AppRoutes.HANDLE_GROUP_APPLICATION, arguments: {
      'aInfo': aInfo,
      'gInfo': gInfo,
    });
  }

  static void startOrganization() {
    Get.toNamed(AppRoutes.ORGANIZATION);
  }

  static void startForgetPassword({String accountType = "phone"}) {
    Get.toNamed(AppRoutes.FORGET_PASSWORD,
        arguments: {"accountType": accountType});
  }
}
