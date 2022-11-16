import 'dart:async';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import '../res/strings.dart';
import '../res/styles.dart';

final timerCache = <int, int>{};

class VerifyCodeSendButton2 extends StatefulWidget {
  final Future<bool> Function() onTapCallback;
  final int sec;
  final int uniqueID;

  const VerifyCodeSendButton2({
    Key? key,
    this.uniqueID = 0,
    this.sec = 60,
    required this.onTapCallback,
  }) : super(key: key);

  @override
  _VerifyCodeSendButtonState createState() => _VerifyCodeSendButtonState();
}

class _VerifyCodeSendButtonState extends State<VerifyCodeSendButton2> {
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    _recoverTimer();
    super.initState();
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  bool get _isEnabled => _seconds == 0;

  void _start() {
    _cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds == 0) {
        _cancel();
        setState(() {});
        return;
      }
      _seconds--;
      setState(() {});
    });
  }

  void _cancel() {
    if (null != _timer) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _recordTimer() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final end = now + widget.sec * 1000;
    timerCache.addAll({widget.uniqueID: end});
  }

  void _recoverTimer() {
    int? mic = timerCache[widget.uniqueID];
    if (mic != null) {
      final old = DateTime.fromMillisecondsSinceEpoch(mic);
      final now = DateTime.now();
      final lave = old.differenceInSeconds(now);
      if (lave > 0) {
        _seconds = lave;
        _start();
      }
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          if (_isEnabled) {
            final success = await widget.onTapCallback.call();
            if (success) {
              _seconds = widget.sec;
              _recordTimer();
              _start();
            }
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Text(
          _isEnabled ? StrRes.getVerificationCode : '$_seconds s',
          style: PageStyle.ts_0089FF_16sp,
        ),
      );
}
