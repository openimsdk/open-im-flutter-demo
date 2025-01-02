import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openim_common/openim_common.dart';
import 'package:uuid/uuid.dart';

typedef CustomAvatarBuilder = Widget? Function();

class AvatarView extends StatelessWidget {
  const AvatarView({
    Key? key,
    this.width,
    this.height,
    this.onTap,
    this.url,
    this.file,
    this.builder,
    this.text,
    this.textStyle,
    this.onLongPress,
    this.isCircle = false,
    this.borderRadius,
    this.enabledPreview = false,
    this.lowMemory = false,
    this.nineGridUrl = const [],
    this.isGroup = false,
    this.showDefaultAvatar = true,
  }) : super(key: key);
  final double? width;
  final double? height;
  final Function()? onTap;
  final Function()? onLongPress;
  final String? url;
  final File? file;
  final CustomAvatarBuilder? builder;
  final bool isCircle;
  final BorderRadius? borderRadius;
  final bool enabledPreview;
  final String? text;
  final TextStyle? textStyle;
  final bool lowMemory;
  final List<String> nineGridUrl;
  final bool isGroup;
  final bool showDefaultAvatar;

  double get _avatarSize => min(width ?? 44.w, height ?? 44.h);

  TextStyle get _textStyle => textStyle ?? Styles.ts_FFFFFF_16sp;

  Color get _textAvatarBgColor => Styles.c_0089FF;

  String? get _showName {
    if (isGroup) return null;
    if (text != null && text!.trim().isNotEmpty) {
      return text!.substring(0, 1);
    }
    return null;
  }

  bool get isUrlValid => IMUtils.isUrlValid(url);

  @override
  Widget build(BuildContext context) {
    var tag = const Uuid().v4();
    var child = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap ??
          ((enabledPreview && isUrlValid)
              ? () => IMUtils.previewUrlPicture([MediaSource(thumbnail: url!, url: url)])
              : null),
      onLongPress: onLongPress,
      child: builder?.call() ?? (nineGridUrl.isNotEmpty ? _nineGridAvatar() : _normalAvatar()),
    );
    return Hero(
      tag: tag,
      child: isCircle
          ? ClipOval(child: child)
          : ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(6.r),
              child: child,
            ),
    );
  }

  Widget _normalAvatar() => !isUrlValid ? _textAvatar() : _networkImageAvatar();

  Widget _textAvatar() => Container(
        width: _avatarSize,
        height: _avatarSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: _textAvatarBgColor,
        ),
        child: null == _showName
            ? (showDefaultAvatar
                ? FaIcon(
                    isGroup ? FontAwesomeIcons.userGroup : FontAwesomeIcons.solidUser,
                    color: Colors.white,
                    size: _avatarSize / 2,
                  )
                : null)
            : Text(_showName!, style: _textStyle),
      );

  Widget _networkImageAvatar() => file != null
      ? ImageUtil.fileImage(file: file!)
      : ImageUtil.networkImage(
          url: url!,
          width: _avatarSize,
          height: _avatarSize,
          fit: BoxFit.cover,
          lowMemory: lowMemory,
          loadProgress: false,
          errorWidget: _textAvatar(),
        );

  Widget _nineGridAvatar() => Container(
        width: _avatarSize,
        height: _avatarSize,
        color: Colors.grey[300],
        padding: const EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: _nineGridColumn(),
      );

  Widget _nineGridColumn() {
    double width = 0.0;
    double margin = 2.0;
    int row1Length = 0;
    int row2Length = 0;
    int row3Length = 0;
    var list = <Widget>[];
    switch (nineGridUrl.length) {
      case 1:
        width = _avatarSize;
        row1Length = 1;
        break;
      case 2:
        width = _avatarSize / 2;
        row1Length = 2;
        break;
      case 3:
        width = _avatarSize / 2;
        row1Length = 1;
        row2Length = 2;
        break;
      case 4:
        width = _avatarSize / 2;
        row1Length = 2;
        row2Length = 2;
        break;
      case 5:
        width = _avatarSize / 3;
        row1Length = 2;
        row2Length = 3;
        break;
      case 6:
        width = _avatarSize / 3;
        row1Length = 3;
        row2Length = 3;
        break;
      case 7:
        width = _avatarSize / 3;
        row1Length = 1;
        row2Length = 3;
        row3Length = 3;
        break;
      case 8:
        width = _avatarSize / 3;
        row1Length = 2;
        row2Length = 3;
        row3Length = 3;
        break;
      case 9:
        width = _avatarSize / 3;
        row1Length = 3;
        row2Length = 3;
        row3Length = 3;
        break;
    }
    if (row1Length > 0) {
      list.add(_nineGridRow(
        length: row1Length,
        start: 0,
        size: width,
        margin: margin,
      ));
    }
    if (row2Length > 0) {
      list.add(_nineGridRow(
        length: row2Length,
        start: row1Length,
        size: width,
        margin: margin,
      ));
    }
    if (row3Length > 0) {
      list.add(_nineGridRow(
        length: row3Length,
        start: row1Length + row2Length,
        size: width,
        margin: margin,
      ));
    }
    return Column(
      children: list,
    );
  }

  Widget _nineGridRow({
    required int length,
    required int start,
    required double size,
    required double margin,
  }) {
    Widget nineGridImage(String? url, double size) => _normalAvatar();
    Widget nineGridLine({
      double? width,
      double? height,
    }) =>
        Container(height: height, width: width, color: Colors.white);
    var list = <Widget>[];
    for (var i = 0; i < length; i++) {
      start += i;
      list.add(nineGridImage(nineGridUrl.elementAt(start), size));
      if (i != length - 1) {
        list.add(nineGridLine(width: margin, height: size));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}

class RedDotView extends StatelessWidget {
  const RedDotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 8,
        height: 8,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Styles.c_FF381F,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0x26C61B4A),
              offset: Offset(1.15.w, 1.15.h),
              blurRadius: 57.58.r,
            ),
            BoxShadow(
              color: const Color(0x1AC61B4A),
              offset: Offset(2.3.w, 2.3.h),
              blurRadius: 11.52.r,
            ),
            BoxShadow(
              color: const Color(0x0DC61B4A),
              offset: Offset(4.61.w, 4.61.h),
              blurRadius: 17.28.r,
            ),
          ],
        ),
      );
}
