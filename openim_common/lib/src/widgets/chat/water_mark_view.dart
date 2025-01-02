import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class WaterMarkBgView extends StatelessWidget {
  const WaterMarkBgView({
    Key? key,
    this.path,
    this.text = '',
    this.newMessageCount = 0,
    this.textStyle,
    this.backgroundColor,
    required this.child,
    this.topView,
    this.bottomView,
    this.floatView,
    this.onSeeNewMessage,
  }) : super(key: key);
  final String? path;
  final String text;
  final int newMessageCount;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Widget child;
  final Widget? topView;
  final Widget? bottomView;
  final Widget? floatView;
  final Function()? onSeeNewMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          if (path?.isNotEmpty == true) Image.file(File(path!), fit: BoxFit.cover),
          if (text.isNotEmpty) _buildWaterMarkTextView(context: context),
          Column(
            children: [
              if (null != topView) topView!,
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    child,
                    if (newMessageCount > 0)
                      Positioned(
                        bottom: 10.h,
                        child: NewMessageIndicator(
                          newMessageCount: newMessageCount,
                          onTap: onSeeNewMessage,
                        ),
                      ),
                  ],
                ),
              ),
              if (null != bottomView) bottomView!
            ],
          ),
          if (null != floatView) floatView!,
        ],
      ),
    );
  }

  Widget _buildWaterMarkTextView({required BuildContext context}) {
    var style = textStyle ??
        TextStyle(
          color: Color(0x707070).withOpacity(0.25),
          fontSize: 16.sp,
        );
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;
    var size = _textSize(text, style);
    double itemW = size.width;
    double itemH = size.height;

    int rowCount = (screenW / itemW).round() + 1;
    int columnCount = (screenH / itemH).round() + 1;

    double maxW = screenW * 1.5;
    double maxH = screenH * 1.5;

    List<Widget> children = List.filled(
      columnCount * rowCount,
      Transform.rotate(
          angle: -15 * pi / 180,
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
            maxLines: 1,
          )),
    );
    return ClipRect(
      child: OverflowBox(
          maxWidth: maxW,
          maxHeight: maxH,
          alignment: Alignment.center,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 40.w,
            runSpacing: 70.h,
            children: children,
          )),
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
