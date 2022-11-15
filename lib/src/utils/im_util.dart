import 'dart:convert';
import 'dart:io';

import 'package:azlistview/azlistview.dart';
import 'package:common_utils/common_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:mime_type/mime_type.dart';
import 'package:open_file/open_file.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/models/group_member_info.dart' as en;
import 'package:openim_demo/src/pages/chat/chat_logic.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';

import 'http_util.dart';

/// 间隔时间完成某事
class IntervalDo {
  DateTime? last;

  void run({required Function() fuc, int milliseconds = 0}) {
    DateTime now = DateTime.now();
    if (null == last || now.difference(last ?? now).inMilliseconds > milliseconds) {
      last = now;
      fuc();
    }
  }
}

class IMUtil {
  IMUtil._();

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
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: '',
        ),
      ],
    );
  }

  static void copy({required String text}) {
    Clipboard.setData(ClipboardData(text: text));
    // IMWidget.cancel();
    IMWidget.showToast(StrRes.copySuccessfully);
  }

  static List<ISuspensionBean> convertToAZList(List<ISuspensionBean> list) {
    for (int i = 0, length = list.length; i < length; i++) {
      setAzPinyinAndTag(list[i]);
      // String pinyin = PinyinHelper.getPinyinE(list[i].getShowName());
      // String tag = pinyin.substring(0, 1).toUpperCase();
      // list[i].namePinyin = pinyin;
      // if (RegExp("[A-Z]").hasMatch(tag)) {
      //   list[i].tagIndex = tag;
      // } else {
      //   list[i].tagIndex = "#";
      // }
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
    if (info is ContactsInfo) {
      String pinyin = PinyinHelper.getPinyinE(info.getShowName());
      String tag = pinyin.substring(0, 1).toUpperCase();
      info.namePinyin = pinyin.toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        info.tagIndex = tag;
      } else {
        info.tagIndex = "#";
      }
    } else if (info is en.GroupMembersInfo) {
      String pinyin = PinyinHelper.getPinyinE(info.nickname!);
      String tag = pinyin.substring(0, 1).toUpperCase();
      info.namePinyin = pinyin.toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        info.tagIndex = tag;
      } else {
        info.tagIndex = "#";
      }
    }
    return info;
  }

  static void openPicture(
    List<Message> list, {
    bool replace = false,
    int index = 0,
    String? tag,
  }) async {
    final picInfoList = <PicInfo>[];
    try {
      var picElem;
      var file;
      for (var msg in list) {
        picElem = msg.pictureElem;
        if (null != picElem.sourcePath && picElem.sourcePath.isNotEmpty) {
          file = File(picElem.sourcePath);
          if (!(await file.exists())) {
            file = null;
          }
        }
        picInfoList.add(PicInfo(file: file, url: picElem.sourcePicture?.url));
      }
    } catch (e) {}
    replace
        ? Get.off(
            () => previewPic(picList: picInfoList, index: index, tag: tag),
          )
        : Get.to(
            () => previewPic(picList: picInfoList, index: index, tag: tag),
          );
  }

  static void openVideo(Message msg, {bool replace = false}) async {
    replace
        ? Get.off(() => _previewVideo(
              path: msg.videoElem?.videoPath,
              url: msg.videoElem?.videoUrl,
              coverUrl: msg.videoElem?.snapshotUrl,
              tag: msg.clientMsgID,
            ))
        : Get.to(() => _previewVideo(
              path: msg.videoElem?.videoPath,
              url: msg.videoElem?.videoUrl,
              coverUrl: msg.videoElem?.snapshotUrl,
              tag: msg.clientMsgID,
            ));
  }

  static void openFile(
    Message msg, {
    Future Function(String url, String path)? onDownload,
  }) async {
    var isFrom = msg.sendID != OpenIM.iMManager.uid;
    var fileElem = msg.fileElem;
    if (null != fileElem) {
      var sourcePath = fileElem.filePath;
      var url = fileElem.sourceUrl;
      var fileName = fileElem.fileName;
      var fileSize = fileElem.fileSize;
      var cachePath = '${(await getTemporaryDirectory()).path}/${msg.clientMsgID}_$fileName';
      print('cachePath:$cachePath');
      // 原路径
      var isExitSourcePath = await isExitFile(sourcePath);
      // 自己下载保存路径
      var isExitCachePath = await isExitFile(cachePath);
      // 网络地址
      var isExitNetwork = isNotNullStr(url);
      var availablePath;
      if (isExitSourcePath) {
        availablePath = sourcePath;
      } else if (isExitCachePath) {
        availablePath = cachePath;
      }
      if (null != availablePath) {
        String? mimeType = mime(fileName);
        if (null != mimeType && mimeType.contains('video')) {
          openVideo(Message()
            ..clientMsgID = msg.clientMsgID
            ..videoElem = VideoElem(videoPath: availablePath, videoUrl: url));
        } else if (null != mimeType && mimeType.contains('image')) {
          openPicture([
            Message()
              ..clientMsgID = msg.clientMsgID
              ..pictureElem = PictureElem(
                sourcePath: availablePath,
                sourcePicture: PictureInfo(url: url),
              )
          ]);
        } else {
          OpenFile.open(availablePath);
        }
      } else {
        print('fileName:$fileName');
        print('fileSize:$fileSize');
        print('sourcePath:$sourcePath');
        print('cachePath:$cachePath');
        print('url:$url');
        final logic = Get.find<ChatLogic>();
        print('logic:$logic');
        if (url == null) return;
        Get.to(() => ChatFilePreview(
              msgId: msg.clientMsgID!,
              name: fileName!,
              size: fileSize!,
              dio: dio,
              url: url,
              available: isExitNetwork || isExitSourcePath,
              cachePath: cachePath,
              onDownloadStart: () {
                IMWidget.showToast(StrRes.startDownload);
              },
              onDownloadFinished: () async {
                String? mimeType = mime(fileName);
                if (null != mimeType) {
                  await saveMediaToGallery(mimeType, cachePath);
                }
                IMWidget.showToast(sprintf(StrRes.fileSaveToPath, [cachePath]));
                if (null != mimeType && mimeType.contains('video')) {
                  openVideo(
                    Message()
                      ..clientMsgID = msg.clientMsgID
                      ..videoElem = VideoElem(
                        videoPath: cachePath,
                        videoUrl: url,
                      ),
                    replace: true,
                  );
                } else if (null != mimeType && mimeType.contains('image')) {
                  openPicture(
                    [
                      Message()
                        ..clientMsgID = msg.clientMsgID
                        ..pictureElem = PictureElem(
                          sourcePath: cachePath,
                          sourcePicture: PictureInfo(url: url),
                        )
                    ],
                    replace: true,
                  );
                } else {
                  OpenFile.open(cachePath);
                }
              },
            ));
      }
    }
  }

  static saveMediaToGallery(String mimeType, String cachePath) async {
    if (mimeType.contains('video') || mimeType.contains('image')) {
      await ImageGallerySaver.saveFile(cachePath);
    }
  }

  static Widget previewPic({
    required List<PicInfo> picList,
    int index = 0,
    String? tag,
  }) =>
      ChatPicturePreview(
        heroTag: tag,
        picList: picList,
        index: index,
        dio: dio,
        onStartDownload: (url, path) {
          IMWidget.showToast(StrRes.startDownload);
        },
        onDownloadFinished: (url, path) async {
          final result = await ImageGallerySaver.saveFile(path);
          IMWidget.showToast(sprintf(StrRes.picSaveToPath, [result['filePath']]));
        },
      );

  static Widget _previewVideo({String? path, String? url, String? coverUrl, String? tag}) =>
      ChatVideoPlayerView(
        path: path,
        url: url,
        coverUrl: coverUrl,
        heroTag: tag,
        onStartDownload: (url, path) {
          IMWidget.showToast(StrRes.startDownload);
        },
        onDownloadFinished: (url, path) async {
          final result = await ImageGallerySaver.saveFile(path);
          IMWidget.showToast(sprintf(StrRes.videoSaveToPath, [result['filePath']]));
        },
      );

  static String parseMsg(Message message) {
    String content;
    print('contentType:${message.contentType}');
    switch (message.contentType) {
      case MessageType.text:
        content = message.content!.trim();
        break;
      case MessageType.at_text:
        content = message.content!.trim();
        try {
          Map map = json.decode(content);
          var text = map['text'];
          bool isAtSelf = text.contains('@${OpenIM.iMManager.uid} ');
          // bool isAtSelf = map['isAtSelf'];
          if (isAtSelf == true) {
            content = '@${StrRes.you}${text.replaceAll('@${OpenIM.iMManager.uid}', '')}';
          }
        } catch (e) {}
        break;
      case MessageType.picture:
        content = '[${StrRes.picture}]';
        break;
      // case MessageType.voice:
      //   break;
      case MessageType.video:
        content = '[${StrRes.video}]';
        break;
      case MessageType.file:
        content = '[${StrRes.file}]';
        break;
      case MessageType.location:
        content = '[${StrRes.location}]';
        break;
      case MessageType.quote:
        content = '${message.quoteElem?.text ?? ''}';
        break;
      case MessageType.revoke:
        var isSelf = message.sendID == OpenIM.iMManager.uid;
        if (isSelf) {
          content = '${StrRes.you}${StrRes.revoke}';
        } else {
          content = '"${message.senderNickname}"${StrRes.revoke}';
        }
        break;
      case MessageType.merger:
        content = '[${StrRes.chatRecord}]';
        break;
      default:
        // content = '消息内容未解析';
        content = message.content!.trim();
        break;
    }
    return content;
  }

  static bool isNotNullStr(String? str) => null != str && "" != str.trim();

  static Future<bool> isExitFile(String? path) async {
    return isNotNullStr(path) ? await File(path!).exists() : false;
  }

  static bool isMobile(String mobile) {
    RegExp exp =
        RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(mobile);
  }

  // md5 加密
  static String? generateMD5(String? data) {
    if (null == data) return null;
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  static bool isNoEmpty(String? value) {
    return null != value && value.trim().isNotEmpty;
  }

  static List<Message> calChatTimeInterval(List<Message> list) {
    var milliseconds = list.first.sendTime!;
    list.first.ext = true;
    var lastShowTimeStamp = milliseconds;
    for (var i = 1; i < list.length; i++) {
      var index = i + 1;
      if (index <= list.length - 1) {
        var date1 = DateUtil.getDateTimeByMs(lastShowTimeStamp);
        var milliseconds = list.elementAt(index).sendTime! ~/ (1000 * 1000);
        var date2 = DateUtil.getDateTimeByMs(milliseconds);
        if (date2.difference(date1).inMinutes > 5) {
          lastShowTimeStamp = milliseconds;
          list.elementAt(index).ext = true;
        }
      }
    }
    return list;
  }

  static String getChatTimeline(int milliseconds) {
    // int milliseconds = nanosecond ~/ (1000 * 1000);
    return TimelineUtil.formatA(
      milliseconds,
      languageCode: Get.locale?.languageCode ?? 'en',
    );
  }

  static String getCallTimeline(int milliseconds) {
    if (DateUtil.yearIsEqualByMs(milliseconds, DateUtil.getNowDateMs())) {
      return DateUtil.formatDateMs(milliseconds, format: 'MM-dd');
    } else {
      return DateUtil.formatDateMs(milliseconds, format: 'yyyy-MM-dd');
    }
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

  ///  compress file and get file.
  static Future<File?> compressAndGetPic(File file) async {
    var path = file.path;
    var name = path.substring(path.lastIndexOf("/"));
    var targetPath = await createTempFile(fileName: name, dir: 'pic');
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
      quality: 100,
      minWidth: 480,
      minHeight: 800,
      format: format,
    );
    return result;
  }

  static Future<String> createTempFile({
    required String dir,
    required String fileName,
  }) async {
    var path =
        (Platform.isIOS ? await getTemporaryDirectory() : await getExternalStorageDirectory())
            ?.path;
    File file = File('$path/$dir/$fileName');
    if (!(await file.exists())) {
      file.create(recursive: true);
    }
    return '$path/$dir/$fileName';
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
      if (diff == 0)
        continue;
      else
        return diff > 0 ? 1 : -1;
    }
    return diff;
  }


  static int _platform = -9;

  static Future<int> getPlatform() async {
    if (_platform == -9) {
      _platform = await _platformID(Get.context!);
    }
    return _platform;
  }

  // 1 iPhone 2 android  8 android pad 9 iPad
  static Future<int> _platformID(BuildContext context) async {
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      var iPad = iosInfo.utsname.machine?.toLowerCase().contains("ipad");

      if (iPad != true) {
        iPad = iosInfo.model?.toLowerCase() == "ipad";
      }

      return iPad == true ? 9 : 1;
    } else {
      // The equivalent of the "smallestWidth" qualifier on Android.
      var shortestSide = MediaQuery.of(context).size.shortestSide;
      // Determine if we should use mobile layout or not, 600 here is
      // a common breakpoint for a typical 7-inch tablet.
      return shortestSide > 600 ? 8 : 2;
    }
  }

  static bool isPhoneNumber(String areaCode, String mobile) {
    if (areaCode == '+86') {
      return isMobile(mobile);
    }
    return true;
  }
}
