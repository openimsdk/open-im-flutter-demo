import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

double kInputBoxMinHeight = 56.h;

class ChatInputBox extends StatefulWidget {
  const ChatInputBox({
    Key? key,
    required this.toolbox,
    required this.voiceRecordBar,
    required this.emojiView,
    this.controller,
    this.focusNode,
    this.style,
    this.atStyle,
    this.enabled = true,
    this.isNotInGroup = false,
    this.hintText,
    this.forceCloseToolboxSub,
    this.quoteContent,
    this.onClearQuote,
    this.onSend,
    this.directionalText,
    this.onCloseDirectional,
  }) : super(key: key);
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? style;
  final TextStyle? atStyle;
  final bool enabled;
  final bool isNotInGroup;
  final String? hintText;
  final Widget toolbox;
  final Widget voiceRecordBar;
  final Widget emojiView;
  final Stream? forceCloseToolboxSub;
  final String? quoteContent;
  final Function()? onClearQuote;
  final ValueChanged<String>? onSend;
  final TextSpan? directionalText;
  final VoidCallback? onCloseDirectional;

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> /*with TickerProviderStateMixin */ {
  bool _toolsVisible = false;
  bool _emojiVisible = false;
  bool _leftKeyboardButton = false;
  bool _rightKeyboardButton = false;
  bool _sendButtonVisible = false;

  bool get _showQuoteView => IMUtils.isNotNullEmptyStr(widget.quoteContent);

  double get _opacity => (widget.enabled ? 1 : .4);

  bool get _showDirectionalView => widget.directionalText != null;

  @override
  void initState() {
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

    widget.forceCloseToolboxSub?.listen((value) {
      if (!mounted) return;
      setState(() {
        _toolsVisible = false;
        _emojiVisible = false;
        _rightKeyboardButton = false;
      });
    });

    widget.controller?.addListener(() {
      setState(() {
        _sendButtonVisible = widget.controller!.text.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) widget.controller?.clear();
    return widget.isNotInGroup
        ? const ChatDisableInputBox()
        : Column(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: kInputBoxMinHeight),
                color: Styles.c_F0F2F6,
                child: Row(
                  children: [
                    12.horizontalSpace,
                    (_leftKeyboardButton
                        ? (ImageRes.openKeyboard.toImage..onTap = onTapLeftKeyboard)
                        : (ImageRes.openVoice.toImage..onTap = onTapSpeak))
                      ..width = 32.w
                      ..height = 32.h
                      ..opacity = _opacity,
                    12.horizontalSpace,
                    Expanded(
                      child: Stack(
                        children: [
                          Offstage(
                            offstage: _leftKeyboardButton,
                            child: _textFiled,
                          ),
                          Offstage(
                            offstage: !_leftKeyboardButton,
                            child: widget.voiceRecordBar,
                          ),
                        ],
                      ),
                    ),
                    12.horizontalSpace,
                    (_rightKeyboardButton
                        ? (ImageRes.openKeyboard.toImage..onTap = onTapRightKeyboard)
                        : (ImageRes.openEmoji.toImage..onTap = onTapEmoji))
                      ..width = 32.w
                      ..height = 32.h
                      ..opacity = _opacity,
                    12.horizontalSpace,
                    (_sendButtonVisible ? ImageRes.sendMessage : ImageRes.openToolbox).toImage
                      ..width = 32.w
                      ..height = 32.h
                      ..opacity = _opacity
                      ..onTap = _sendButtonVisible ? send : toggleToolbox,
                    12.horizontalSpace,
                  ],
                ),
              ),
              if (_showQuoteView)
                _QuoteView(
                  content: widget.quoteContent!,
                  onClearQuote: widget.onClearQuote,
                ),
              if (_showDirectionalView)
                _SubView(
                  textSpan: widget.directionalText,
                  onClose: () {
                    widget.onCloseDirectional?.call();
                  },
                ),
              Visibility(
                visible: _toolsVisible,
                child: FadeInUp(
                  duration: const Duration(milliseconds: 200),
                  child: widget.toolbox,
                ),
              ),
              Visibility(
                visible: _emojiVisible,
                child: FadeInUp(
                  duration: const Duration(milliseconds: 200),
                  child: widget.emojiView,
                ),
              ),
            ],
          );
  }

  Widget get _textFiled => Container(
        margin: EdgeInsets.only(top: 10.h, bottom: _showQuoteView ? 4.h : 10.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: ChatTextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: widget.style ?? Styles.ts_0C1C33_17sp,
          atStyle: widget.atStyle ?? Styles.ts_0089FF_17sp,
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

class _SubView extends StatelessWidget {
  const _SubView({
    this.onClose,
    this.title,
    this.content,
    this.textSpan,
  }) : assert(content != null || textSpan != null, 'Either content or textSpan must be provided.');
  final VoidCallback? onClose;
  final String? title;
  final String? content;
  final InlineSpan? textSpan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h, left: 56.w, right: 100.w),
      color: Styles.c_F0F2F6,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onClose,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Row(
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: Styles.ts_8E9AB0_14sp,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (content != null)
                      Text(
                        title!,
                        style: Styles.ts_8E9AB0_14sp,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (textSpan != null)
                      Expanded(
                        child: RichText(
                          text: textSpan!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
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
