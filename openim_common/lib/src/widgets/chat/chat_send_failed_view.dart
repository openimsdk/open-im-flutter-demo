import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatSendFailedView extends StatefulWidget {
  const ChatSendFailedView({
    Key? key,
    required this.id,
    required this.isISend,
    this.isFailed = false,
    this.stream,
    this.onFailedToResend,
  }) : super(key: key);
  final String id;
  final bool isISend;
  final Stream<MsgStreamEv<bool>>? stream;
  final bool isFailed;
  final Function()? onFailedToResend;

  @override
  State<ChatSendFailedView> createState() => _ChatSendFailedViewState();
}

class _ChatSendFailedViewState extends State<ChatSendFailedView> {
  late bool _failed;
  StreamSubscription? _statusSubs;

  @override
  void initState() {
    _failed = widget.isFailed;
    _statusSubs = widget.stream?.listen((event) {
      if (!mounted) return;
      if (widget.id == event.id) {
        setState(() {
          _failed = !event.value;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _statusSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isISend && _failed,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            _failed = false;
          });
          widget.onFailedToResend?.call();
        },
        child: ImageRes.failedToResend.toImage
          ..width = 16.w
          ..height = 16.h,
      ),
    );
  }
}
