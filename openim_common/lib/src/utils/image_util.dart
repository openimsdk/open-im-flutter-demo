import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ImageUtil {
  ImageUtil._();

  static const _package = "openim_common";

  static Widget assetImage(
    String res, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) =>
      Image.asset(
        res,
        width: width,
        height: height,
        fit: fit,
        color: color,
        package: _package,
      );

  static Widget networkImage({
    required String url,
    double? width,
    double? height,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = false,
    bool lowMemory = false,
    Widget? errorWidget,
    BorderRadius? borderRadius,
  }) =>
      ExtendedImage.network(
        url,
        width: width,
        height: height,
        fit: fit,
        borderRadius: borderRadius,
        cacheWidth: _calculateCacheWidth(width, cacheWidth, lowMemory),
        cacheHeight: _calculateCacheHeight(height, cacheHeight, lowMemory),
        cacheRawData: true,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        handleLoadingProgress: true,
        clearMemoryCacheIfFailed: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              {
                final ImageChunkEvent? loadingProgress = state.loadingProgress;
                final double? progress = loadingProgress?.expectedTotalBytes != null
                    ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null;

                return SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: loadProgress
                      ? Center(
                          child: SizedBox(
                            width: 15.0,
                            height: 15.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              value: progress,
                            ),
                          ),
                        )
                      : null,
                );
              }
            case LoadState.completed:
              return null;
            case LoadState.failed:
              state.imageProvider.evict();
              return errorWidget ??
                  (ImageRes.pictureError.toImage
                    ..width = width
                    ..height = height);
          }
        },
      );

  static Widget fileImage({
    required File file,
    double? width,
    double? height,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = false,
    bool lowMemory = false,
    Widget? errorWidget,
    BorderRadius? borderRadius,
  }) =>
      ExtendedImage.file(
        file,
        width: width,
        height: height,
        fit: fit,
        borderRadius: borderRadius,
        cacheWidth: _calculateCacheWidth(width, cacheWidth, lowMemory),
        cacheHeight: _calculateCacheHeight(height, cacheHeight, lowMemory),
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        clearMemoryCacheIfFailed: true,
        cacheRawData: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              {
                final ImageChunkEvent? loadingProgress = state.loadingProgress;
                final double? progress = loadingProgress?.expectedTotalBytes != null
                    ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null;

                return SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: loadProgress
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            value: progress,
                          ),
                        )
                      : null,
                );
              }
            case LoadState.completed:
              return null;
            case LoadState.failed:
              state.imageProvider.evict();
              return errorWidget ?? ImageRes.pictureError.toImage;
          }
        },
      );

  static int? _calculateCacheWidth(
    double? width,
    int? cacheWidth,
    bool lowMemory,
  ) {
    if (!lowMemory) return null;
    if (null != cacheWidth) return cacheWidth;
    final maxW = .6.sw;
    return (width == null ? maxW : (width < maxW ? width : maxW)).toInt();
  }

  static int? _calculateCacheHeight(
    double? height,
    int? cacheHeight,
    bool lowMemory,
  ) {
    if (!lowMemory) return null;
    if (null != cacheHeight) return cacheHeight;
    final maxH = .6.sh;
    return (height == null ? maxH : (height < maxH ? height : maxH)).toInt();
  }
}
