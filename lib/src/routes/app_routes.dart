part of 'app_pages.dart';

abstract class AppRoutes {
  static const NOT_FOUND = '/not-found';
  static const LOGIN = '/login';
  static const SPLASH = '/splash';
  static const REGISTER = '/register';
  static const REGISTER_VERIFY_PHONE = '/register_verify_phone';
  static const REGISTER_SETUP_PWD = '/register_setup_pwd';
  static const REGISTER_SETUP_SELF_INFO = '/register_setup_selfinfo';
  static const HOME = '/home';
  static const CONVERSATION = "/conversation";
  static const CHAT = "/chat";
  static const CHAT_SETUP = "/chat_setup";

  static const SELECT_CONTACTS = "/select_contacts";
  static const SELECT_CONTACTS_BY_GROUP = "/select_contacts_by_group";
  static const ADD_CONTACTS = "/add_contacts";
  static const NEW_FRIEND_APPLICATION = "/new_friend_application";
  static const FRIEND_LIST = "/friend_list";
  static const GROUP_LIST = "/group_list";
  static const FRIEND_INFO = "/friend_info";
  static const FRIEND_ID_CODE = "/friend_id";
  static const FRIEND_REMARK = "/friend_remark";
  static const ADD_FRIEND = "/add_friend";
  static const ADD_FRIEND_BY_SEARCH = "/add_friend_by_search";
  static const SEND_FRIEND_REQUEST = "/send_friend_request";
  static const ACCEPT_FRIEND_REQUEST = "/accept_friend_request";
  static const MY_QRCODE = "/my_qrcode";
  static const MY_INFO = "/my_info";
  static const MY_ID = "/my_id";
  static const SETUP_USER_NAME = "/set_username";
  static const CALL = "/call";
  static const CREATE_GROUP_IN_CHAT_SETUP = "/create_group_in_chat_setup";
  static const GROUP_SETUP = "/group_setup";
  static const GROUP_NAME_SETUP = "/group_name_setup";
  static const GROUP_ANNOUNCEMENT_SETUP = "/group_announcement_setup";
  static const GROUP_QRCODE = "/group_qrcode";
  static const GROUP_ID = "/group_id";
  static const GROUP_MEMBER_MANAGER = "/group_member_manager";
  static const GROUP_MEMBER_LIST = "/group_member_list";
  static const MY_GROUP_NICKNAME = "/my_group_nickname";
  static const JOIN_GROUP = "/join_group";
  static const ACCOUNT_SETUP = "/account_setup";
  static const ADD_MY_METHOD = "/add_my_method";
  static const BLACKLIST = "/blacklist";
  static const ABOUT_US = "/about_us";
  static const SEARCH_FRIEND = "/search_friend";
  static const SEARCH_GROUP = "/search_group";
  static const SEARCH_MEMBER = "/search_member";
  static const CALL_RECORDS = "/call_records";
  static const GROUP_CALL = "/group_call";
  static const LANGUAGE_SETUP = "/language_setup";
  static const SEARCH_ADD_GROUP = "/search_add_group";
  static const APPLY_ENTER_GROUP = "/apply_enter_group";
  static const GROUP_APPLICATION = "/group_application";
  static const HANDLE_GROUP_APPLICATION = "/handle_group_application";
  static const ORGANIZATION = "/organization";
  static const FORGET_PASSWORD = "/forget_password";
}

extension RoutesExtension on String {
  String toRoute() => '/${toLowerCase()}';
}
