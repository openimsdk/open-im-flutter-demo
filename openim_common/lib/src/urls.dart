import 'config.dart';

class Urls {
  static final onlineStatus =
      "${Config.imApiUrl}/manager/get_users_online_status";
  static final userOnlineStatus =
      "${Config.imApiUrl}/user/get_users_online_status";
  static final queryAllUsers = "${Config.imApiUrl}/manager/get_all_users_uid";

  /// toc
  static final updateUserInfo = "${Config.appAuthUrl}/user/update";

  /// to B
  // static final updateUserInfo = "${Config.appAuthUrl}/user/update";

  static final getUsersFullInfo = "${Config.appAuthUrl}/user/find/full";
  static final searchUserFullInfo = "${Config.appAuthUrl}/user/search/full";

  /// to B
  static final queryUserInfo = "${Config.appAuthUrl}/user/info";

  /// 登录注册 独立于im的业务
  static final getVerificationCode = "${Config.appAuthUrl}/account/code/send";
  static final checkVerificationCode =
      "${Config.appAuthUrl}/account/code/verify";
  static final register = "${Config.appAuthUrl}/account/register";

  /// to B
  // static final resetPwd = "${Config.appAuthUrl}/user/reset_password";

  /// toc
  static final resetPwd = "${Config.appAuthUrl}/account/password/reset";

  static final changePwd = "${Config.appAuthUrl}/account/password/change";

  /// toc
  static final login = "${Config.appAuthUrl}/account/login";

  /// to B
  // static final login = "${Config.appAuthUrl}/user/login";

  static final upgrade = "${Config.appAuthUrl}/app/check";

  /// 全局配置
  static final getClientConfig =
      '${Config.appAuthUrl}/admin/init/get_client_config';

  /// 小程序
  static final uniMPUrl = '${Config.appAuthUrl}/applet/list';
}
