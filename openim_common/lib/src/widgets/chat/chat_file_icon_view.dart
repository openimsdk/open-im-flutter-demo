import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatFileIconView extends StatelessWidget {
  const ChatFileIconView({
    Key? key,
    required this.message,
    this.downloadProgressView,
  }) : super(key: key);
  final Message message;
  final Widget? downloadProgressView;

  @override
  Widget build(BuildContext context) {
    final fileName = message.fileElem!.fileName!;
    return Stack(
      children: [
        IMUtils.fileIcon(fileName).toImage
          ..width = 38.w
          ..height = 44.h,
        if (null != downloadProgressView) downloadProgressView!,
      ],
    );
  }
}
