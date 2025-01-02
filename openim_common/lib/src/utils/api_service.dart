import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:openim_common/openim_common.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class ApiService {
  static final _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  final Dio dio = Dio();

  ApiService._internal() {
    final talkerDioLogger = TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: kDebugMode,
        printRequestData: kDebugMode,
        printResponseMessage: kDebugMode,
        printResponseData: kDebugMode,
        printResponseHeaders: false,
      ),
    );

    dio.options
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30);

    dio.interceptors
      ..add(talkerDioLogger)
      ..add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.next(options); //continue
          },
          onResponse: (response, handler) {
            return handler.next(response); // continue
          },
          onError: (DioException e, handler) {
            return handler.next(e); //continue
          },
        ),
      );

    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  void setBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  void setToken(String token) {
    dio.options.headers['token'] = token;
  }

  Future get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      dio.options.headers['operationID'] = DateTime.now().millisecondsSinceEpoch.toString();

      final response = await dio.get(path, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final result = ApiResponse.fromJson(response.data as Map<String, dynamic>);

        if (result.errCode == 0) {
          return result.data;
        } else {
          return Future.error(result.errMsg);
        }
      }

      return Future.error(response.data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future post(String path, {Map<String, dynamic>? data, String? token}) async {
    try {
      final operationID = DateTime.now().millisecondsSinceEpoch.toString();
      dio.options.headers['operationID'] = operationID;

      final response = await dio.post(path, data: data);

      if (response.statusCode == 200) {
        final result = ApiResponse.fromJson(response.data as Map<String, dynamic>);

        if (result.errCode == 0) {
          return result.data;
        } else {
          final exception = ApiException(code: result.errCode, message: result.errMsg, operationID: operationID);

          return Future.error(exception);
        }
      }

      return Future.error(response.data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future download(
    String url, {
    required String cachePath,
    CancelToken? cancelToken,
    Function(int count, int total)? onProgress,
  }) {
    return dio.download(
      url,
      cachePath,
      cancelToken: cancelToken,
      onReceiveProgress: onProgress,
    );
  }

  void _handleError(DioException error) {
    Logger.print('DioError: ${error.message}', isError: true);
  }
}

class ApiResponse {
  int errCode;
  String errMsg;
  String errDlt;
  dynamic data;

  ApiResponse.fromJson(Map<String, dynamic> map)
      : errCode = map["errCode"] ?? -1,
        errMsg = map["errMsg"] ?? '',
        errDlt = map["errDlt"] ?? '',
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['errCode'] = errCode;
    data['errMsg'] = errMsg;
    data['errDlt'] = errDlt;
    data['data'] = data;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class ApiException implements Exception {
  final int code;
  final String? message;
  final String? operationID;

  ApiException({required this.code, this.message, this.operationID});
}
