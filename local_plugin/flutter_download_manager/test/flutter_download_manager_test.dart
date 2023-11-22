import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var url2 = "http://download.dcloud.net.cn/HBuilder.9.0.2.macosx_64.dmg";

  var url3 =
      'https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action@1.0/docs/imgs/book.jpg';
  var url = "http://app01.78x56.com/Xii_2021-03-13%2010%EF%BC%9A41.ipa";
  var url4 =
      "https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/sample-mp4-file.mp4";
  var url5 =
      "https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/Sample-Video-File-For-Testing.mp4";
  var url6 = "https://static.gtaf.org/v1/quran/static/translation-db/10";

  test('future download', () async {
    var dl = DownloadManager();

    DownloadTask? task = await dl.addDownload(url4, "./test.mp4");

    task?.status.addListener(() {
      print(task.status.value);
    });

    task?.progress.addListener(() {
      print(task.progress.value);
    });

    await dl.whenDownloadComplete(url4);
  });

  test('parallel download', () async {
    var dl = DownloadManager();

    DownloadTask? task = await dl.addDownload(url2, "./test2.ipa");
    DownloadTask? task2 = await  dl.addDownload(url3, "./test3.ipa");
    DownloadTask? task3 = await dl.addDownload(url, "./test.ipa");

    task?.status.addListener(() {
      print(task.status.value);
    });

    task2?.status.addListener(() {
      print(task2.status.value);
    });

    task3?.status.addListener(() {
      print(task3.status.value);
    });

    await dl.whenBatchDownloadsComplete([url, url2, url3], timeout: Duration(seconds: 20));
  });

  test('cancel download', () async {
    var dl = DownloadManager();

    DownloadTask? task = await dl.addDownload(url5, "./test2.mp4");

    Future.delayed(Duration(milliseconds: 500), () {
      dl.cancelDownload(url5);
    });

    task?.status.addListener(() {
      print(task.status.value);
    });

    await Future.delayed(Duration(seconds: 10), null);

    assert(task?.status.value == DownloadStatus.canceled);
  });

  test('pause and resume download', () async {
    var dl = DownloadManager();

    DownloadTask? task = await dl.addDownload(url5, "./test2.mp4");

    Future.delayed(Duration(milliseconds: 500), () {
      dl.pauseDownload(url5);
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      dl.resumeDownload(url5);
    });

    task?.status.addListener(() {
      print(task.status.value);
    });

    await Future.delayed(Duration(seconds: 20), null);

    assert(task?.status.value == DownloadStatus.completed);
  });

  test('handle empty url', () async {
    var dl = DownloadManager();

    var url = "";
    DownloadTask? task = await dl.addDownload(url, "");

    task?.status.addListener(() {
      print(task.status.value);
    });

    var error = dl.whenDownloadComplete(url);
  });

  test('handle empty path', () async {
    var dl = DownloadManager();

    DownloadTask? task = await dl.addDownload(url3, "");

    task?.status.addListener(() {
      print(task.status.value);
    });

    await dl.whenDownloadComplete(url3);
  });

  test('handle url with empty extension', () async {
    var dl = DownloadManager();

    DownloadTask? task = await dl.addDownload(url6, "");

    task?.status.addListener(() {
      print(task.status.value);
    });

    await dl.whenDownloadComplete(url6);
  });

  test('download in batch', () async {
    var dl = DownloadManager();

    var urls = <String>[];
    urls.add(url2);
    urls.add(url3);
    urls.add(url);

    await dl.addDownload(url2, "./test2.ipa");
    await dl.addDownload(url3, "./test3.ipa");
    await dl.addDownload(url, "./test.ipa");

    var downloadProgress = dl.getBatchDownloadProgress(urls);

    downloadProgress.addListener(() {
      print(downloadProgress.value);
    });

    await dl.whenBatchDownloadsComplete(urls);
  });

  test('download in batch by setting the savedDirectory only', () async {
    var dl = DownloadManager();

    var urls = <String>[];
    urls.add(url2);
    urls.add(url3);
    urls.add(url);

    dl.addBatchDownloads(urls, "./");

    var downloadProgress = dl.getBatchDownloadProgress(urls);

    downloadProgress.addListener(() {
      print(downloadProgress.value);
    });

    await dl.whenBatchDownloadsComplete(urls);
  });

  test('cancel a batched download', () async {
    var dl = DownloadManager();

    var urls = <String>[];
    urls.add(url6);
    urls.add(url5);
    urls.add(url);
    dl.addBatchDownloads(urls, ".");

    var downloads = dl.getBatchDownloads(urls);

    downloads.forEach((task) {
      task?.status.addListener(() {
        print(task.request.url + ", " + task.status.value.toString());
      });
    });

    dl.cancelBatchDownloads(urls);

    await dl.whenBatchDownloadsComplete(urls);
  });

  test('cancel a single item in a batched download', () async {
    var dl = DownloadManager();

    var urls = <String>[];
    urls.add(url4);
    urls.add(url3);
    urls.add(url);
    dl.addBatchDownloads(urls, "");

    var downloads = dl.getBatchDownloads(urls);

    downloads.forEach((task) {
      task?.status.addListener(() {
        print(task.status.value);
      });
    });

    dl.cancelDownload(url3);

    await dl.whenBatchDownloadsComplete(urls);
  });
}
