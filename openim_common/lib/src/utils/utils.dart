import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:azlistview/azlistview.dart';
import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_date/dart_date.dart';
import 'package:extended_image/extended_image.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_common/src/utils/multi_thread_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter/foundation.dart';

class IntervalDo {
  DateTime? last;
  Timer? lastTimer;

  void run({required Function() fuc, int milliseconds = 0}) {
    DateTime now = DateTime.now();
    if (null == last || now.difference(last ?? now).inMilliseconds > milliseconds) {
      last = now;
      fuc();
    }
  }

  void drop({required Function() fun, int milliseconds = 0}) {
    lastTimer?.cancel();
    lastTimer = null;
    lastTimer = Timer(Duration(milliseconds: milliseconds), () {
      lastTimer!.cancel();
      lastTimer = null;
      fun.call();
    });
  }
}

class IMUtils {
  IMUtils._();

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

  static String getSuffix(String url) {
    if (!url.contains(".")) return "";
    return url.substring(url.lastIndexOf('.'), url.length);
  }

  static bool isGif(String url) {
    return IMUtils.getSuffix(url).contains("gif");
  }

  static void copy({required String text}) {
    Clipboard.setData(ClipboardData(text: text));
    IMViews.showToast(StrRes.copySuccessfully);
  }

  static List<ISuspensionBean> convertToAZList(List<ISuspensionBean> list) {
    for (int i = 0, length = list.length; i < length; i++) {
      setAzPinyinAndTag(list[i]);
    }

    SuspensionUtil.sortListBySuspensionTag(list);

    SuspensionUtil.setShowSuspensionStatus(list);

    return list;
  }

  static ISuspensionBean setAzPinyinAndTag(ISuspensionBean info) {
    if (info is ISUserInfo) {
      String pinyin = PinyinHelper.getPinyinE(info.showName);
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
      await ImageGallerySaverPlus.saveFile(cachePath);
    }
  }

  static String? emptyStrToNull(String? str) => (null != str && str.trim().isEmpty) ? null : str;

  static bool isNotNullEmptyStr(String? str) => null != str && "" != str.trim();

  static bool isChinaMobile(String mobile) {
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(mobile);
  }

  static bool isMobile(String areaCode, String mobile) =>
      (areaCode == '+86' || areaCode == '86') ? isChinaMobile(mobile) : true;

  static Future<File> getVideoThumbnail(File file) async {
    final path = file.path;
    final names = path.substring(path.lastIndexOf("/") + 1).split('.');
    final name = '${names.first}.png';
    final directory = await createTempDir(dir: 'video');
    final targetPath = '$directory/$name';

    final String ffmpegCommand = '-i $path -ss 0 -vframes 1 -q:v 15 -y $targetPath';
    final session = await FFmpegKit.execute(ffmpegCommand);

    final state = FFmpegKitConfig.sessionStateToString(await session.getState());
    final returnCode = await session.getReturnCode();

    if (state == SessionState.failed || !ReturnCode.isSuccess(returnCode)) {
      Logger().printError(info: "Command failed. Please check output for the details.");
    }

    session.cancel();

    return File(targetPath);
  }

