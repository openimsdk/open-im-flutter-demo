import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

enum InputBoxType {
  phone,
  account,
  password,
  verificationCode,
  invitationCode,
}

class InputBox extends StatefulWidget {
  const InputBox.phone({
    super.key,
    required this.label,
    required this.code,
    this.onAreaCode,
    this.controller,
    this.focusNode,
    this.labelStyle,
    this.textStyle,
    this.codeStyle,
    this.hintStyle,
    this.formatHintStyle,
    this.hintText,
    this.formatHintText,
    this.margin,
    this.inputFormatters,
    this.keyBoardType,
  })  : obscureText = false,
        type = InputBoxType.phone,
        arrowColor = null,
        clearBtnColor = null,
        onSendVerificationCode = null;

  InputBox.account({
    super.key,
    required this.label,
    required this.code,
    this.onAreaCode,
    this.controller,
    this.focusNode,
    this.labelStyle,
    this.textStyle,
    this.codeStyle,
    this.hintStyle,
    this.formatHintStyle,
    this.hintText,
    this.formatHintText,
    this.margin,
    this.inputFormatters,
    this.keyBoardType,
  })  : obscureText = false,
        type = InputBoxType.account,
        arrowColor = null,
        clearBtnColor = null,
        onSendVerificationCode = null;

  const InputBox.password({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.labelStyle,
    this.textStyle,
    this.hintStyle,
    this.formatHintStyle,
    this.hintText,
    this.formatHintText,
    this.margin,
    this.inputFormatters,
    this.keyBoardType,
  })  : obscureText = true,
        type = InputBoxType.password,
        codeStyle = null,
        code = '',
        arrowColor = null,
        clearBtnColor = null,
        onSendVerificationCode = null,
        onAreaCode = null;

  const InputBox.verificationCode({
    super.key,
    required this.label,
    this.onSendVerificationCode,
    this.controller,
    this.focusNode,
    this.labelStyle,
    this.textStyle,
    this.hintStyle,
    this.formatHintStyle,
    this.hintText,
    this.formatHintText,
    this.margin,
    this.inputFormatters,
    this.keyBoardType,
  })  : obscureText = false,
        type = InputBoxType.verificationCode,
        code = '',
        codeStyle = null,
        onAreaCode = null,
        arrowColor = null,
        clearBtnColor = null;

  const InputBox.invitationCode({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.labelStyle,
    this.textStyle,
    this.formatHintStyle,
    this.hintStyle,
    this.hintText,
    this.formatHintText,
    this.margin,
    this.inputFormatters,
    this.keyBoardType,
  })  : obscureText = false,
        type = InputBoxType.invitationCode,
        code = '',
        codeStyle = null,
        onAreaCode = null,
        onSendVerificationCode = null,
        arrowColor = null,
        clearBtnColor = null;

