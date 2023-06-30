import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

enum BubbleType {
  send,
  receiver,
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    this.margin,
    this.constraints,
    this.alignment = Alignment.center,
    this.backgroundColor,
    this.child,
    required this.bubbleType,
  }) : super(key: key);
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final Widget? child;
  final BubbleType bubbleType;

  bool get isISend => bubbleType == BubbleType.send;

  @override
  Widget build(BuildContext context) => Container(
        constraints: constraints,
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        alignment: alignment,
        decoration: BoxDecoration(
          color:
              backgroundColor ?? (isISend ? Styles.c_CCE7FE : Styles.c_F4F5F7),
          borderRadius: borderRadius(isISend),
        ),
        child: child,
      );
}
