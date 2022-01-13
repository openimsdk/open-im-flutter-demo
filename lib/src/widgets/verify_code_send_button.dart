import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';

class VerifyCodeSendButton extends StatefulWidget {
  /// 倒计时的秒数，默认60秒。
  final int sec;

  /// 用户点击时的回调函数。
  final Future<bool> Function() onTapCallback;

  /// 自动开始计时
  final bool auto;

  const VerifyCodeSendButton({
    Key? key,
    this.sec: 60,
    this.auto = true,
    required this.onTapCallback,
  }) : super(key: key);

  @override
  _VerifyCodeSendButtonState createState() => _VerifyCodeSendButtonState();
}

class _VerifyCodeSendButtonState extends State<VerifyCodeSendButton> {
  Timer? _timer;
  late int _seconds;
  bool _firstTime = true;

  @override
  void initState() {
    super.initState();
    _seconds = widget.sec;
    if (widget.auto)
      _start();
    else
      _seconds = 0;
  }

  void _start() {
    _firstTime = false;
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
  Widget build(BuildContext context) {
    return _buildButton();
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  bool get _isEnabled => _seconds == 0;

  Widget _buildButton() {
    return RichText(
      text: _firstTime && !widget.auto
          ? TextSpan(
              text: StrRes.sendVerifyCode,
              style: PageStyle.ts_1D6BED_12sp,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  widget.onTapCallback().then((start) {
                    if (start) _restart();
                  });
                },
            )
          : TextSpan(
              text: '$_seconds s',
              style: PageStyle.ts_1D6BED_12sp,
              children: [
                TextSpan(
                  text: StrRes.after,
                  style: PageStyle.ts_000000_12sp,
                ),
                WidgetSpan(child: SizedBox(width: 4.w)),
                TextSpan(
                  text: StrRes.resendVerifyCode,
                  style: _isEnabled
                      ? PageStyle.ts_1D6BED_12sp
                      : PageStyle.ts_000000_12sp,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (_isEnabled) {
                        widget.onTapCallback().then((start) {
                          if (start) _restart();
                        });
                      }
                    },
                ),
              ],
            ),
    );
  }
}
