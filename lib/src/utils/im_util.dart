import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:azlistview/azlistview.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:mime_type/mime_type.dart';
import 'package:open_file/open_file.dart';
import 'package:openim_enterprise_chat/src/models/contacts_info.dart';
import 'package:openim_enterprise_chat/src/models/group_member_info.dart' as en;
import 'package:openim_enterprise_chat/src/pages/chat/chat_logic.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';
import 'package:path_provider/path_provider.dart';

import 'date_util.dart';
import 'http_util.dart';

class IMUtil {
  IMUtil._();

  static Future<File?> uCrop(String path) {
    return ImageCropper.cropImage(
      sourcePath: path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
        minimumAspectRatio: 1.0,
      ),
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
      info.namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        info.tagIndex = tag;
      } else {
        info.tagIndex = "#";
      }
    } else if (info is en.GroupMembersInfo) {
      String pinyin = PinyinHelper.getPinyinE(info.nickName!);
      String tag = pinyin.substring(0, 1).toUpperCase();
      info.namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        info.tagIndex = tag;
      } else {
        info.tagIndex = "#";
      }
    }
    return info;
  }

  static void openPicture(Message msg, {bool replace = false}) async {
    File? file;
    try {
      file = File(msg.pictureElem?.sourcePath ?? '');
      if (!(await file.exists())) {
        file = null;
      }
    } catch (e) {}
    replace
        ? Get.off(
            () => previewPic(
              id: msg.clientMsgID!,
              url: msg.pictureElem?.sourcePicture?.url,
              file: file,
            ),
          )
        : Get.to(
            () => previewPic(
              id: msg.clientMsgID!,
              url: msg.pictureElem?.sourcePicture?.url,
              file: file,
            ),
          );
  }

  static void openVideo(Message msg, {bool replace = false}) async {
    replace
        ? Get.off(() => _previewVideo(
              path: msg.videoElem?.videoPath,
              url: msg.videoElem?.videoUrl,
            ))
        : Get.to(() => _previewVideo(
              path: msg.videoElem?.videoPath,
              url: msg.videoElem?.videoUrl,
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
      var cachePath =
          '${(await getTemporaryDirectory()).path}/${msg.clientMsgID}_$fileName';
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
          openPicture(Message()
            ..clientMsgID = msg.clientMsgID
            ..pictureElem = PictureElem(
              sourcePath: availablePath,
              sourcePicture: PictureInfo(url: url),
            ));
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
        CancelToken? cancelToken = CancelToken();
        Get.to(() => ChatFilePreview(
              msgId: msg.clientMsgID!,
              name: fileName!,
              size: fileSize!,
              // path: sourcePath,
              url: url,
              available: isExitNetwork || isExitSourcePath,
              subject: logic.downloadProgressSubject,
              onDownload: (url) async {
                print(url);
                // await onDownload?.call(url, cachePath);
                IMWidget.showToast("开始下载");
                await dio.download(
                  url,
                  cachePath,
                  options: Options(receiveTimeout: 60 * 1000),
                  cancelToken: cancelToken,
                  onReceiveProgress: (int count, int total) {
                    logic.downloadProgressSubject.addSafely(MsgStreamEv(
                      msgId: msg.clientMsgID!,
                      value: count / total,
                    ));
                  },
                );
                final result = await ImageGallerySaver.saveFile(cachePath);
                print(result);
                IMWidget.showToast("文件已保存至${result['filePath']}");
                String? mimeType = mime(fileName);
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
                    Message()
                      ..clientMsgID = msg.clientMsgID
                      ..pictureElem = PictureElem(
                        sourcePath: cachePath,
                        sourcePicture: PictureInfo(url: url),
                      ),
                    replace: true,
                  );
                } else {
                  OpenFile.open(cachePath);
                }
              },
            ))?.whenComplete(() => cancelToken.cancel());
      }
    }

    // if (msg.contentType == MessageType.picture) {
    // } else if (msg.contentType == MessageType.video) {
    // } else if (msg.contentType == MessageType.file) {}
  }

  static Widget previewPic({required String id, String? url, File? file}) =>
      ChatPicturePreview(
        tag: '${id}_${DateTime.now().microsecond}',
        url: url,
        file: file,
        onDownload: (url) async {
          IMWidget.showToast("开始下载");
          var response = await dio.get(
            url,
            options: Options(
              responseType: ResponseType.bytes,
              receiveTimeout: 60 * 1000,
            ),
          );
          final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data),
            quality: 90,
            name: '${DateTime.now().millisecond}',
          );
          print(result);
          IMWidget.showToast("图片已下载至${result['filePath']}");
          return true;
        },
      );

  static Widget _previewVideo({String? path, String? url}) =>
      ChatVideoPlayerView(
        path: path,
        url: url,
        onDownload: (url) async {
          print(url);
          IMWidget.showToast("开始下载");
          var appDocDir = await getTemporaryDirectory();
          var name = url.substring(url.lastIndexOf('/'));
          String savePath = appDocDir.path + name;
          print(savePath);
          await dio.download(
            url,
            savePath,
            options: Options(receiveTimeout: 60 * 1000),
          );
          final result = await ImageGallerySaver.saveFile(savePath);
          print(result);
          IMWidget.showToast("视频已保存至${result['filePath']}");
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
            content =
                '@${StrRes.you}${text.replaceAll('@${OpenIM.iMManager.uid}', '')}';
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
          content = '"${message.senderNickName}"${StrRes.revoke}';
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
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(mobile);
  }

  // md5 加密
  static String generateMD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  static bool isNoEmpty(String? value) {
    return null != value && value.trim().isNotEmpty;
  }

  static List<Message> calChatTimeInterval(List<Message> list) {
    var nanoseconds = list.first.sendTime!;
    list.first.ext = true;
    var lastShowTimeStamp = nanoseconds ~/ (1000 * 1000);
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
}

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
