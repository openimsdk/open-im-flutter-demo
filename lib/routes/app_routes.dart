part of 'app_pages.dart';

abstract class AppRoutes {
  static const notFound = '/not-found';
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const chat = '/chat';
  static const myQrcode = '/my_qrcode';
  static const chatSetup = '/chat_setup';
  static const favoriteManage = '/favorite_manage';
  static const addContactsMethod = '/add_contacts_method';
  static const addContactsBySearch = '/add_contacts_by_search';
  static const userProfilePanel = '/user_profile_panel';
  static const personalInfo = '/personal_info';
  static const friendSetup = '/friend_setup';
  static const setFriendRemark = '/set_friend_remark';
  static const sendVerificationApplication = '/send_verification_application';
  static const groupProfilePanel = '/group_profile_panel';
  static const myInfo = '/my_info';
  static const editMyInfo = '/edit_my_info';
  static const accountSetup = '/account_setup';
  static const blacklist = '/blacklist';
  static const languageSetup = '/language_setup';
  static const unlockSetup = '/unlock_setup';
  static const changePassword = '/change_password';
  static const aboutUs = '/about_us';
  static const groupChatSetup = '/group_chat_setup';
  static const groupManage = '/group_manage';
  static const editGroupName = '/edit_group_name';
  static const groupMemberList = '/group_member_list';
  static const searchGroupMember = '/search_group_member';
  static const groupQrcode = '/group_qrcode';
  static const friendRequests = '/friend_requests';
  static const processFriendRequests = '/process_friend_requests';
  static const groupRequests = '/group_requests';
  static const processGroupRequests = '/process_group_requests';
  static const friendList = '/friend_list';
  static const groupList = '/group_list';
  static const searchFriend = '/search_friend';
  static const searchGroup = '/search_group';
  static const selectContacts = '/select_contacts';
  static const selectContactsFromFriends = '/select_contacts_from_friends';
  static const selectContactsFromSearchFriends = '/select_contacts_from_search_friends';
  static const selectContactsFromGroup = '/select_contacts_from_group';
  static const selectContactsFromSearchGroup = '/select_contacts_from_search_group';
  static const selectContactsFromSearch = '/select_contacts_from_search';
  static const createGroup = '/create_group';
  static const globalSearch = '/global_search';
  static const expandChatHistory = '/expand_chat_history';
  static const register = '/register';
  static const verifyPhone = '/verify_phone';
  static const setPassword = '/set_password';
  static const setSelfInfo = '/set_self_info';
  static const forgetPassword = '/forget_password';
  static const resetPassword = '/reset_password';
  static const selectContactsFromTag = '/select_contacts_from_tag';
  static const oaNotificationList = "/oa_notification_list";
}

extension RoutesExtension on String {
  String toRoute() => '/${toLowerCase()}';
}
