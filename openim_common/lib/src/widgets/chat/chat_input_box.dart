import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

import 'chat_disable_input_box.dart';

double kInputBoxMinHeight = 56.h;

class ChatInputBox extends StatefulWidget {
  const ChatInputBox({
    Key? key,
    required this.toolbox,
    this.allAtMap = const {},
    this.atCallback,
    this.controller,
    this.focusNode,
    this.style,
    this.atStyle,
    this.inputFormatters,
    this.enabled = true,
    this.isMultiModel = false,
    this.isNotInGroup = false,
    this.hintText,
    this.onSend,
  }) : super(key: key);
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? style;
  final TextStyle? atStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool isMultiModel;
  final bool isNotInGroup;
  final String? hintText;
  final Widget toolbox;
  final ValueChanged<String>? onSend;

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState
    extends State<ChatInputBox> /*with TickerProviderStateMixin */ {
  bool _toolsVisible = false;
  bool _emojiVisible = false;
  bool _leftKeyboardButton = false;
  bool _rightKeyboardButton = false;
  bool _sendButtonVisible = false;

  // late AnimationController _controller;
  // late Animation<double> _animation;

  /// 不可使用时的透明度，如禁言开启
  double get _opacity => (widget.enabled ? 1 : .4);

  @override
  void initState() {
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 200),
    //   vsync: this,
    // )..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       // controller.reverse();
    //     } else if (status == AnimationStatus.dismissed) {
    //       // controller.forward();
    //     }
    //   });
    //
    // _animation = Tween(begin: 1.0, end: 0.0).animate(_controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });

    widget.focusNode?.addListener(() {
      if (widget.focusNode!.hasFocus) {
        setState(() {
          _toolsVisible = false;
          _emojiVisible = false;
          _leftKeyboardButton = false;
          _rightKeyboardButton = false;
        });
      }
    });

    widget.controller?.addListener(() {
      setState(() {
        _sendButtonVisible = widget.controller!.text.isNotEmpty;
      });
      // if (widget.controller!.text.isEmpty) {
      //   _controller.reverse();
      // } else {
      //   _controller.forward();
      // }
    });

    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    // widget.controller?.dispose();
    // widget.focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) widget.controller?.clear();
    return widget.isNotInGroup
        ? const ChatDisableInputBox()
        : widget.isMultiModel
            ? const SizedBox()
            : Column(
                children: [
                  Container(
                    // height: 56.h,
                    constraints: BoxConstraints(minHeight: kInputBoxMinHeight),
                    color: Styles.c_F0F2F6,
                    child: Row(
                      children: [
                        12.horizontalSpace,
                        Expanded(
                          child: Stack(
                            children: [
                              Offstage(
                                offstage: _leftKeyboardButton,
                                child: _textFiled,
                              ),
                              // Offstage(
                              //   offstage: !_leftKeyboardButton,
                              //   child: widget.voiceRecordBar,
                              // ),
                            ],
                          ),
                        ),
                        12.horizontalSpace,
                        (_sendButtonVisible
                                ? ImageRes.sendMessage
                                : ImageRes.openToolbox)
                            .toImage
                          ..width = 32.w
                          ..height = 32.h
                          ..opacity = _opacity
                          ..onTap = _sendButtonVisible ? send : toggleToolbox,
                        12.horizontalSpace,
                        // Visibility(
                        //   visible: !_leftKeyboardButton || !_rightKeyboardButton,
                        //   child: Container(
                        //     width: 60.0.w * (1.0 - _animation.value),
                        //     margin: EdgeInsets.only(right: 4.w),
                        //     child: Button(
                        //       text: StrRes.send,
                        //       height: 32.h,
                        //       onTap: send,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _toolsVisible,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      child: widget.toolbox,
                    ),
                  ),
                ],
              );
  }

  Widget get _textFiled => Container(
        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: ChatTextField(
          allAtMap: widget.allAtMap,
          atCallback: widget.atCallback,
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: widget.style ?? Styles.ts_0C1C33_17sp,
          atStyle: widget.atStyle ?? Styles.ts_0089FF_17sp,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          hintText: widget.hintText,
          textAlign: widget.enabled ? TextAlign.start : TextAlign.center,
        ),
      );

  void send() {
    if (!widget.enabled) return;
    if (!_emojiVisible) focus();
    if (null != widget.onSend && null != widget.controller) {
      widget.onSend!(widget.controller!.text.toString().trim());
    }
  }

  void toggleToolbox() {
    if (!widget.enabled) return;
    setState(() {
      _toolsVisible = !_toolsVisible;
      _emojiVisible = false;
      _leftKeyboardButton = false;
      _rightKeyboardButton = false;
      if (_toolsVisible) {
        unfocus();
      } else {
        focus();
      }
    });
  }

  void onTapSpeak() {
    if (!widget.enabled) return;
    Permissions.microphone(() => setState(() {
          _leftKeyboardButton = true;
          _rightKeyboardButton = false;
          _toolsVisible = false;
          _emojiVisible = false;
          unfocus();
        }));
  }

  void onTapLeftKeyboard() {
    if (!widget.enabled) return;
    setState(() {
      _leftKeyboardButton = false;
      _toolsVisible = false;
      _emojiVisible = false;
      focus();
    });
  }

  void onTapRightKeyboard() {
    if (!widget.enabled) return;
    setState(() {
      _rightKeyboardButton = false;
      _toolsVisible = false;
      _emojiVisible = false;
      focus();
    });
  }

  void onTapEmoji() {
    if (!widget.enabled) return;
    setState(() {
      _rightKeyboardButton = true;
      _leftKeyboardButton = false;
      _emojiVisible = true;
      _toolsVisible = false;
      unfocus();
    });
  }

  focus() => FocusScope.of(context).requestFocus(widget.focusNode);

  unfocus() => FocusScope.of(context).requestFocus(FocusNode());
}

class _QuoteView extends StatelessWidget {
  const _QuoteView({
    Key? key,
    this.onClearQuote,
    required this.content,
  }) : super(key: key);
  final Function()? onClearQuote;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h, left: 56.w, right: 100.w),
      color: Styles.c_F0F2F6,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onClearQuote,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: Styles.ts_8E9AB0_14sp,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ImageRes.delQuote.toImage
                ..width = 14.w
                ..height = 14.h,
            ],
          ),
        ),
      ),
    );
  }
}
