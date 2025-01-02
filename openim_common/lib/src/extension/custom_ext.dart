import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

extension SubjectExt<T> on Subject<T> {
  T addSafely(T data) {
    if (!isClosed) sink.add(data);

    return data;
  }
}

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

  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }

  String get thumbnailAbsoluteString {
    final host = split('?').first;
    final isGif = host.split('.').last.toLowerCase() == 'gif';
    if (isGif) {
      return host;
    }
    return '$host?height=640&width=360&type=image';
  }

  String adjustThumbnailAbsoluteString(int size) {
    final host = split('?').first;
    final isGif = host.split('.').last.toLowerCase() == 'gif';
    if (isGif) {
      return host;
    }
    return '$host?height=$size&width=$size&type=image';
  }
}

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

class TextView extends StatelessWidget {
  TextView(
      {Key? key,
      required this.data,
      this.style,
      this.textAlign,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.onTap,
      this.wordEllipsis = true})
      : super(key: key);
  final String data;
  TextStyle? style;
  TextAlign? textAlign;
  TextOverflow? overflow;
  double? textScaleFactor;
  int? maxLines;
  Function()? onTap;
  bool wordEllipsis;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Text(
          wordEllipsis ? data : data.replaceAll('', '\u200B'), //解决Flutter按单词省略
          style: style,
          textAlign: textAlign,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
        ),
      );
}

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

extension IntExt on int {
  int ensureTenDigits() {
    String numberStr = toString();

    if (numberStr.length == 10) {
      return this;
    } else if (numberStr.length > 10) {
      return int.parse(numberStr.substring(0, 10));
    } else {
      return int.parse(numberStr.padLeft(10, '0'));
    }
  }
}

extension StringExt on String {
  String splitStringEveryNChars({int n = 3, String separator = ' '}) {
    RegExp regExp = RegExp('.{1,$n}');
    Iterable<Match> matches = regExp.allMatches(this);
    List<String> parts = matches.map((match) => match.group(0)!).toList();

    return parts.join(separator);
  }
}

extension DateTimeExt on DateTime {
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;
}
