import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class DownloadController extends GetxController {
  final downloadManager = DownloadManager();
  String? savedDir;
  final downloadTaskList = <String?, DownloadTask>{}.obs;

  @override
  void onInit() {
    _initDir();
    super.onInit();
  }

  _initDir() async {
    savedDir ??= await IMUtils.getDownloadFileDir();
  }

  DownloadTask? getTask(String url) {
    return downloadManager.getDownload(url);
  }

  bool isExistTask(String url) {
    return null != downloadTaskList[url];
  }

  bool isExistMessageTask(Message message) =>
      message.isFileType && null != message.fileElem?.sourceUrl && isExistTask(message.fileElem!.sourceUrl!);

  ValueNotifier<DownloadStatus> getStatus(Message message) => downloadTaskList[message.fileElem!.sourceUrl!]!.status;

  ValueNotifier<double> getProgress(Message message) => downloadTaskList[message.fileElem!.sourceUrl!]!.progress;

  void addDownload(String url, {String? path}) {
    Permissions.storage(() async {
      await _initDir();
      path ??= "$savedDir/${downloadManager.getFileNameFromUrl(url)}";
      DownloadTask? task = await downloadManager.addDownload(url, path!);
      if (null != task) downloadTaskList[url] = task;
    });
  }

  void addDownloadForMessage(Message message, {String? path}) {
    if (message.isFileType) {
      final url = message.fileElem?.sourceUrl;
      if (null != url) {
        Permissions.storage(() async {
          await _initDir();
          path ??= "$savedDir/${downloadManager.getFileNameFromUrl(url)}";
          DownloadTask? task = await downloadManager.addDownload(url, path!);
          if (null != task) downloadTaskList[url] = task;
        });
      }
    }
  }

  void clickFileMessage(String url, String path) async {
    var task = getTask(url);
    Logger.print(
        'clickFileMessage 当前状态： ${task?.status.value}  进度：${task?.progress.value} 完成：${task?.status.value.isCompleted}  $url  $path');
    if (task != null && !task.status.value.isCompleted) {
      switch (task.status.value) {
        case DownloadStatus.downloading:
          downloadManager.pauseDownload(url);
          break;
        case DownloadStatus.paused:
          downloadManager.resumeDownload(url);
          break;
        case DownloadStatus.queued:
          break;
        case DownloadStatus.completed:
          break;
        case DownloadStatus.failed:
          await downloadManager.removeDownload(url);
          addDownload(url, path: path);
          break;
        case DownloadStatus.canceled:
          addDownload(url, path: path);
          break;
      }
    } else {
      addDownload(url, path: path);
    }
  }
}
