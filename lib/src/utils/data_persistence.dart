import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sprintf/sprintf.dart';

import '../common/config.dart';
import '../models/login_certificate.dart';

class DataPersistence {
  static const _FREQUENT_CONTACTS = "%s_frequentContacts";
  static const _LOGIN_INFO = 'loginCertificate';
  static const _ACCOUNT = 'account';
  static const _AT_USER_INFO = '%s_atUserInfo';
  static const _SERVER = "server";
  static const _IP = 'ip';
  static const _LANGUAGE = "language";
  static const _IGNORE_UPDATE = 'ignoreUpdate';
  static const _PUSH_LOGIN = '%s_pushLogin';
  static const _CHAT_FONT_SIZE_FACTOR = '%s_chatFontSizeFactor';
  static const _CHAT_BACKGROUND = '%s_chatBackground';
  static const _GROUP_APPLICATION = '%s_groupApplication';
  static const _FRIEND_APPLICATION = '%s_friendApplication';

  DataPersistence._();

  static LoginCertificate? getLoginCertificate() {
    return SpUtil.getObj(_LOGIN_INFO, (v) => LoginCertificate.fromJson(v.cast()));
  }

  static Future<bool>? putLoginCertificate(LoginCertificate info) {
    return SpUtil.putObject(_LOGIN_INFO, info);
  }

  static Future<bool>? removeLoginCertificate() {
    return SpUtil.remove(_LOGIN_INFO);
  }

  static Map? getAccount() {
    return SpUtil.getObject(_ACCOUNT);
  }

  static Future<bool>? putAccount(Map map) {
    return SpUtil.putObject(_ACCOUNT, map);
  }

  static String getKey(String key) {
    return sprintf(key, [OpenIM.iMManager.uid]);
  }

  /// 常用联系人
  static List<String>? getFrequentContacts() {
    return SpUtil.getStringList(getKey(_FREQUENT_CONTACTS));
  }

  /// 常用联系人
  static Future<bool>? putFrequentContacts(List<String> uidList) {
    return SpUtil.putStringList(getKey(_FREQUENT_CONTACTS), uidList);
  }

  static Future<bool>? putAtUserMap(String gid, Map<String, String> atMap) {
    return SpUtil.putObject(sprintf(_AT_USER_INFO, [gid]), atMap);
  }

  static Map? getAtUserMap(String gid) {
    return SpUtil.getObject(sprintf(_AT_USER_INFO, [gid]));
  }

  static void removeAtUserMap(String gid) {
    SpUtil.remove(sprintf(_AT_USER_INFO, [gid]));
  }

  static Future<bool>? putServerConfig(Map<String, String> config) {
    return SpUtil.putObject(_SERVER, config);
  }

  static Map? getServerConfig() {
    return SpUtil.getObject(_SERVER);
  }

  static Future<bool>? putServerIP(String ip) {
    return SpUtil.putString(_IP, ip);
  }

  static String? getServerIP() {
    return SpUtil.getString(_IP);
  }

  static Future<bool>? putLanguage(int index) {
    return SpUtil.putInt(_LANGUAGE, index);
  }

  static int? getLanguage() {
    return SpUtil.getInt(_LANGUAGE);
  }

  static Future<bool>? putIgnoreVersion(String version) {
    return SpUtil.putString(_IGNORE_UPDATE, version);
  }

  static String? getIgnoreVersion() {
    return SpUtil.getString(_IGNORE_UPDATE);
  }

  static Future<bool>? putPushLoginStatus(String alias) {
    return SpUtil.putBool(sprintf(_PUSH_LOGIN, [alias]), true);
  }

  static bool? getPushLoginStatus(String alias) {
    return SpUtil.getBool(sprintf(_PUSH_LOGIN, [alias]), defValue: false);
  }

  static Future<bool>? removePushLoginStatus(String alias) {
    return SpUtil.remove(sprintf(_PUSH_LOGIN, [alias]));
  }

  static Future<bool>? putChatFontSizeFactor(double factor) {
    return SpUtil.putDouble(getKey(_CHAT_FONT_SIZE_FACTOR), factor);
  }

  static double getChatFontSizeFactor() {
    return SpUtil.getDouble(
      getKey(_CHAT_FONT_SIZE_FACTOR),
      defValue: Config.textScaleFactor,
    )!;
  }

  static Future<bool>? putChatBackground(String path) {
    return SpUtil.putString(getKey(_CHAT_BACKGROUND), path);
  }

  static String? getChatBackground() {
    return SpUtil.getString(getKey(_CHAT_BACKGROUND));
  }

  static Future<bool>? clearChatBackground() {
    return SpUtil.remove(getKey(_CHAT_BACKGROUND));
  }

  static Future<bool>? putHaveReadUnHandleGroupApplication(List<String> idList) {
    return SpUtil.putStringList(getKey(_GROUP_APPLICATION), idList);
  }

  static Future<bool>? putHaveReadUnHandleFriendApplication(List<String> idList) {
    return SpUtil.putStringList(getKey(_FRIEND_APPLICATION), idList);
  }

  static List<String>? getHaveReadUnHandleGroupApplication() {
    return SpUtil.getStringList(getKey(_GROUP_APPLICATION), defValue: []);
  }

  static List<String>? getHaveReadUnHandleFriendApplication() {
    return SpUtil.getStringList(getKey(_FRIEND_APPLICATION), defValue: []);
  }
}