  static Future<File?> compressVideoAndGetFile(File file) async {
    final path = file.path;
    final name = path.substring(path.lastIndexOf("/") + 1);
    final directory = await createTempDir(dir: 'video');
    final targetPath = '$directory/$name';

    final output = await FFprobeKit.getMediaInformation(path);
    final streams = output.getMediaInformation()?.getStreams();
    final isH264 = streams?.any((element) => element.getCodec()?.contains('h264') == true) ?? false;
    final size = output.getMediaInformation()?.getSize() ?? '0';
    output.cancel();

    final audioStream = streams?.firstWhereOrNull((e) => e.getType()?.contains('audio') == true);
    final isAAC = audioStream?.getCodec()?.toLowerCase() != 'aac';

    String ffmpegCommand =
        '-i $path -preset ultrafast -tune fastdecode -threads:v 16 -threads:a 1 -c:a aac -strict -2 -crf 20 -c:v libx264 -y '
        '$targetPath';

    if (File(targetPath).existsSync() && isH264) {
      if (isAAC) {
        return File(targetPath);
      } else {
        ffmpegCommand = '-i $path -c:v copy -c:a aac -q:a 2 -threads 4 $targetPath';
      }
    }

    if (int.parse(size) < 1024 * 1024 * 1024 && isH264) {
      if (isAAC) {
        file.copySync(targetPath);

        return File(targetPath);
      } else {
        ffmpegCommand = '-i $path -c:v copy -c:a aac -q:a 2 -threads 4 $targetPath';
      }
    }

    final session = await FFmpegKit.execute(ffmpegCommand);

    final state = await session.getState();
    final returnCode = await session.getReturnCode();

    if (state == SessionState.failed || !ReturnCode.isSuccess(returnCode)) {
      Logger().printError(info: "Command failed. Please check output for the details.");
      file.copySync(targetPath);

      return File(targetPath);
    }

    session.cancel();

    return File(targetPath);
  }

  static Future<File?> compressImageAndGetFile(File file, {int quality = 80}) async {
    var path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1).toLowerCase();

    if (name.endsWith('.gif')) {
      return file;
    }

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

    var targetDirectory = await getTempDirectory(name);

