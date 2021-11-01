import 'package:openim_enterprise_chat/src/common/config.dart';

class Urls {
  static const register2 = "/auth/user_register";
  static const login2 = "/auth/user_token";
  static const importFriends = "/friend/import_friend";
  static const inviteToGroup = "/group/invite_user_to_group";
  static const getVerificationCode = "http:${Config.HOST}:42233/auth/code";
  static const checkVerificationCode = "http:${Config.HOST}:42233/auth/verify";
  static const register = "http:${Config.HOST}:42233/auth/password";
  static const login = "http:${Config.HOST}:42233/auth/login";
}
