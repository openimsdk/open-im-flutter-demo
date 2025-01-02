import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

class DataSp {
  static const _loginCertificate = 'loginCertificate';
  static const _loginAccount = 'loginAccount';
  static const _server = "server";
  static const _ip = 'ip';
  static const _deviceID = 'deviceID';
  static const _ignoreUpdate = 'ignoreUpdate';
  static const _language = "language";
  static const _groupApplication = "%s_groupApplication";
  static const _friendApplication = "%s_friendApplication";

  static const _screenPassword = '%s_screenPassword';
  static const _enabledBiometric = '%s_enabledBiometric';
  static const _chatFontSizeFactor = '%s_chatFontSizeFactor';
  static const _chatBackground = '%s_chatBackground_%s';
  static const _loginType = 'loginType';
  static const _meetingInProgress = '%_meetingInProgress';

  DataSp._();

  static init() async {
    await SpUtil().init();
  }

  static String getKey(String key, {String key2 = ""}) {
    return sprintf(key, [OpenIM.iMManager.userID, key2]);
  }

  static String? get imToken => getLoginCertificate()?.imToken;

  static String? get chatToken => getLoginCertificate()?.chatToken;

  static String? get userID => getLoginCertificate()?.userID;

  static Future<bool>? putLoginCertificate(LoginCertificate lc) {
    return SpUtil().putObject(_loginCertificate, lc);
  }

  static Future<bool>? putLoginAccount(Map map) {
    return SpUtil().putObject(_loginAccount, map);
  }

  static LoginCertificate? getLoginCertificate() {
    return SpUtil().getObj(_loginCertificate, (v) => LoginCertificate.fromJson(v.cast()));
  }

  static Future<bool>? removeLoginCertificate() {
    return SpUtil().remove(_loginCertificate);
  }

  static Map? getLoginAccount() {
    return SpUtil().getObject(_loginAccount);
  }

  static Future<bool>? putServerConfig(Map<String, String> config) {
    return SpUtil().putObject(_server, config);
  }

  static Map? getServerConfig() {
    return SpUtil().getObject(_server);
  }

  static Future<bool>? putServerIP(String ip) {
    return SpUtil().putString(ip, ip);
  }

  static String? getServerIP() {
    return SpUtil().getString(_ip);
  }

  static String getDeviceID() {
    String id = SpUtil().getString(_deviceID) ?? '';
    if (id.isEmpty) {
      id = const Uuid().v4();
      SpUtil().putString(_deviceID, id);
    }
    return id;
  }

  static Future<bool>? putIgnoreVersion(String version) {
    return SpUtil().putString(_ignoreUpdate, version);
  }

  static String? getIgnoreVersion() {
    return SpUtil().getString(_ignoreUpdate);
  }

  static Future<bool>? putLanguage(int index) {
    return SpUtil().putInt(_language, index);
  }

  static int? getLanguage() {
    return SpUtil().getInt(_language);
  }

  static Future<bool>? putHaveReadUnHandleGroupApplication(List<String> idList) {
    return SpUtil().putStringList(getKey(_groupApplication), idList);
  }

  static Future<bool>? putHaveReadUnHandleFriendApplication(List<String> idList) {
    return SpUtil().putStringList(getKey(_friendApplication), idList);
  }

  static List<String>? getHaveReadUnHandleGroupApplication() {
    return SpUtil().getStringList(getKey(_groupApplication), defValue: []);
  }

  static List<String>? getHaveReadUnHandleFriendApplication() {
    return SpUtil().getStringList(getKey(_friendApplication), defValue: []);
  }

  static Future<bool>? putLockScreenPassword(String password) {
    return SpUtil().putString(getKey(_screenPassword), password);
  }

  static Future<bool>? clearLockScreenPassword() {
    return SpUtil().remove(getKey(_screenPassword));
  }

  static String? getLockScreenPassword() {
    return SpUtil().getString(getKey(_screenPassword), defValue: null);
  }

  static Future<bool>? openBiometric() {
    return SpUtil().putBool(getKey(_enabledBiometric), true);
  }

  static bool? isEnabledBiometric() {
    return SpUtil().getBool(getKey(_enabledBiometric), defValue: null);
  }

  static Future<bool>? closeBiometric() {
    return SpUtil().remove(getKey(_enabledBiometric));
  }

  static Future<bool>? putChatFontSizeFactor(double factor) {
    return SpUtil().putDouble(getKey(_chatFontSizeFactor), factor);
  }

  static double getChatFontSizeFactor() {
    return SpUtil().getDouble(
      getKey(_chatFontSizeFactor),
      defValue: Config.textScaleFactor,
    )!;
  }

  static Future<bool>? putChatBackground(String toUid, String path) {
    return SpUtil().putString(getKey(_chatBackground, key2: toUid), path);
  }

  static String? getChatBackground(String toUid) {
    return SpUtil().getString(getKey(_chatBackground, key2: toUid));
  }

  static Future<bool>? clearChatBackground(String toUid) {
    return SpUtil().remove(getKey(_chatBackground, key2: toUid));
  }

  static Future<bool>? putLoginType(int type) {
    return SpUtil().putInt(_loginType, type);
  }

  static int getLoginType() {
    return SpUtil().getInt(_loginType) ?? 0;
  }

  static Future<bool>? putMeetingInProgress(String meetingID) {
    return SpUtil().putString(getKey(_meetingInProgress), meetingID);
  }

  static String? getMeetingInProgress() {
    return SpUtil().getString(
      getKey(_meetingInProgress),
    );
  }

  static Future<bool>? removeMeetingInProgress() {
    return SpUtil().remove(getKey(_meetingInProgress));
  }
}
