import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';

class TimingView extends StatefulWidget {
  const TimingView({
    Key? key,
    required this.sec,
    this.onFinished,
  }) : super(key: key);
  final int sec;
  final Function()? onFinished;

  @override
  State<TimingView> createState() => _TimingViewState();
}

class _TimingViewState extends State<TimingView> {
  Timer? _timer;
  late int _sec;

  @override
  void initState() {
    _sec = widget.sec;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      --_sec;
      if (_sec <= 0) {
        _timer?.cancel();
        _timer = null;
        widget.onFinished?.call();
      }
      setState(() {
        if (_sec <= 0) {
          _sec = 0;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      '$_sec s'.toText..style = Styles.ts_0089FF_12sp;
}
