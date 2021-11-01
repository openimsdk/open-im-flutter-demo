import 'package:flutter/material.dart';

/// 触摸关闭键盘
class TouchCloseSoftKeyboard extends StatelessWidget {
  final Widget child;
  final Function? onTouch;

  const TouchCloseSoftKeyboard({
    Key? key,
    required this.child,
    this.onTouch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
        onTouch?.call();
      },
      child: child,
    );
  }
}