    if (file.path == targetDirectory.path) {
      targetDirectory = await getTempDirectory('compressed-$name');
    }

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetDirectory.path,
      quality: quality,
      minWidth: 1280,
      minHeight: 720,
      format: format,
    );

    return result != null ? File(result.path) : file;
  }

  static Future<String> createTempFile({
    required String dir,
    required String name,
  }) async {
    final storage = await createTempDir(dir: dir);
    File file = File('$storage/$name');
    if (!(await file.exists())) {
      file.create();
    }
    return file.path;
  }

  static Future<String> createTempDir({
    required String dir,
  }) async {
    Directory directory = await getTempDirectory(dir);

    if (!(await directory.exists())) {
      directory.create(recursive: true);
    }
    return directory.path;
  }

  static Future<Directory> getTempDirectory(String dir) async {
    final storage = await getApplicationCacheDirectory();
    Directory directory = Directory('${storage.path}/$dir');

    return directory;
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
    return '${info.fromUserID}-${info.toUserID}-${info.createTime}';
  }

  static Future<String> getCacheFileDir() async {
    return (await getTemporaryDirectory()).absolute.path;
  }

  static Future<String> getDownloadFileDir() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await PathProviderPlatform.instance.getDownloadsPath();
      } catch (err, st) {
        Logger.print('failed to get downloads path: $err, $st');
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath!;
  }

  static Future<String> toFilePath(String path) async {
    var filePrefix = 'file://';
    var uriPrefix = 'content://';
    if (path.contains(filePrefix)) {
      path = path.substring(filePrefix.length);
    } else if (path.contains(uriPrefix)) {
      File file = await toFile(path);
      path = file.path;
    }
    return path;
  }

  static List<Message> calChatTimeInterval(List<Message> list, {bool calculate = true}) {
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
    final dateTime = DateTime.fromMillisecondsSinceEpoch(ms);
    final languageCode = Get.locale?.languageCode ?? 'zh';
    final isChinese = languageCode == 'zh';
    final now = DateTime.now();
    final formatter = DateFormat(formatToday);

    if (isSameDay(dateTime, now)) {
      return formatter.format(
        dateTime,
      );
    }

    final yesterday = now.subtract(Duration(days: 1));

    if (isSameDay(dateTime, yesterday)) {
      return isChinese ? '昨天 ${formatter.format(dateTime)}' : 'Yesterday ${formatter.format(dateTime)}';
    }

    if (isSameWeek(dateTime, now)) {
      final weekDay = DateFormat('EEEE').format(dateTime);
      final weekDayChinese = {
        'Monday': StrRes.monday,
        'Tuesday': StrRes.tuesday,
        'Wednesday': StrRes.wednesday,
        'Thursday': StrRes.thursday,
        'Friday': StrRes.friday,
        'Saturday': StrRes.saturday,
        'Sunday': StrRes.sunday,
      };
      return '${isChinese ? weekDayChinese[weekDay]! : weekDay} ${formatter.format(dateTime)}';
    }

    if (dateTime.year == now.year) {
      final dateFormat = isChinese ? 'MM月dd HH:mm' : 'MM/dd HH:mm';
      return DateFormat(dateFormat).format(dateTime);
    }

    final dateFormat = isChinese ? 'yyyy年MM月dd HH:mm' : 'yyyy/MM/dd HH:mm';
    return DateFormat(dateFormat).format(dateTime);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static bool isSameWeek(DateTime date1, DateTime date2) {
    final weekStart = date2.subtract(Duration(days: date2.weekday - 1));
    final weekEnd = weekStart.add(Duration(days: 6));
    return date1.isAfter(weekStart.subtract(Duration(days: 1))) && date1.isBefore(weekEnd.add(Duration(days: 1)));
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

  static Map<String, List<Message>> groupingMessage(List<Message> list) {
    var languageCode = Get.locale?.languageCode ?? 'zh';
    var group = <String, List<Message>>{};
    for (var message in list) {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(message.sendTime!);
      String dateStr;
      if (DateUtil.isToday(message.sendTime!)) {
        dateStr = languageCode == 'zh' ? '今天' : 'Today';
      } else if (DateUtil.isWeek(message.sendTime!)) {
        dateStr = languageCode == 'zh' ? '本周' : 'This Week';
      } else if (dateTime.isThisMonth) {
        dateStr = languageCode == 'zh' ? '这个月' : 'This Month';
      } else {
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

  static String _combTime(int value, String unit) => value > 0 ? '$value$unit' : '';

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

  static Size calculateTextSize(
    String text,
    TextStyle style, {
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: text, style: style), maxLines: maxLines, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size;
  }

  static TextPainter getTextPainter(
    String text,
    TextStyle style, {
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) =>
      TextPainter(text: TextSpan(text: text, style: style), maxLines: maxLines, textDirection: TextDirection.ltr)
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
    return membersInfo.userID == OpenIM.iMManager.userID ? StrRes.you : membersInfo.nickname!;
  }

  static String getShowName(String? userID, String? nickname) {
    return (userID == OpenIM.iMManager.userID ? OpenIM.iMManager.userInfo.nickname : nickname) ?? '';
  }

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

              final label = StrRes.createGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupInfoSetNotification:
            {
              final ntf = GroupNotification.fromJson(map);
              if (ntf.group?.notification != null && ntf.group!.notification!.isNotEmpty) {
                return isConversation ? ntf.group!.notification! : null;
              }

              final label = StrRes.editGroupInfoNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.memberQuitNotification:
            {
              final ntf = QuitGroupNotification.fromJson(map);

              final label = StrRes.quitGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.quitUser!)]);
            }
            break;
          case MessageType.memberInvitedNotification:
            {
              final ntf = InvitedJoinGroupNotification.fromJson(map);

              final label = StrRes.invitedJoinGroupNtf;
              final b = ntf.invitedUserList?.map((e) => getGroupMemberShowName(e)).toList().join('、');
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!), b ?? '']);
            }
            break;
          case MessageType.memberKickedNotification:
            {
              final ntf = KickedGroupMemeberNotification.fromJson(map);

              final label = StrRes.kickedGroupNtf;
              final b = ntf.kickedUserList!.map((e) => getGroupMemberShowName(e)).toList().join('、');
              text = sprintf(label, [b, getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.memberEnterNotification:
            {
              final ntf = EnterGroupNotification.fromJson(map);

              final label = StrRes.joinGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.entrantUser!)]);
            }
            break;
          case MessageType.dismissGroupNotification:
            {
              final ntf = GroupNotification.fromJson(map);

              final label = StrRes.dismissGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupOwnerTransferredNotification:
            {
              final ntf = GroupRightsTransferNoticication.fromJson(map);

              final label = StrRes.transferredGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!), getGroupMemberShowName(ntf.newGroupOwner!)]);
            }
            break;
          case MessageType.groupMemberMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);

              final label = StrRes.muteMemberNtf;
              final c = ntf.mutedSeconds;
              text = sprintf(
                  label, [getGroupMemberShowName(ntf.mutedUser!), getGroupMemberShowName(ntf.opUser!), mutedTime(c!)]);
            }
            break;
          case MessageType.groupMemberCancelMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);

              final label = StrRes.muteCancelMemberNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.mutedUser!), getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);

              final label = StrRes.muteGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupCancelMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);

              final label = StrRes.muteCancelGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.friendApplicationApprovedNotification:
            {
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
            text = sprintf(StrRes.memberInfoChangedNtf, [getGroupMemberShowName(ntf.opUser!)]);
            break;
          case MessageType.groupInfoSetAnnouncementNotification:
            if (isConversation) {
              final ntf = GroupNotification.fromJson(map);
              text = ntf.group?.notification ?? '';
            }
            break;
          case MessageType.groupInfoSetNameNotification:
            final ntf = GroupNotification.fromJson(map);
            text = sprintf(StrRes.whoModifyGroupName, [getGroupMemberShowName(ntf.opUser!), ntf.group?.groupName]);
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
          content = message.textElem!.content!;
          break;
        case MessageType.atText:
          content = message.atTextElem!.text!;
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
            if (isSelf) {
              content = '${StrRes.you} ${StrRes.revokeMsg}';
            } else {
              content = '${message.senderNickname} ${StrRes.revokeMsg}';
            }
          } else {
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
        case MessageType.customFace:
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
              content = '[${type == 'video' ? StrRes.callVideo : StrRes.callVoice}]';
              break;
            case CustomMessageType.emoji:
              content = '[${StrRes.emoji}]';
              break;
            case CustomMessageType.tag:
              if (null != customData['textElem']) {
                final textElem = TextElem.fromJson(customData['textElem']);
                content = textElem.content;
              } else if (null != customData['soundElem']) {
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
    content = content?.replaceAll("\n", " ");
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
                      content = sprintf(StrRes.callDuration, [seconds2HMS(duration)]);
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
                    case 'networkError':
                      content = StrRes.networkAnomaly;
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
      if (message.contentType == MessageType.atText) {
        final atUserIDs = message.atTextElem!.atUserList!;
        final atUserInfos = message.atTextElem!.atUsersInfo!;

        for (final userID in atUserIDs) {
          final groupNickname =
              (newMapping[userID] ?? atUserInfos.firstWhere((e) => e.atUserID == userID).groupNickname) ?? userID;
          mapping[userID] = getAtNickname(userID, groupNickname);
        }
      }
    } catch (_) {}
    return mapping;
  }

  static String getAtNickname(String atUserID, String atNickname) {
    return atUserID == 'atAllTag' ? StrRes.everyone : atNickname;
  }

  static void previewUrlPicture(
    List<MediaSource> sources, {
    int currentIndex = 0,
    String? heroTag,
  }) =>
      navigator?.push(TransparentRoute(
        builder: (BuildContext context) => GestureDetector(
          onTap: () => Get.back(),
          child: ChatPicturePreview(
            currentIndex: currentIndex,
            images: sources,
            heroTag: heroTag,
            onLongPress: (url) {
              IMViews.openDownloadSheet(
                url,
                onDownload: () => saveImage(context, url),
              );
            },
          ),
        ),
      ));

  /*Get.to(
        () => ChatPicturePreview(
          currentIndex: currentIndex,
          images: urls,

          heroTag: urls.elementAt(currentIndex),
          onLongPress: (url) {
            IMViews.openDownloadSheet(
              url,
              onDownload: () => HttpUtil.saveUrlPicture(url),
            );
          },
        ),

        transition: Transition.cupertino,


      );*/

  static void previewCustomFace(Message message) {
    final face = message.faceElem;
    final map = json.decode(face!.data!);
    final urls = <String>[map['url']];

    Get.to(
      () => ChatFacePreview(url: map['url']),
      popGesture: true,
      transition: Transition.cupertino,
    );
  }

  static void previewPicture(
    Message message, {
    List<Message> allList = const [],
  }) {
    if (allList.isEmpty) {
      previewUrlPicture(
        [
          MediaSource(
              url: message.pictureElem!.sourcePicture!.url!, thumbnail: message.pictureElem!.snapshotPicture!.url!)
        ],
        currentIndex: 0,
      );
    } else {
      final picList = allList
          .where((element) => element.contentType == MessageType.picture || element.contentType == MessageType.video)
          .toList();
      final index = picList.indexOf(message);
      final urls = picList.map((e) {
        if (e.contentType == MessageType.picture) {
          return MediaSource(url: e.pictureElem!.sourcePicture!.url!, thumbnail: e.pictureElem!.snapshotPicture!.url!);
        } else {
          return MediaSource(url: e.videoElem!.videoUrl!, thumbnail: e.videoElem!.snapshotUrl!);
        }
      }).toList();
      previewUrlPicture(urls, currentIndex: index == -1 ? 0 : index);
    }
  }

  static void previewVideo(Message message) {
    navigator!.push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ChatVideoPlayerView(
            path: message.videoElem?.videoPath,
            url: message.videoElem?.videoUrl,
            coverUrl: message.videoElem?.snapshotUrl,
            heroTag: null,
            onDownload: (url, file) {
              if (file != null) {
                HttpUtil.saveFileToGallerySaver(file);
              } else {
                HttpUtil.saveUrlVideo(url!);
              }
            },
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        opaque: false));
  }

  static void previewFile(Message message) async {
    final fileElem = message.fileElem;
    if (null != fileElem) {
      final sourcePath = fileElem.filePath;
      final url = fileElem.sourceUrl;
      final fileName = fileElem.fileName;
      final fileSize = fileElem.fileSize;
      final nameAndExt = fileName?.split('.');
      final name = nameAndExt?.first;
      final ext = nameAndExt?.last;

      final dir = await getDownloadFileDir();

      var cachePath = '$dir/${name}_${message.clientMsgID}.$ext';

      final isExitSourcePath = await isExitFile(sourcePath);

      final isExitCachePath = await isExitFile(cachePath);

      Logger.print('isExitSourcePath:$isExitSourcePath, isExitCachePath:$isExitCachePath, cachePath:$cachePath');

      final isExitNetwork = isUrlValid(url);
      String? availablePath;
      if (isExitSourcePath) {
        availablePath = sourcePath;
      } else if (isExitCachePath) {
        availablePath = cachePath;
      }
      final isAvailableFileSize =
          isExitSourcePath || isExitCachePath ? (await File(availablePath!).length() == fileSize) : false;
      Logger.print('previewFile isAvailableFileSize: $isAvailableFileSize   isExitNetwork: $isExitNetwork');
      if (isAvailableFileSize) {
        String? mimeType = lookupMimeType(fileName ?? '');
        if (null != mimeType && allowVideoType(mimeType)) {
          previewVideo(Message()
            ..clientMsgID = message.clientMsgID
            ..contentType = MessageType.video
            ..videoElem = VideoElem(videoPath: availablePath, videoUrl: url));
        } else if (null != mimeType && mimeType.contains('image')) {
          previewPicture(Message()
            ..clientMsgID = message.clientMsgID
            ..contentType = MessageType.picture
            ..pictureElem = PictureElem(sourcePath: availablePath, sourcePicture: PictureInfo(url: url)));
        } else {
          openFileByOtherApp(availablePath);
        }
      } else {
        if (isExitNetwork) {
          if (Get.isRegistered<DownloadController>()) {
            final controller = Get.find<DownloadController>();
            controller.clickFileMessage(url!, cachePath);
          }
        }
      }
    }
  }

  static Future previewMediaFile(
      {required BuildContext context,
      required Message message,
      bool muted = false,
      bool Function(int)? onAutoPlay,
      ValueChanged<int>? onPageChanged,
      bool onlySave = false,
      ValueChanged<OperateType>? onOperate}) {
    void saveVideo(BuildContext ctx, String url, {int? length}) async {
      final cachedVideoControllerService = CachedVideoControllerService(DefaultCacheManager());
      final cached = await cachedVideoControllerService.getCacheFile(url);

      if (cached != null) {
        LoadingView.singleton.show();
        await HttpUtil.saveFileToGallerySaver(
          cached,
          name: url.split('/').last,
        );
        LoadingView.singleton.dismiss();
      } else {
        LoadingView.singleton.show();

        final downloader = MultiThreadDownloader(url: url, fileName: url.split('/').last, length: length);

        callback(EasyLoadingStatus status) {
          if (status == EasyLoadingStatus.dismiss) {
            downloader.cancel();
            EasyLoading.removeCallback(callback);
            EasyLoading.dismiss();
          }
        }

        EasyLoading.addStatusCallback(callback);

        final filePath = await downloader.start();

        if (filePath != null) {
          HttpUtil.saveFileToGallerySaver(
            File(filePath),
            name: url.split('/').last,
            showTaost: LoadingView.singleton.isProgressVisible,
          );
        }
        EasyLoading.removeCallback(callback);
        EasyLoading.dismiss();
      }
    }

    void showBottomBar(int index) {
      if (onOperate == null && !onlySave) {
        return;
      }

      PhotoBrowserBottomBar.show(
        context,
        onlySave: onlySave,
        onPressedButton: (type) async {
          final msg = message;
          switch (type) {
            case OperateType.save:
              if (msg.videoElem != null) {
                saveVideo(context, msg.videoElem!.videoUrl!, length: msg.videoElem!.videoSize);
              } else {
                final url = msg.pictureElem?.sourcePicture?.url;
                if (url?.isNotEmpty == true) {
                  saveImage(context, url!);
                }
              }
              break;
            case OperateType.forward:
              onOperate?.call(type);
              break;
          }
        },
      );
    }

    final sources = message.isVideoType
        ? MediaSource(
            url: message.videoElem?.videoUrl,
            thumbnail: message.videoElem!.snapshotUrl?.adjustThumbnailAbsoluteString(960) ?? '',
            file: File(message.videoElem!.videoPath!),
            tag: message.clientMsgID,
            isVideo: true,
          )
        : MediaSource(
            url: message.pictureElem?.sourcePicture?.url,
            thumbnail: message.pictureElem!.snapshotPicture?.url?.adjustThumbnailAbsoluteString(960) ?? '',
            file: File(message.pictureElem!.sourcePath!),
            tag: message.clientMsgID,
          );

    final mb = MediaBrowser(
      sources: [sources],
      initialIndex: 0,
      onAutoPlay: (index) => onAutoPlay != null ? onAutoPlay(index) : false,
      muted: muted,
      onSave: (index) {
        final msg = message;
        final url = msg.videoElem?.videoUrl;

        if (url != null) {
          saveVideo(context, url, length: msg.videoElem!.videoSize);
        }
      },
      onLongPress: (index) {
        showBottomBar(index);
      },
    );
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return mb;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  static void saveImage(BuildContext ctx, String url) async {
    EasyLoading.show(dismissOnTap: true);
    final imageFile = await getCachedImageFile(url);

    if (imageFile != null) {
      await HttpUtil.saveFileToGallerySaver(
        imageFile,
        name: url.split('/').last,
      );

      EasyLoading.dismiss();
    } else {
      HttpUtil.saveUrlPicture(url, onCompletion: () {
        EasyLoading.dismiss();
      });
    }
  }

  static openFileByOtherApp(String path) async {
    OpenResult result = await OpenFilex.open(path);
    if (result.type == ResultType.noAppToOpen) {
      IMViews.showToast("没有可支持的应用");
    } else if (result.type == ResultType.permissionDenied) {
      IMViews.showToast("无权限访问");
    } else if (result.type == ResultType.fileNotFound) {
      IMViews.showToast("文件已失效");
    }
  }

  static void previewLocation(Message message) {
    var location = message.locationElem;
    Map detail = json.decode(location!.description!);
    Logger.print('previewLocation ${location.latitude}  ${location.longitude}');
    Get.to(
      () => MapView(
        latitude: location.latitude!,
        longitude: location.longitude!,
        address1: detail['name'],
        address2: detail['addr'],
      ),
      transition: Transition.cupertino,
      popGesture: true,
    );
  }

  static void previewCarteMessage(
    Message message,
    Function(UserInfo userInfo)? onViewUserInfo,
  ) =>
      onViewUserInfo?.call(UserInfo.fromJson(message.cardElem!.toJson()));

  static void parseClickEvent(
    Message message, {
    Function(UserInfo userInfo)? onViewUserInfo,
    Function(Message msg)? meetingItemClick,
    VoidCallback? onForward,
  }) async {
    if (message.contentType == MessageType.picture || message.contentType == MessageType.video) {
      previewMediaFile(
        context: Get.context!,
        message: message,
        onOperate: (value) {
          if (value == OperateType.forward) {
            onForward?.call();
          }
        },
      );
    } else if (message.contentType == MessageType.file) {
      previewFile(message);
    } else if (message.contentType == MessageType.card) {
      previewCarteMessage(message, onViewUserInfo);
    } else if (message.contentType == MessageType.location) {
      previewLocation(message);
    } else if (message.contentType == MessageType.customFace) {
      previewCustomFace(message);
    }
  }

  static Future<bool> isExitFile(String? path) async {
    return isNotNullEmptyStr(path) ? await File(path!).exists() : false;
  }

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

  static bool allowImageType(String? mimeType) {
    final result = mimeType?.contains('png') == true ||
        mimeType?.contains('jpeg') == true ||
        mimeType?.contains('gif') == true ||
        mimeType?.contains('bmp') == true ||
        mimeType?.contains('webp') == true ||
        mimeType?.contains('heic') == true;

    return result;
  }

  static bool allowVideoType(String? mimeType) {
    final result = mimeType?.contains('mp4') == true ||
        mimeType?.contains('3gpp') == true ||
        mimeType?.contains('webm') == true ||
        mimeType?.contains('x-msvideo') == true ||
        mimeType?.contains('quicktime') == true;

    return result;
  }

  static String fileIcon(String fileName) {
    var mimeType = lookupMimeType(fileName) ?? '';
    if (mimeType == 'application/pdf') {
      return ImageRes.filePdf;
    } else if (mimeType == 'application/msword' ||
        mimeType == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
      return ImageRes.fileWord;
    } else if (mimeType == 'application/vnd.ms-excel' ||
        mimeType == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
      return ImageRes.fileExcel;
    } else if (mimeType == 'application/vnd.ms-powerpoint') {
      return ImageRes.filePpt;
    } else if (mimeType.startsWith('audio/')) {
    } else if (mimeType == 'application/zip' || mimeType == 'application/x-rar-compressed') {
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
        if (value is ISUserInfo) {
          checkedList.add(UserInfo.fromJson(value.toJson()));
        } else if (value is UserFullInfo) {
          checkedList.add(UserInfo.fromJson(value.toJson()));
        } else if (value is FriendInfo) {
          checkedList.add(UserInfo.fromJson(value.toJson()));
        } else if (value is UserInfo) {
          checkedList.add(value);
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
        if (value is UserInfo || value is FriendInfo || value is UserFullInfo || value is ISUserInfo) {
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
      } else if (item is UserInfo || item is UserFullInfo || item is ISUserInfo || item is FriendInfo) {
        checkedMap[item.userID!] = item;
      } else if (item is GroupInfo) {
        checkedMap[item.groupID] = item;
      }
    }
    return checkedMap;
  }

  static List<Map<String, String?>> convertCheckedListToForwardObj(List<dynamic> checkedList) {
    final map = <Map<String, String?>>[];
    for (var item in checkedList) {
      if (item is UserInfo || item is UserFullInfo || item is ISUserInfo || item is FriendInfo) {
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
    if (info is UserInfo || info is UserFullInfo || info is ISUserInfo || info is FriendInfo) {
      return info.userID;
    } else if (info is ConversationInfo) {
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

  static List<Map<String, String?>> convertCheckedListToShare(Iterable<dynamic> checkedList) {
    final map = <Map<String, String?>>[];
    for (var item in checkedList) {
      if (item is UserInfo || item is UserFullInfo || item is ISUserInfo || item is FriendInfo) {
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

  static Future<bool> checkingBiometric(LocalAuthentication auth) => auth.authenticate(
        localizedReason: 'Scan your fingerprint (or face or other) to authenticate.',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
        authMessages: <AuthMessages>[
          const AndroidAuthMessages(
            cancelButton: 'No, thanks',
            biometricNotRecognized: 'Biometric not recognized. Try again.',
            biometricHint: 'Verify identity',
            biometricSuccess: 'Success',
            biometricRequiredTitle: 'Authentication required',
            goToSettingsDescription:
                "No biometric authentication is set up on your device. Go to Settings > Security to add biometric authentication.",
            goToSettingsButton: 'Go to settings',
            deviceCredentialsRequiredTitle: 'Device credentials required',
            deviceCredentialsSetupDescription: 'Device credentials required',
            signInTitle: 'Authentication required',
          ),
          const IOSAuthMessages(
            cancelButton: 'No, thanks',
            goToSettingsButton: 'Go to settings',
            goToSettingsDescription:
                'No biometric authentication is set up on your device. Please enable Touch ID or Face ID on your phone.',
            lockOut: 'Biometric authentication is disabled. Please lock and unlock your screen to enable it.',
          ),
        ],
      );

  static String safeTrim(String text) {
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

  static bool isValidPassword(String password) => RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d\S]{6,20}$',
      ).hasMatch(password);

  static TextInputFormatter getPasswordFormatter() => FilteringTextInputFormatter.allow(
        RegExp(r'[a-zA-Z0-9\S]'),
      );

  static Future requestBackgroundPermission({required String title, required String text, bool isRetry = false}) async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      bool hasPermissions = await FlutterBackground.hasPermissions;
      if (!isRetry) {
        hasPermissions = await FlutterBackground.initialize(
            androidConfig: FlutterBackgroundAndroidConfig(
                notificationTitle: title,
                notificationText: text,
                notificationImportance: AndroidNotificationImportance.normal,
                notificationIcon: const AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
                shouldRequestBatteryOptimizationsOff: false));
      }
      if (hasPermissions && !FlutterBackground.isBackgroundExecutionEnabled) {
        await FlutterBackground.enableBackgroundExecution();
      }
    } catch (e) {
      if (!isRetry) {
        return await Future<void>.delayed(
            const Duration(seconds: 1), () => requestBackgroundPermission(title: title, text: text, isRetry: true));
      }
    }
  }
}

extension PlatformExt on Platform {
  static bool get isMobile => Platform.isIOS || Platform.isAndroid;

  static bool get isDesktop => Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}
