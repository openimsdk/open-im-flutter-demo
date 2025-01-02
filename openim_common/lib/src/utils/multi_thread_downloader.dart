import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../openim_common.dart';

class MultiThreadDownloader {
  final Dio dio = Dio();
  final String url;
  final int threads; // Number of threads
  final String fileName;
  final int? length;

  MultiThreadDownloader({required this.url, this.threads = 4, required this.fileName, this.length});

  String? _realUrl;
  late int _fileSize; // Total file size
  final CancelToken _cancelToken = CancelToken();

  Future<String?> start() async {
    _fileSize = await _getFileSize() ?? 0;
    if (_fileSize == 0) {
      Logger.print('Unable to retrieve file size');
      return null;
    }
    Logger.print('File size: $_fileSize bytes');

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/$fileName';

    final chunkSize = (_fileSize / threads).ceil(); // Size of each chunk

    List<Future<File>> futures = [];

    for (int i = 0; i < threads; i++) {
      final start = i * chunkSize;
      final end = (i == threads - 1) ? _fileSize - 1 : (start + chunkSize - 1);

      futures.add(_downloadChunk(start, end, i, filePath));
    }

    await Future.wait(futures);

    Logger.print('All chunks downloaded, file path: $filePath');
    final path = await mergeChunks(filePath); // Merge chunks into a single file

    return path;
  }

  Future<int?> _getFileSize() async {
    try {
      _realUrl = await fetchRedirectedUrl(url: url);
      Logger.print('get file read url: url $_realUrl');

      if (length != null) {
        return length;
      }

      final response = await dio.head(
        _realUrl!,
      );

      final contentLength = response.headers.value(Headers.contentLengthHeader);
      return contentLength != null ? int.tryParse(contentLength) : null;
    } catch (e) {
      Logger.print('Failed to get file size: $e');
      return null;
    }
  }

  Future<File> _downloadChunk(int start, int end, int threadIndex, String filePath) async {
    String tempFilePath = '$filePath.part$threadIndex';

    Logger.print('Thread $threadIndex downloading range: $start-$end');

    try {
      final response = await dio.download(
        _realUrl!,
        tempFilePath,
        options: Options(
          headers: {
            'Range': 'bytes=$start-$end',
          },
        ),
        cancelToken: _cancelToken,
      );
      Logger.print('Thread $threadIndex download completed: ${response.statusCode}');
      return File(tempFilePath);
    } catch (e) {
      Logger.print('Thread $threadIndex download failed: $e');
      rethrow;
    }
  }

  Future<String> mergeChunks(String filePath) async {
    File file = File(filePath);
    IOSink fileSink = file.openWrite();

    try {
      for (int i = 0; i < threads; i++) {
        File chunkFile = File('$filePath.part$i');
        List<int> chunkBytes = await chunkFile.readAsBytes();
        fileSink.add(chunkBytes);
        await chunkFile.delete(); // Delete temporary chunk file after merging
      }
    } finally {
      await fileSink.close();
    }

    Logger.print('File merge completed: $filePath');
    return filePath;
  }

  Future<String> fetchRedirectedUrl({required String url}) async {
    final myRequest = await HttpClient().getUrl(Uri.parse(url));
    myRequest.followRedirects = false;
    final myResponse = await myRequest.close();
    return myResponse.headers.value(HttpHeaders.locationHeader).toString();
  }

  void cancel() {
    _cancelToken.cancel('Download cancelled');
    Logger.print('Download cancelled');
  }
}
