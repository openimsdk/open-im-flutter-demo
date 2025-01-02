import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class VerifyCodeSendButton extends StatefulWidget {
  final int sec;

  final Future<bool> Function() onTapCallback;

  final bool auto;

  const VerifyCodeSendButton({
    Key? key,
    this.sec = 60,
    this.auto = true,
    required this.onTapCallback,
  }) : super(key: key);

  @override
  State<VerifyCodeSendButton> createState() => _VerifyCodeSendButtonState();
}

class _VerifyCodeSendButtonState extends State<VerifyCodeSendButton> {
  Timer? _timer;
  late int _seconds;
  bool _firstTime = true;

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _seconds = widget.sec;
    if (widget.auto) {
      _start();
    } else {
      _seconds = 0;
    }
  }

  void _start() {
    _firstTime = false;
    _timer = Timer.periodic(1.seconds, (timer) {
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

  void _reset() {
    if (_seconds != widget.sec) {
      _seconds = widget.sec;
    }
    _cancel();
    setState(() {});
  }

  void _restart() {
    _reset();
    _start();
  }

  @override
  Widget build(BuildContext context) => _firstTime && !widget.auto
      ? (StrRes.sendVerificationCode.toText
        ..style = Styles.ts_0089FF_12sp
        ..onTap = () {
          widget.onTapCallback().then((start) {
            if (start) _restart();
          });
        })
      : (_isEnabled
          ? (StrRes.resendVerificationCode.toText
            ..style = Styles.ts_0089FF_12sp
            ..onTap = () {
              widget.onTapCallback().then((start) {
                if (start) _restart();
              });
            })
          : (sprintf(StrRes.verificationCodeTimingReminder, [_seconds]).toText..style = Styles.ts_8E9AB0_12sp));

  bool get _isEnabled => _seconds == 0;
}
