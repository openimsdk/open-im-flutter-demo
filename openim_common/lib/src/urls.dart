import 'config.dart';

class Urls {
  static final onlineStatus =
      "${Config.imApiUrl}/manager/get_users_online_status";
  static final userOnlineStatus =
      "${Config.imApiUrl}/user/get_users_online_status";
  static final queryAllUsers = "${Config.imApiUrl}/manager/get_all_users_uid";

  static final updateUserInfo = "${Config.appAuthUrl}/user/update";

  static final getUsersFullInfo = "${Config.appAuthUrl}/user/find/full";
  static final searchUserFullInfo = "${Config.appAuthUrl}/user/search/full";

  static final queryUserInfo = "${Config.appAuthUrl}/user/info";

  static final getVerificationCode = "${Config.appAuthUrl}/account/code/send";
  static final checkVerificationCode =
      "${Config.appAuthUrl}/account/code/verify";
  static final register = "${Config.appAuthUrl}/account/register";

  static final resetPwd = "${Config.appAuthUrl}/account/password/reset";

  static final changePwd = "${Config.appAuthUrl}/account/password/change";

  static final login = "${Config.appAuthUrl}/account/login";

  static final upgrade = "${Config.appAuthUrl}/app/check";

  static final getClientConfig =
      '${Config.appAuthUrl}/admin/init/get_client_config';

  static final uniMPUrl = '${Config.appAuthUrl}/applet/list';
}
