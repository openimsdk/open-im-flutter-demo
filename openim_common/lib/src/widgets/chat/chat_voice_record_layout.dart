import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:openim_common/openim_common.dart';
import 'package:rxdart/rxdart.dart';

typedef SpeakViewChildBuilder = Widget Function(ChatVoiceRecordBar recordBar);

class ChatVoiceRecordLayout extends StatefulWidget {
  const ChatVoiceRecordLayout({
    Key? key,
    required this.builder,
    this.locale,
    this.onCompleted,
    this.speakTextStyle,
    this.speakBarColor,
    this.maxRecordSec = 60,
  }) : super(key: key);

  final SpeakViewChildBuilder builder;
  final Locale? locale;
  final Function(int sec, String path)? onCompleted;
  final Color? speakBarColor;
  final TextStyle? speakTextStyle;

  final int maxRecordSec;

  @override
  State<ChatVoiceRecordLayout> createState() => _ChatVoiceRecordLayoutState();
}

class _ChatVoiceRecordLayoutState extends State<ChatVoiceRecordLayout> {
  final _interruptSub = PublishSubject<bool>();
  bool _showVoiceRecordView = false;
  RecordBarStatus _status = RecordBarStatus.holdTalk;
  bool _isCancelSend = false;

  void _completed(int sec, String path) {
    if (_isCancelSend) {
      File(path).delete();
      _status = RecordBarStatus.holdTalk;
      _isCancelSend = false;
    } else {
      if (sec == 0) {
        File(path).delete();
        IMViews.showToast(StrRes.talkTooShort);
      } else {
        widget.onCompleted?.call(sec, path);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _interruptSub.close();
    super.dispose();
  }

  ChatVoiceRecordBar get _createSpeakBar => ChatVoiceRecordBar(
        speakBarColor: widget.speakBarColor,
        speakTextStyle: widget.speakTextStyle,
        interruptListener: _interruptSub.stream,
        onChangedBarStatus: (status) {
          if (status != _status) {
            setState(() {
              _isCancelSend = status == RecordBarStatus.liftFingerToCancelSend;
              _status = status;
            });
          }
        },
        onLongPressMoveUpdate: (details) {},
        onLongPressEnd: (details) async {
          setState(() {
            _showVoiceRecordView = false;
          });
        },
        onLongPressStart: (details) {
          setState(() {
            _showVoiceRecordView = true;
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(_createSpeakBar),
        Visibility(
          visible: _showVoiceRecordView,
          child: ChatRecordVoiceView(
            onCompleted: _completed,
            onInterrupt: () {
              setState(() {
                _interruptSub.add(true);
                _showVoiceRecordView = false;
              });
            },
            builder: (_, sec) => Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: 138.w,
                  height: 124.h,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _isCancelSend ? Styles.c_FF381F_opacity70 : Styles.c_0C1C33_opacity60,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Column(
                    children: [
                      IMUtils.seconds2HMS(sec).toText..style = Styles.ts_FFFFFF_12sp,
                      Expanded(child: _lottieAnimWidget),
                      (_isCancelSend ? StrRes.liftFingerToCancelSend : StrRes.releaseToSendSwipeUpToCancel).toText
                        ..style = Styles.ts_FFFFFF_12sp,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget get _lottieAnimWidget => Lottie.asset(
        'assets/anim/voice_record.json',
        fit: BoxFit.contain,
        package: 'openim_common',
      );
}
