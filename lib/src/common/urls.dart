import 'config.dart';

class Urls {
  static var register2 = "${Config.imApiUrl()}/auth/user_register";
  static var login2 = "${Config.imApiUrl()}/auth/user_token";
  static var importFriends = "${Config.imApiUrl()}/friend/import_friend";
  static var inviteToGroup = "${Config.imApiUrl()}/group/invite_user_to_group";
  static var onlineStatus = "${Config.imApiUrl()}/user/get_users_online_status";

  ///
  // static const getVerificationCode = "/cpc/auth/code";
  // static const checkVerificationCode = "/cpc/auth/verify";
  // static const register = "/cpc/auth/password";
  // static const login = "/cpc/auth/login";

  /// 登录注册是独立于im的业务
  static var getVerificationCode = "${Config.appAuthUrl()}/auth/code";
  static var checkVerificationCode = "${Config.appAuthUrl()}/auth/verify";
  static var register = "${Config.appAuthUrl()}/auth/password";
  static var login = "${Config.appAuthUrl()}/auth/login";
  static var upgrade = "${Config.appAuthUrl()}/app/check";
}
