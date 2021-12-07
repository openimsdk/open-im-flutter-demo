import 'dart:async';

import 'package:flutter/material.dart';

typedef DebounceChildBuilder = Widget Function(
    BuildContext context, Function()? onTap);

class DebounceButton extends StatefulWidget {
  const DebounceButton({
    Key? key,
    required this.builder,
    required this.onTap,
    this.duration,
  }) : super(key: key);
  final DebounceChildBuilder builder;
  final Future Function() onTap;
  final Duration? duration;

  @override
  _DebounceButtonState createState() => _DebounceButtonState();
}

class _DebounceButtonState extends State<DebounceButton> {
  Timer? _timer;
  var _enabled = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _click() {
    if (_enabled) {
      _enabled = false;
      widget.onTap().whenComplete(() {
        // 接口回调完成后按钮可用
        if (!_isEnabledTimer) _enabled = true;
      });
      if (_isEnabledTimer) {
        _timer?.cancel();
        _timer = Timer(widget.duration!, () {
          _timer?.cancel();
          _enabled = true;
        });
      }
    }
  }

  /// 以计时器为主计算按钮可用
  bool get _isEnabledTimer => null != widget.duration;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _click);
  }
}