  const InputBox({
    Key? key,
    required this.label,
    this.controller,
    this.focusNode,
    this.labelStyle,
    this.textStyle,
    this.hintStyle,
    this.codeStyle,
    this.formatHintStyle,
    this.code = '+86',
    this.hintText,
    this.formatHintText,
    this.arrowColor,
    this.clearBtnColor,
    this.obscureText = false,
    this.type = InputBoxType.account,
    this.onAreaCode,
    this.onSendVerificationCode,
    this.margin,
    this.inputFormatters,
    this.keyBoardType,
  }) : super(key: key);
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? codeStyle;
  final TextStyle? formatHintStyle;
  final String code;
  final String label;
  final String? hintText;
  final String? formatHintText;
  final Color? arrowColor;
  final Color? clearBtnColor;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputBoxType type;
  final Function()? onAreaCode;
  final Future<bool> Function()? onSendVerificationCode;
  final EdgeInsetsGeometry? margin;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyBoardType;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  late bool _obscureText;
  bool _showClearBtn = false;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    widget.controller?.addListener(_onChanged);
    super.initState();
  }

  void _onChanged() {
    setState(() {
      _showClearBtn = widget.controller!.text.isNotEmpty;
    });
  }

  void _toggleEye() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: widget.labelStyle ?? Styles.ts_8E9AB0_12sp,
          ),
          6.verticalSpace,
          Container(
            height: 42.h,
            padding: EdgeInsets.only(left: 12.w, right: 8.w),
            decoration: BoxDecoration(
              border: Border.all(color: Styles.c_E8EAEF, width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.type == InputBoxType.phone || widget.onAreaCode != null) _areaCodeView,
                _textField,
                _clearBtn,
                _eyeBtn,
                if (widget.type == InputBoxType.verificationCode)
                  VerifyCodedButton(
                    onTapCallback: widget.onSendVerificationCode,
                  ),
              ],
            ),
          ),
          if (null != widget.formatHintText)
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: widget.formatHintText!.toText..style = (widget.formatHintStyle ?? Styles.ts_8E9AB0_12sp),
            ),
        ],
      ),
    );
  }

  Widget get _textField => Expanded(
        child: TextField(
          controller: widget.controller,
          keyboardType: _textInputType,
          textInputAction: TextInputAction.next,
          style: widget.textStyle ?? Styles.ts_0C1C33_17sp,
          autofocus: false,
          obscureText: _obscureText,
          focusNode: widget.focusNode,
          inputFormatters: [
            if (widget.type == InputBoxType.phone || widget.type == InputBoxType.verificationCode)
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            if (null != widget.inputFormatters) ...widget.inputFormatters!,
          ],
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ?? Styles.ts_8E9AB0_17sp,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
        ),
      );

  Widget get _areaCodeView => GestureDetector(
        onTap: widget.onAreaCode,
        behavior: HitTestBehavior.translucent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.code,
              style: widget.codeStyle ?? Styles.ts_0C1C33_17sp,
            ),
            8.horizontalSpace,
            ImageRes.downArrow.toImage
              ..width = 8.49.w
              ..height = 8.49.h,
            Container(
              width: 1.w,
              height: 26.h,
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Styles.c_E8EAEF,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      );

  Widget get _clearBtn => Visibility(
        visible: _showClearBtn,
        child: GestureDetector(
          onTap: () {
            widget.controller?.clear();
          },
          behavior: HitTestBehavior.translucent,
          child: ImageRes.clearText.toImage
            ..width = 24.w
            ..height = 24.h,
        ),
      );

  Widget get _eyeBtn => Visibility(
        visible: widget.type == InputBoxType.password,
        child: GestureDetector(
          onTap: _toggleEye,
          behavior: HitTestBehavior.translucent,
          child: (_obscureText ? ImageRes.eyeClose.toImage : ImageRes.eyeOpen.toImage)
            ..width = 24.w
            ..height = 24.h,
        ),
      );

  TextInputType? get _textInputType {
    if (widget.keyBoardType != null) {
      return widget.keyBoardType;
    }
    TextInputType? keyboardType;
    switch (widget.type) {
      case InputBoxType.phone:
        keyboardType = TextInputType.phone;
        break;
      case InputBoxType.account:
        keyboardType = TextInputType.text;
        break;
      case InputBoxType.password:
        keyboardType = TextInputType.text;
        break;
      case InputBoxType.verificationCode:
        keyboardType = TextInputType.number;
        break;
      case InputBoxType.invitationCode:
        keyboardType = TextInputType.text;
        break;
    }
    return keyboardType;
  }
}

class VerifyCodedButton extends StatefulWidget {
  final int seconds;

  final Future<bool> Function()? onTapCallback;

  const VerifyCodedButton({
    Key? key,
    this.seconds = 60,
    required this.onTapCallback,
  }) : super(key: key);

  @override
  State<VerifyCodedButton> createState() => _VerifyCodedButtonState();
}

class _VerifyCodedButtonState extends State<VerifyCodedButton> {
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
    _seconds = widget.seconds;
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
    if (_seconds != widget.seconds) {
      _seconds = widget.seconds;
    }
    _cancel();
    setState(() {});
  }

  void _restart() {
    _reset();
    _start();
  }

  bool get _isEnabled => _seconds == 0 || _firstTime;

  @override
  Widget build(BuildContext context) => (_isEnabled ? StrRes.sendVerificationCode : '${_seconds}S').toText
    ..style = Styles.ts_0089FF_17sp
    ..onTap = () {
      if (_isEnabled) {
        widget.onTapCallback?.call().then((start) {
          if (start) _restart();
        });
      }
    };
}
