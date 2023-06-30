import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

enum ProgressType {
  file, // 文件
  video, // 视频
  picture, // 图片
}

class ChatProgressView extends StatefulWidget {
  const ChatProgressView({
    Key? key,
    required this.isISend,
    required this.width,
    required this.height,
    required this.id,
    this.stream,
    this.type = ProgressType.picture,
  }) : super(key: key);
  final bool isISend;
  final double width;
  final double height;
  final String id;
  final Stream<MsgStreamEv<int>>? stream;
  final ProgressType type;

  @override
  State<ChatProgressView> createState() => _ChatProgressViewState();
}

class _ChatProgressViewState extends State<ChatProgressView> {
  int _progress = 100;
  StreamSubscription? _progressSubs;

  @override
  void initState() {
    _progressSubs = widget.stream?.listen((event) {
      if (!mounted) return;
      if (widget.id == event.id) {
        setState(() {
          _progress = event.value;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _progressSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Visibility(
        visible: _progress != 100,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: widget.type == ProgressType.file
              ? null
              : BoxDecoration(
                  color: Styles.c_000000_opacity70,
                  borderRadius: borderRadius(widget.isISend),
                ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.type == ProgressType.file)
                ImageRes.fileMask.toImage
                  ..width = 38.w
                  ..height = 44.h,
              SizedBox(
                width: widget.type == ProgressType.file ? 22.w : 40.w,
                height: widget.type == ProgressType.file ? 22.w : 40.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Styles.c_FFFFFF,
                      color: Styles.c_0089FF,
                      strokeWidth: 1.5,
                      value: _progress / 100,
                    ),
                    if (widget.type == ProgressType.file && !widget.isISend)
                      ImageRes.progressGoing.toImage
                        ..width = 11.w
                        ..height = 11.h,
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
