import 'dart:convert';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:azlistview/azlistview.dart';
import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:mime/mime.dart';
import 'package:openim_common/openim_common.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:video_compress/video_compress.dart';


/// 间隔时间完成某事
class IntervalDo {
  DateTime? last;

  void run({required Function() fuc, int milliseconds = 0}) {
    DateTime now = DateTime.now();
    if (null == last ||
        now.difference(last ?? now).inMilliseconds > milliseconds) {
      last = now;
      fuc();
    }
  }
}

class IMUtils {
  IMUtils._();

  /// 密码正则表达式：6～20位数字+大小写字母
  static final passwordRegExp = RegExp(
    // r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!.])(?=.{6,20}$)',
    // r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{6,20}$',
    r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,20}$',
  );

  static Future<CroppedFile?> uCrop(String path) {
    return ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Styles.c_0089FF,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: '',
        ),
      ],
    );
  }

  static void copy({required String text}) {
    Clipboard.setData(ClipboardData(text: text));
    IMViews.showToast(StrRes.copySuccessfully);
  }

  static List<ISuspensionBean> convertToAZList(List<ISuspensionBean> list) {
    for (int i = 0, length = list.length; i < length; i++) {
      setAzPinyinAndTag(list[i]);
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(list);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(list);

    // add topList.
    // contactsList.insertAll(0, topList);
    return list;
  }

  static ISuspensionBean setAzPinyinAndTag(ISuspensionBean info) {
    if (info is ISUserInfo) {
      String pinyin = PinyinHelper.getPinyinE(info.getShowName());
      if (pinyin.trim().isEmpty) {
        info.tagIndex = "#";
      } else {
        String tag = pinyin.substring(0, 1).toUpperCase();
        info.namePinyin = pinyin.toUpperCase();
        if (RegExp("[A-Z]").hasMatch(tag)) {
          info.tagIndex = tag;
        } else {
          info.tagIndex = "#";
        }
      }
    } else if (info is ISGroupMembersInfo) {
      String pinyin = PinyinHelper.getPinyinE(info.nickname!);
      if (pinyin.trim().isEmpty) {
        info.tagIndex = "#";
      } else {
        String tag = pinyin.substring(0, 1).toUpperCase();
        info.namePinyin = pinyin.toUpperCase();
        if (RegExp("[A-Z]").hasMatch(tag)) {
          info.tagIndex = tag;
        } else {
          info.tagIndex = "#";
        }
      }
    }
    return info;
  }

  static saveMediaToGallery(String mimeType, String cachePath) async {
    if (mimeType.contains('video') || mimeType.contains('image')) {
      await ImageGallerySaver.saveFile(cachePath);
    }
  }

  static String? emptyStrToNull(String? str) =>
      (null != str && str.trim().isEmpty) ? null : str;

  static bool isNotNullEmptyStr(String? str) => null != str && "" != str.trim();

  static bool isChinaMobile(String mobile) {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(mobile);
  }

  static bool isMobile(String areaCode, String mobile) =>
      (areaCode == '+86' || areaCode == '86') ? isChinaMobile(mobile) : true;

  /// 获取视频缩略图
  static Future<File> getVideoThumbnail(File file) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(
      file.path,
      quality: 20,
      position: 1,
    );
    return thumbnailFile;
  }

  ///  compress video
  static Future<File?> compressVideoAndGetFile(File file) async {
    var mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false,
    );
    return mediaInfo?.file;
  }

  ///  compress file and get file.
  static Future<File?> compressImageAndGetFile(File file) async {
    var path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1);
    var targetPath = await createTempFile(name: name, dir: 'pic');
    CompressFormat format = CompressFormat.jpeg;
    if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
      format = CompressFormat.jpeg;
    } else if (name.endsWith(".png")) {
      format = CompressFormat.png;
    } else if (name.endsWith(".heic")) {
      format = CompressFormat.heic;
    } else if (name.endsWith(".webp")) {
      format = CompressFormat.webp;
    }

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 480,
      minHeight: 800,
      // minHeight: 1920,
      // minWidth: 1080,
      format: format,
    );
    return result;
  }

  static Future<String> createTempFile({
    required String dir,
    required String name,
  }) async {
    final storage = (Platform.isIOS
        ? await getTemporaryDirectory()
        : await getExternalStorageDirectory());
    Directory directory = Directory('${storage!.path}/$dir');
    if (!(await directory.exists())) {
      directory.create(recursive: true);
    }
    File file = File('${directory.path}/$name');
    if (!(await file.exists())) {
      file.create();
    }
    return file.path;
  }

  static int compareVersion(String val1, String val2) {
    var arr1 = val1.split(".");
    var arr2 = val2.split(".");
    int length = arr1.length >= arr2.length ? arr1.length : arr2.length;
    int diff = 0;
    int v1;
    int v2;
    for (int i = 0; i < length; i++) {
      v1 = i < arr1.length ? int.parse(arr1[i]) : 0;
      v2 = i < arr2.length ? int.parse(arr2[i]) : 0;
      diff = v1 - v2;
      if (diff == 0) {
        continue;
      } else {
        return diff > 0 ? 1 : -1;
      }
    }
    return diff;
  }

  static int getPlatform() {
    final context = Get.context!;
    if (Platform.isAndroid) {
      return context.isTablet ? 8 : 2;
    } else {
      return context.isTablet ? 9 : 1;
    }
  }

  // md5 加密
  static String? generateMD5(String? data) {
    if (null == data) return null;
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  static String buildGroupApplicationID(GroupApplicationInfo info) {
    return '${info.groupID}-${info.creatorUserID}-${info.reqTime}-${info.userID}--${info.inviterUserID}';
  }

  static String buildFriendApplicationID(FriendApplicationInfo info) {
    /// 1686566803245 1686727472913
    return '${info.fromUserID}-${info.toUserID}-${info.createTime}';
  }

  static Future<String> getCacheFileDir() async {
    return (await getTemporaryDirectory()).absolute.path;
  }

  static Future<String> getDownloadFileDir() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (err, st) {
        Logger.print('failed to get downloads path: $err, $st');
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath!;
  }

  static Future<String> toFilePath(String path) async {
    var filePrefix = 'file://';
    var uriPrefix = 'content://';
    if (path.contains(filePrefix)) {
      path = path.substring(filePrefix.length);
    } else if (path.contains(uriPrefix)) {
      // Uri uri = Uri.parse(thumbnailPath); // Parsing uri string to uri
      File file = await toFile(path);
      path = file.path;
    }
    return path;
  }

  /// 消息列表超过5分钟则显示时间
  static List<Message> calChatTimeInterval(List<Message> list,
      {bool calculate = true}) {
    if (!calculate) return list;
    var milliseconds = list.firstOrNull?.sendTime;
    if (null == milliseconds) return list;
    list.first.exMap['showTime'] = true;
    var lastShowTimeStamp = milliseconds;
    for (var i = 0; i < list.length; i++) {
      var index = i + 1;
      if (index <= list.length - 1) {
        var cur = getDateTimeByMs(lastShowTimeStamp);
        var milliseconds = list.elementAt(index).sendTime!;
        var next = getDateTimeByMs(milliseconds);
        if (next.difference(cur).inMinutes > 5) {
          lastShowTimeStamp = milliseconds;
          list.elementAt(index).exMap['showTime'] = true;
        }
      }
    }
    return list;
  }

  static String getChatTimeline(int ms, [String formatToday = 'HH:mm']) {
    final locTimeMs = DateTime.now().millisecondsSinceEpoch;
    final languageCode = Get.locale?.languageCode ?? 'zh';
    final isZH = languageCode == 'zh';

    if (DateUtil.isToday(ms, locMs: locTimeMs)) {
      return formatDateMs(ms, format: formatToday);
    }

    if (DateUtil.isYesterdayByMs(ms, locTimeMs)) {
      return '${isZH ? '昨天' : 'Yesterday'} ${formatDateMs(ms, format: 'HH:mm')}';
    }

    if (DateUtil.isWeek(ms, locMs: locTimeMs)) {
      return '${DateUtil.getWeekdayByMs(ms, languageCode: languageCode)} ${formatDateMs(ms, format: 'HH:mm')}';
    }

    if (DateUtil.yearIsEqualByMs(ms, locTimeMs)) {
      return formatDateMs(ms, format: isZH ? 'MM月dd HH:mm' : 'MM/dd HH:mm');
    }

    return formatDateMs(ms, format: isZH ? 'yyyy年MM月dd' : 'yyyy/MM/dd');
  }

  static String getCallTimeline(int milliseconds) {
    if (DateUtil.yearIsEqualByMs(milliseconds, DateUtil.getNowDateMs())) {
      return formatDateMs(milliseconds, format: 'MM/dd');
    } else {
      return formatDateMs(milliseconds, format: 'yyyy/MM/dd');
    }
  }

  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }

  static String formatDateMs(int ms, {bool isUtc = false, String? format}) {
    return DateUtil.formatDateMs(ms, format: format, isUtc: isUtc);
  }

  static String seconds2HMS(int seconds) {
    int h = 0;
    int m = 0;
    int s = 0;
    int temp = seconds % 3600;
    if (seconds > 3600) {
      h = seconds ~/ 3600;
      if (temp != 0) {
        if (temp > 60) {
          m = temp ~/ 60;
          if (temp % 60 != 0) {
            s = temp % 60;
          }
        } else {
          s = temp;
        }
      }
    } else {
      m = seconds ~/ 60;
      if (seconds % 60 != 0) {
        s = seconds % 60;
      }
    }
    if (h == 0) {
      return '${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}';
    }
    return "${h < 10 ? '0$h' : h}:${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";
  }

  /// 消息按时间线分组
  static Map<String, List<Message>> groupingMessage(List<Message> list) {
    var languageCode = Get.locale?.languageCode ?? 'zh';
    var group = <String, List<Message>>{};
    for (var message in list) {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(message.sendTime!);
      String dateStr;
      if (DateUtil.isToday(message.sendTime!)) {
        // 今天
        dateStr = languageCode == 'zh' ? '今天' : 'Today';
      } else if (DateUtil.isWeek(message.sendTime!)) {
        // 本周
        dateStr = languageCode == 'zh' ? '本周' : 'This Week';
      } else if (dateTime.isThisMonth) {
        //当月
        dateStr = languageCode == 'zh' ? '这个月' : 'This Month';
      } else {
        // 按年月
        dateStr = DateUtil.formatDate(dateTime, format: 'yyyy/MM');
      }
      group[dateStr] = (group[dateStr] ?? <Message>[])..add(message);
    }
    return group;
  }

  static String mutedTime(int mss) {
    int days = mss ~/ (60 * 60 * 24);
    int hours = (mss % (60 * 60 * 24)) ~/ (60 * 60);
    int minutes = (mss % (60 * 60)) ~/ 60;
    int seconds = mss % 60;
    return "${_combTime(days, StrRes.day)}${_combTime(hours, StrRes.hours)}${_combTime(minutes, StrRes.minute)}${_combTime(seconds, StrRes.seconds)}";
  }

  static String _combTime(int value, String unit) =>
      value > 0 ? '$value$unit' : '';

  /// 搜索聊天内容显示规则
  static String calContent({
    required String content,
    required String key,
    required TextStyle style,
    required double usedWidth,
  }) {
    var size = calculateTextSize(content, style);
    var lave = 1.sw - usedWidth;
    if (size.width < lave) {
      return content;
    }
    var index = content.indexOf(key);
    if (index == -1 || index > content.length - 1) return content;
    var start = content.substring(0, index);
    var end = content.substring(index);
    var startSize = calculateTextSize(start, style);
    var keySize = calculateTextSize(key, style);
    if (startSize.width + keySize.width > lave) {
      if (index - 4 > 0) {
        return "...${content.substring(index - 4)}";
      } else {
        return "...$end";
      }
    } else {
      return content;
    }
  }

  // Here it is!
  static Size calculateTextSize(
    String text,
    TextStyle style, {
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size;
  }

  static TextPainter getTextPainter(
    String text,
    TextStyle style, {
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) =>
      TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: maxWidth);

  static bool isUrlValid(String? url) {
    if (null == url || url.isEmpty) {
      return false;
    }
    return url.startsWith("http://") || url.startsWith("https://");
  }

  static bool isValidUrl(String? urlString) {
    if (null == urlString || urlString.isEmpty) {
      return false;
    }
    Uri? uri = Uri.tryParse(urlString);
    if (uri != null && uri.hasScheme && uri.hasAuthority) {
      return true;
    }
    return false;
  }

  static String getGroupMemberShowName(GroupMembersInfo membersInfo) {
    return membersInfo.userID == OpenIM.iMManager.userID
        ? StrRes.you
        : membersInfo.nickname!;
  }

  static String getShowName(String? userID, String? nickname) {
    return userID == OpenIM.iMManager.userID ? StrRes.you : nickname ?? '';
  }

  /// 通知解析
  static String? parseNtf(
    Message message, {
    bool isConversation = false,
  }) {
    String? text;
    try {
      if (message.contentType! >= 1000) {
        final elem = message.notificationElem!;
        final map = json.decode(elem.detail!);
        switch (message.contentType) {
          case MessageType.groupCreatedNotification:
            {
              final ntf = GroupNotification.fromJson(map);
              // a 创建了群聊
              final label = StrRes.createGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupInfoSetNotification:
            {
              final ntf = GroupNotification.fromJson(map);
              if (ntf.group?.notification != null &&
                  ntf.group!.notification!.isNotEmpty) {
                return isConversation ? ntf.group!.notification! : null;
              }
              // a 修改了群资料
              final label = StrRes.editGroupInfoNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.memberQuitNotification:
            {
              final ntf = QuitGroupNotification.fromJson(map);
              // a 退出了群聊
              final label = StrRes.quitGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.quitUser!)]);
            }
            break;
          case MessageType.memberInvitedNotification:
            {
              final ntf = InvitedJoinGroupNotification.fromJson(map);
              // a 邀请 b 加入群聊
              final label = StrRes.invitedJoinGroupNtf;
              final b = ntf.invitedUserList
                  ?.map((e) => getGroupMemberShowName(e))
                  .toList()
                  .join('、');
              text = sprintf(
                  label, [getGroupMemberShowName(ntf.opUser!), b ?? '']);
            }
            break;
          case MessageType.memberKickedNotification:
            {
              final ntf = KickedGroupMemeberNotification.fromJson(map);
              // b 被 a 踢出群聊
              final label = StrRes.kickedGroupNtf;
              final b = ntf.kickedUserList!
                  .map((e) => getGroupMemberShowName(e))
                  .toList()
                  .join('、');
              text = sprintf(label, [b, getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.memberEnterNotification:
            {
              final ntf = EnterGroupNotification.fromJson(map);
              // a 加入了群聊
              final label = StrRes.joinGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.entrantUser!)]);
            }
            break;
          case MessageType.dismissGroupNotification:
            {
              final ntf = GroupNotification.fromJson(map);
              // a 解散了群聊
              final label = StrRes.dismissGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupOwnerTransferredNotification:
            {
              final ntf = GroupRightsTransferNoticication.fromJson(map);
              // a 将群转让给了 b
              final label = StrRes.transferredGroupNtf;
              text = sprintf(label, [
                getGroupMemberShowName(ntf.opUser!),
                getGroupMemberShowName(ntf.newGroupOwner!)
              ]);
            }
            break;
          case MessageType.groupMemberMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);
              // b 被 a 禁言
              final label = StrRes.muteMemberNtf;
              final c = ntf.mutedSeconds;
              text = sprintf(label, [
                getGroupMemberShowName(ntf.mutedUser!),
                getGroupMemberShowName(ntf.opUser!),
                mutedTime(c!)
              ]);
            }
            break;
          case MessageType.groupMemberCancelMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);
              // b 被 a 取消了禁言
              final label = StrRes.muteCancelMemberNtf;
              text = sprintf(label, [
                getGroupMemberShowName(ntf.mutedUser!),
                getGroupMemberShowName(ntf.opUser!)
              ]);
            }
            break;
          case MessageType.groupMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);
              // a 开起了群禁言
              final label = StrRes.muteGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupCancelMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);
              // a 关闭了群禁言
              final label = StrRes.muteCancelGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.friendApplicationApprovedNotification:
            {
              // 你们已成为好友
              text = StrRes.friendAddedNtf;
            }
            break;
          case MessageType.burnAfterReadingNotification:
            {
              final ntf = BurnAfterReadingNotification.fromJson(map);
              if (ntf.isPrivate == true) {
                text = StrRes.openPrivateChatNtf;
              } else {
                text = StrRes.closePrivateChatNtf;
              }
            }
            break;
          case MessageType.groupMemberInfoChangedNotification:
            final ntf = GroupMemberInfoChangedNotification.fromJson(map);
            text = sprintf(StrRes.memberInfoChangedNtf,
                [getGroupMemberShowName(ntf.opUser!)]);
            break;
          case MessageType.groupNoticeChangedNotification:
            if (isConversation) {
              final ntf = GroupNotification.fromJson(map);
              text = ntf.group?.notification ?? '';
            }
            break;
          case MessageType.groupNameChangedNotification:
            final ntf = GroupNotification.fromJson(map);
            text = sprintf(StrRes.whoModifyGroupName,
                [getGroupMemberShowName(ntf.opUser!)]);
            break;
        }
      }
    } catch (e, s) {
      Logger.print('Exception details:\n $e');
      Logger.print('Stack trace:\n $s');
    }
    return text;
  }

  static String parseMsg(
    Message message, {
    bool isConversation = false,
    bool replaceIdToNickname = false,
  }) {
    String? content;
    try {
      switch (message.contentType) {
        case MessageType.text:
          content = message.textElem!.content!.trim();
          break;
        case MessageType.at_text:
          content = message.atTextElem!.text!.trim();
          if (replaceIdToNickname) {
            var list = message.atTextElem?.atUsersInfo;
            list?.forEach((e) {
              content = content?.replaceAll(
                '@${e.atUserID}',
                '@${getAtNickname(e.atUserID!, e.groupNickname!)}',
              );
            });
          }
          break;
        case MessageType.picture:
          content = '[${StrRes.picture}]';
          break;
        case MessageType.voice:
          content = '[${StrRes.voice}]';
          break;
        case MessageType.video:
          content = '[${StrRes.video}]';
          break;
        case MessageType.file:
          content = '[${StrRes.file}]';
          break;
        case MessageType.location:
          content = '[${StrRes.location}]';
          break;
        case MessageType.merger:
          content = '[${StrRes.chatRecord}]';
          break;
        case MessageType.card:
          content = '[${StrRes.carte}]';
          break;
        case MessageType.quote:
          content = message.quoteElem?.text ?? '';
          break;
        case MessageType.revokeMessageNotification:
          var isSelf = message.sendID == OpenIM.iMManager.userID;
          var map = json.decode(message.notificationElem!.detail!);
          var info = RevokedInfo.fromJson(map);
          if (message.isSingleChat) {
            // 单聊
            if (isSelf) {
              content = '${StrRes.you} ${StrRes.revokeMsg}';
            } else {
              content = '${message.senderNickname} ${StrRes.revokeMsg}';
            }
          } else {
            // 群聊撤回包含：撤回自己消息，群组或管理员撤回其他人消息
            if (info.revokerID == info.sourceMessageSendID) {
              if (isSelf) {
                content = '${StrRes.you} ${StrRes.revokeMsg}';
              } else {
                content = '${message.senderNickname} ${StrRes.revokeMsg}';
              }
            } else {
              late String revoker;
              late String sender;
              if (info.revokerID == OpenIM.iMManager.userID) {
                revoker = StrRes.you;
              } else {
                revoker = info.revokerNickname!;
              }
              if (info.sourceMessageSendID == OpenIM.iMManager.userID) {
                sender = StrRes.you;
              } else {
                sender = info.sourceMessageSenderNickname!;
              }

              content = sprintf(StrRes.aRevokeBMsg, [revoker, sender]);
            }
          }
          break;
        case MessageType.custom_face:
          content = '[${StrRes.emoji}]';
          break;
        case MessageType.custom:
          var data = message.customElem!.data;
          var map = json.decode(data!);
          var customType = map['customType'];
          var customData = map['data'];
          switch (customType) {
            case CustomMessageType.call:
              var type = map['data']['type'];
              content =
                  '[${type == 'video' ? StrRes.callVideo : StrRes.callVoice}]';
              break;
            case CustomMessageType.emoji:
              content = '[${StrRes.emoji}]';
              break;
            case CustomMessageType.tag:
              if (null != customData['textElem']) {
                final textElem = TextElem.fromJson(customData['textElem']);
                content = textElem.content;
              } else if (null != customData['soundElem']) {
                // final soundElem = SoundElem.fromJson(customData['soundElem']);
                content = '[${StrRes.voice}]';
              } else {
                content = '[${StrRes.unsupportedMessage}]';
              }
              break;
            case CustomMessageType.meeting:
              content = '[${StrRes.meetingMessage}]';
              break;
            case CustomMessageType.blockedByFriend:
              content = StrRes.blockedByFriendHint;
              break;
            case CustomMessageType.deletedByFriend:
              content = sprintf(
                StrRes.deletedByFriendHint,
                [''],
              );
              break;
            case CustomMessageType.removedFromGroup:
              content = StrRes.removedFromGroupHint;
              break;
            case CustomMessageType.groupDisbanded:
              content = StrRes.groupDisbanded;
              break;
            default:
              content = '[${StrRes.unsupportedMessage}]';
              break;
          }
          break;
        case MessageType.oaNotification:
          // OA通知
          String detail = message.notificationElem!.detail!;
          var oa = OANotification.fromJson(json.decode(detail));
          content = oa.text!;
          break;
        default:
          content = '[${StrRes.unsupportedMessage}]';
          break;
      }
    } catch (e, s) {
      Logger.print('Exception details:\n $e');
      Logger.print('Stack trace:\n $s');
    }
    return content ?? '[${StrRes.unsupportedMessage}]';
  }

  static dynamic parseCustomMessage(Message message) {
    try {
      switch (message.contentType) {
        case MessageType.custom:
          {
            var data = message.customElem!.data;
            var map = json.decode(data!);
            var customType = map['customType'];
            switch (customType) {
              case CustomMessageType.call:
                {
                  final duration = map['data']['duration'];
                  final state = map['data']['state'];
                  final type = map['data']['type'];
                  String? content;
                  switch (state) {
                    case 'beHangup':
                    case 'hangup':
                      content =
                          sprintf(StrRes.callDuration, [seconds2HMS(duration)]);
                      break;
                    case 'cancel':
                      content = StrRes.cancelled;
                      break;
                    case 'beCanceled':
                      content = StrRes.cancelledByCaller;
                      break;
                    case 'reject':
                      content = StrRes.rejected;
                      break;
                    case 'beRejected':
                      content = StrRes.rejectedByCaller;
                      break;
                    case 'timeout':
                      content = StrRes.callTimeout;
                      break;
                    default:
                      break;
                  }
                  if (content != null) {
                    return {
                      'viewType': CustomMessageType.call,
                      'type': type,
                      'content': content,
                    };
                  }
                }
                break;
              case CustomMessageType.emoji:
                map['data']['viewType'] = CustomMessageType.emoji;
                return map['data'];
              case CustomMessageType.tag:
                map['data']['viewType'] = CustomMessageType.tag;
                return map['data'];
              case CustomMessageType.meeting:
                map['data']['viewType'] = CustomMessageType.meeting;
                return map['data'];
              case CustomMessageType.deletedByFriend:
              case CustomMessageType.blockedByFriend:
              case CustomMessageType.removedFromGroup:
              case CustomMessageType.groupDisbanded:
                return {'viewType': customType};
            }
          }
      }
    } catch (e, s) {
      Logger.print('Exception details:\n $e');
      Logger.print('Stack trace:\n $s');
    }
    return null;
  }

  static Map<String, String> getAtMapping(
    Message message,
    Map<String, String> newMapping,
  ) {
    final mapping = <String, String>{};
    try {
      if (message.contentType == MessageType.at_text) {
        var list = message.atTextElem!.atUsersInfo;
        list?.forEach((e) {
          final userID = e.atUserID!;
          final groupNickname =
              newMapping[userID] ?? e.groupNickname ?? e.atUserID!;
          mapping[userID] = getAtNickname(userID, groupNickname);
        });
      }
    } catch (_) {}
    return mapping;
  }

  static String getAtNickname(String atUserID, String atNickname) {
    // String nickname = atNickname;
    // if (atUserID == OpenIM.iMManager.uid) {
    //   nickname = StrRes.you;
    // } else if (atUserID == 'atAllTag') {
    //   nickname = StrRes.everyone;
    // }
    return atUserID == 'atAllTag' ? StrRes.everyone : atNickname;
  }

  static void previewUrlPicture(
    List<String> urls, {
    int currentIndex = 0,
    String? heroTag,
  }) =>
      navigator?.push(TransparentRoute(
        builder: (BuildContext context) => GestureDetector(
          onTap: () => Get.back(),
          child: ChatPicturePreview(
            currentIndex: currentIndex,
            images: urls,
            heroTag: heroTag,
            onLongPress: (url) {
              IMViews.openDownloadSheet(
                url,
                onDownload: () => HttpUtil.saveUrlPicture(url),
              );
            },
          ),
        ),
      ));

  /*Get.to(
        () => ChatPicturePreview(
          currentIndex: currentIndex,
          images: urls,
          // heroTag: message.clientMsgID,
          heroTag: urls.elementAt(currentIndex),
          onLongPress: (url) {
            IMViews.openDownloadSheet(
              url,
              onDownload: () => HttpUtil.saveUrlPicture(url),
            );
          },
        ),
        // opaque: false,
        transition: Transition.cupertino,
        // popGesture: true,
        // fullscreenDialog: true,
      );*/



  /// 处理消息点击事件
  /// [messageList] 预览图片消息的时候，可用左右滑动
  static void parseClickEvent(
    Message message, {
    List<Message> messageList = const [],
    Function(UserInfo userInfo)? onViewUserInfo,
  }) async {
    if (message.contentType == MessageType.picture) {
    } else if (message.contentType == MessageType.video) {
    } else if (message.contentType == MessageType.file) {
    } else if (message.contentType == MessageType.card) {
    } else if (message.contentType == MessageType.merger) {
    } else if (message.contentType == MessageType.location) {
    } else if (message.contentType == MessageType.custom_face) {
    }
  }

  static Future<bool> isExitFile(String? path) async {
    return isNotNullEmptyStr(path) ? await File(path!).exists() : false;
  }

  //fileExt 文件后缀名
  static String? getMediaType(final String filePath) {
    var fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    var fileExt = fileName.substring(fileName.lastIndexOf("."));
    switch (fileExt.toLowerCase()) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return "image/jpeg";
      case ".png":
        return "image/png";
      case ".bmp":
        return "image/bmp";
      case ".gif":
        return "image/gif";
      case ".json":
        return "application/json";
      case ".svg":
      case ".svgz":
        return "image/svg+xml";
      case ".mp3":
        return "audio/mpeg";
      case ".mp4":
        return "video/mp4";
      case ".mov":
        return "video/mov";
      case ".htm":
      case ".html":
        return "text/html";
      case ".css":
        return "text/css";
      case ".csv":
        return "text/csv";
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return "text/plain";
    }
    return null;
  }

  /// 将字节数转化为MB
  static String formatBytes(int bytes) {
    int kb = 1024;
    int mb = kb * 1024;
    int gb = mb * 1024;
    if (bytes >= gb) {
      return sprintf("%.1f GB", [bytes / gb]);
    } else if (bytes >= mb) {
      double f = bytes / mb;
      return sprintf(f > 100 ? "%.0f MB" : "%.1f MB", [f]);
    } else if (bytes > kb) {
      double f = bytes / kb;
      return sprintf(f > 100 ? "%.0f KB" : "%.1f KB", [f]);
    } else {
      return sprintf("%d B", [bytes]);
    }
  }

  // static IconData fileIcon(String fileName) {
  //   var mimeType = lookupMimeType(fileName) ?? '';
  //   if (mimeType == 'application/pdf') {
  //     return FontAwesomeIcons.solidFilePdf;
  //   } else if (mimeType == 'application/msword' ||
  //       mimeType ==
  //           'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
  //     return FontAwesomeIcons.solidFileWord;
  //   } else if (mimeType == 'application/vnd.ms-excel' ||
  //       mimeType ==
  //           'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
  //     return FontAwesomeIcons.solidFileExcel;
  //   } else if (mimeType == 'application/vnd.ms-powerpoint') {
  //     return FontAwesomeIcons.solidFilePowerpoint;
  //   } else if (mimeType.startsWith('audio/')) {
  //   } else if (mimeType == 'application/zip' ||
  //       mimeType == 'application/x-rar-compressed') {
  //     return FontAwesomeIcons.solidFileZipper;
  //   } else if (mimeType.startsWith('audio/')) {
  //     return FontAwesomeIcons.solidFileAudio;
  //   } else if (mimeType.startsWith('video/')) {
  //     return FontAwesomeIcons.solidFileVideo;
  //   } else if (mimeType.startsWith('image/')) {
  //     return FontAwesomeIcons.solidFileImage;
  //   } else if (mimeType == 'text/plain') {
  //     return FontAwesomeIcons.solidFileCode;
  //   }
  //   return FontAwesomeIcons.solidFileLines;
  // }

  static String fileIcon(String fileName) {
    var mimeType = lookupMimeType(fileName) ?? '';
    if (mimeType == 'application/pdf') {
      return ImageRes.filePdf;
    } else if (mimeType == 'application/msword' ||
        mimeType ==
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
      return ImageRes.fileWord;
    } else if (mimeType == 'application/vnd.ms-excel' ||
        mimeType ==
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
      return ImageRes.fileExcel;
    } else if (mimeType == 'application/vnd.ms-powerpoint') {
      return ImageRes.filePpt;
    } else if (mimeType.startsWith('audio/')) {
    } else if (mimeType == 'application/zip' ||
        mimeType == 'application/x-rar-compressed') {
      return ImageRes.fileZip;
    }
    /*else if (mimeType.startsWith('audio/')) {
      return FontAwesomeIcons.solidFileAudio;
    } else if (mimeType.startsWith('video/')) {
      return FontAwesomeIcons.solidFileVideo;
    } else if (mimeType.startsWith('image/')) {
      return FontAwesomeIcons.solidFileImage;
    } else if (mimeType == 'text/plain') {
      return FontAwesomeIcons.solidFileCode;
    }*/
    return ImageRes.fileUnknown;
  }

  static String createSummary(Message message) {
    return '${message.senderNickname}：${parseMsg(message, replaceIdToNickname: true)}';
  }

  static List<UserInfo>? convertSelectContactsResultToUserInfo(result) {
    if (result is Map) {
      final checkedList = <UserInfo>[];
      final values = result.values;
      for (final value in values) {
        if (value is UserInfo) {
          checkedList.add(value);
        } else if (value is DeptMemberInfo) {
          checkedList.add(UserInfo(
            userID: value.userID,
            nickname: value.nickname,
            faceURL: value.faceURL,
          ));
        }
      }
      return checkedList;
    }
    return null;
  }

  static List<String>? convertSelectContactsResultToUserID(result) {
    if (result is Map) {
      final checkedList = <String>[];
      final values = result.values;
      for (final value in values) {
        if (value is UserInfo) {
          checkedList.add(value.userID!);
        } else if (value is DeptMemberInfo) {
          checkedList.add(value.userID!);
        }
      }
      return checkedList;
    }
    return null;
  }

  static convertCheckedListToMap(List<dynamic>? checkedList) {
    if (null == checkedList) return null;
    final checkedMap = <String, dynamic>{};
    for (var item in checkedList) {
      if (item is ConversationInfo) {
        checkedMap[item.isSingleChat ? item.userID! : item.groupID!] = item;
      } else if (item is UserInfo) {
        checkedMap[item.userID!] = item;
      } else if (item is DeptMemberInfo) {
        checkedMap[item.userID!] = item;
      } else if (item is GroupInfo) {
        checkedMap[item.groupID] = item;
      } else if (item is TagInfo) {
        checkedMap[item.tagID!] = item;
      }
    }
    return checkedMap;
  }

  static List<Map<String, String?>> convertCheckedListToForwardObj(
      List<dynamic> checkedList) {
    final map = <Map<String, String?>>[];
    for (var item in checkedList) {
      if (item is UserInfo) {
        map.add({'nickname': item.nickname, 'faceURL': item.faceURL});
      } else if (item is DeptMemberInfo) {
        map.add({'nickname': item.nickname, 'faceURL': item.faceURL});
      } else if (item is GroupInfo) {
        map.add({'nickname': item.groupName, 'faceURL': item.faceURL});
      } else if (item is ConversationInfo) {
        map.add({'nickname': item.showName, 'faceURL': item.faceURL});
      }
    }
    return map;
  }

  static String? convertCheckedToUserID(dynamic info) {
    if (info is UserInfo) {
      return info.userID;
    } else if (info is ConversationInfo) {
      return info.userID;
    } else if (info is DeptMemberInfo) {
      return info.userID;
    }
    return null;
  }

  static String? convertCheckedToGroupID(dynamic info) {
    if (info is GroupInfo) {
      return info.groupID;
    } else if (info is ConversationInfo) {
      return info.groupID;
    }
    return null;
  }

  static List<Map<String, String?>> convertCheckedListToShare(
      Iterable<dynamic> checkedList) {
    final map = <Map<String, String?>>[];
    for (var item in checkedList) {
      if (item is UserInfo) {
        map.add({'userID': item.userID, 'groupID': null});
      } else if (item is DeptMemberInfo) {
        map.add({'userID': item.userID, 'groupID': null});
      } else if (item is GroupInfo) {
        map.add({'userID': null, 'groupID': item.groupID});
      } else if (item is ConversationInfo) {
        map.add({'userID': item.userID, 'groupID': item.groupID});
      }
    }
    return map;
  }

  static String getWorkMomentsTimeline(int ms) {
    final locTimeMs = DateTime.now().millisecondsSinceEpoch;
    final languageCode = Get.locale?.languageCode ?? 'zh';
    final isZH = languageCode == 'zh';

    if (DateUtil.isToday(ms, locMs: locTimeMs)) {
      return isZH ? '今天' : 'Today';
    }

    if (DateUtil.isYesterdayByMs(ms, locTimeMs)) {
      return isZH ? '昨天' : 'Yesterday';
    }

    if (DateUtil.isWeek(ms, locMs: locTimeMs)) {
      return DateUtil.getWeekdayByMs(ms, languageCode: languageCode);
    }

    if (DateUtil.yearIsEqualByMs(ms, locTimeMs)) {
      return formatDateMs(ms, format: isZH ? 'MM月dd' : 'MM/dd');
    }

    return formatDateMs(ms, format: isZH ? 'yyyy年MM月dd' : 'yyyy/MM/dd');
  }

  static String safeTrim(String text) {
    String pattern = '(${[regexAt, regexAtAll].join('|')})';
    RegExp regex = RegExp(pattern);
    Iterable<Match> matches = regex.allMatches(text);
    int? start;
    int? end;
    for (Match match in matches) {
      String? matchText = match.group(0);
      start ??= match.start;
      end = match.end;
      Logger.print("Matched: $matchText  start: $start  end: $end");
    }
    if (null != start && null != end) {
      final startStr = text.substring(0, start).trimLeft();
      final middleStr = text.substring(start, end);
      final endStr = text.substring(end).trimRight();
      return '$startStr$middleStr$endStr';
    }
    return text.trim();
  }

  static String getTimeFormat1() {
    bool isZh = Get.locale!.languageCode.toLowerCase().contains("zh");
    return isZh ? 'yyyy年MM月dd日' : 'yyyy/MM/dd';
  }

  static String getTimeFormat2() {
    bool isZh = Get.locale!.languageCode.toLowerCase().contains("zh");
    return isZh ? 'yyyy年MM月dd日 HH时mm分' : 'yyyy/MM/dd HH:mm';
  }

  static String getTimeFormat3() {
    bool isZh = Get.locale!.languageCode.toLowerCase().contains("zh");
    return isZh ? 'MM月dd日 HH时mm分' : 'MM/dd HH:mm';
  }

  static bool isValidPassword(String password) =>
      passwordRegExp.hasMatch(password);

  static TextInputFormatter getPasswordFormatter() =>
      FilteringTextInputFormatter.allow(
        // RegExp(r'[a-zA-Z0-9]'),
        RegExp(r'[a-zA-Z0-9@#$%^&+=!.]'),
      );
}
