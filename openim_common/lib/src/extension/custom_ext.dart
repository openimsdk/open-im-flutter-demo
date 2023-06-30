import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

extension SubjectExt<T> on Subject<T> {
  T addSafely(T data) {
    if (!isClosed) sink.add(data);
    // if (!isClosed) add(data);
    return data;
  }
}

/// 解决当输入框内容全为字母且长度超过63不能继续输入的bug
///
extension TextEdCtrlExt on TextEditingController {
  void fixed63Length() {
    addListener(() {
      if (text.length == 63 && Platform.isAndroid) {
        text += " ";
        selection = TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: text.length - 1,
          ),
        );
      }
    });
  }
}

/// 将文字转换成Image
extension StrExt on String {
  ImageView get toImage {
    return ImageView(name: this);
  }

  TextView get toText {
    return TextView(data: this);
  }

  LottieView get toLottie {
    return LottieView(name: this);
  }
}

// ignore: must_be_immutable
class LottieView extends StatelessWidget {
  LottieView({
    Key? key,
    required this.name,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);
  final String name;
  double? width;
  double? height;
  BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      name,
      height: height,
      width: width,
      package: 'openim_common',
      fit: fit,
    );
  }
}

// ignore: must_be_immutable
class TextView extends StatelessWidget {
  TextView({
    Key? key,
    required this.data,
    this.style,
    this.textAlign,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.onTap,
  }) : super(key: key);
  final String data;
  TextStyle? style;
  TextAlign? textAlign;
  TextOverflow? overflow;
  double? textScaleFactor;
  int? maxLines;
  Function()? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Text(
          data,
          style: style,
          textAlign: textAlign,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
        ),
      );
}

// ignore: must_be_immutable
class ImageView extends StatelessWidget {
  ImageView({
    Key? key,
    required this.name,
    this.width,
    this.height,
    this.color,
    this.opacity = 1,
    this.fit,
    this.onTap,
    this.onDoubleTap,
  }) : super(key: key);
  final String name;
  double? width;
  double? height;
  Color? color;
  double opacity;
  BoxFit? fit;
  Function()? onTap;
  Function()? onDoubleTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        child: Opacity(
          opacity: opacity,
          child: Image.asset(
            name,
            package: 'openim_common',
            width: width,
            height: height,
            color: color,
            fit: fit,
          ),
        ),
      );
}
