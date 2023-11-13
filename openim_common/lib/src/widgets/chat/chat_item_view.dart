import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:rxdart/rxdart.dart';

double maxWidth = 247.w;
double pictureWidth = 120.w;
double videoWidth = 120.w;
double locationWidth = 220.w;

BorderRadius borderRadius(bool isISend) => BorderRadius.only(
      topLeft: Radius.circular(isISend ? 6.r : 0),
      topRight: Radius.circular(isISend ? 0 : 6.r),
      bottomLeft: Radius.circular(6.r),
      bottomRight: Radius.circular(6.r),
    );

class MsgStreamEv<T> {
  final String id;
  final T value;

  MsgStreamEv({required this.id, required this.value});

  @override
  String toString() {
    return 'MsgStreamEv{msgId: $id, value: $value}';
  }
}

class CustomTypeInfo {
  final Widget customView;
  final bool needBubbleBackground;
  final bool needChatItemContainer;

  CustomTypeInfo(
    this.customView, [
    this.needBubbleBackground = true,
    this.needChatItemContainer = true,
  ]);
}

typedef CustomTypeBuilder = CustomTypeInfo? Function(
  BuildContext context,
  Message message,
);
typedef NotificationTypeBuilder = Widget? Function(
  BuildContext context,
  Message message,
);
typedef ItemViewBuilder = Widget? Function(
  BuildContext context,
  Message message,
);
typedef ItemVisibilityChange = void Function(
  Message message,
  bool visible,
);

class ChatItemView extends StatefulWidget {
  const ChatItemView({
    Key? key,
    this.itemViewBuilder,
    this.customTypeBuilder,
    this.notificationTypeBuilder,
    this.sendStatusSubject,
    this.sendProgressSubject,
    this.timelineStr,
    this.leftNickname,
    this.leftFaceUrl,
    this.rightNickname,
    this.rightFaceUrl,
    required this.message,
    this.textScaleFactor = 1.0,
    this.ignorePointer = false,
    this.showLeftNickname = true,
    this.showRightNickname = false,
    this.highlightColor,
    this.allAtMap = const {},
    this.patterns = const [],
    this.onTapLeftAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onLongPressRightAvatar,
    this.onVisibleTrulyText,
    this.onFailedToResend,
    this.onClickItemView,
  }) : super(key: key);

  final ItemViewBuilder? itemViewBuilder;
  final CustomTypeBuilder? customTypeBuilder;
  final NotificationTypeBuilder? notificationTypeBuilder;
  final Subject<MsgStreamEv<bool>>? sendStatusSubject;
  final Subject<MsgStreamEv<int>>? sendProgressSubject;
  final String? timelineStr;
  final String? leftNickname;
  final String? leftFaceUrl;
  final String? rightNickname;
  final String? rightFaceUrl;
  final Message message;

  final double textScaleFactor;

  final bool ignorePointer;
  final bool showLeftNickname;
  final bool showRightNickname;

  final Color? highlightColor;
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final Function()? onTapLeftAvatar;
  final Function()? onTapRightAvatar;
  final Function()? onLongPressLeftAvatar;
  final Function()? onLongPressRightAvatar;
  final Function(String? text)? onVisibleTrulyText;
  final Function()? onClickItemView;

  final Function()? onFailedToResend;

  @override
  State<ChatItemView> createState() => _ChatItemViewState();
}

class _ChatItemViewState extends State<ChatItemView> {
  Message get _message => widget.message;

  bool get _isISend => _message.sendID == OpenIM.iMManager.userID;

  late StreamSubscription<bool> _keyboardSubs;

  @override
  void dispose() {
    _keyboardSubs.cancel();
    super.dispose();
  }

  @override
  void initState() {
    final keyboardVisibilityCtrl = KeyboardVisibilityController();

    _keyboardSubs = keyboardVisibilityCtrl.onChange.listen((bool visible) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      child: Container(
        color: widget.highlightColor,
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Center(child: _child),
      ),
      onVisibilityLost: () {},
      onVisibilityGained: () {},
    );
  }

  Widget get _child => widget.itemViewBuilder?.call(context, _message) ?? _buildChildView();

  Widget _buildChildView() {
    Widget? child;
    String? senderNickname;
    String? senderFaceURL;
    bool isBubbleBg = false;

    if (_message.isTextType) {
      isBubbleBg = true;
      child = ChatText(
        text: _message.textElem!.content!,
        patterns: widget.patterns,
        textScaleFactor: widget.textScaleFactor,
        onVisibleTrulyText: widget.onVisibleTrulyText,
      );
    } else if (_message.isAtTextType) {
      isBubbleBg = true;
      child = ChatText(
        text: _message.atTextElem!.text!,
        allAtMap: IMUtils.getAtMapping(_message, widget.allAtMap),
        patterns: widget.patterns,
        textScaleFactor: widget.textScaleFactor,
        onVisibleTrulyText: widget.onVisibleTrulyText,
      );
    } else if (_message.isPictureType) {
      child = ChatPictureView(
        isISend: _isISend,
        message: _message,
        sendProgressStream: widget.sendProgressSubject,
      );
    } else if (_message.isVideoType) {
      final video = _message.videoElem;
      child = ChatVideoView(
        isISend: _isISend,
        message: _message,
        sendProgressStream: widget.sendProgressSubject,
      );
    } else if (_message.isCustomType) {
      final info = widget.customTypeBuilder?.call(context, _message);
      if (null != info) {
        isBubbleBg = info.needBubbleBackground;
        child = info.customView;
        if (!info.needChatItemContainer) {
          return child;
        }
      }
    } else if (_message.isNotificationType) {
      if (_message.contentType == MessageType.groupInfoSetAnnouncementNotification) {
      } else {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ChatHintTextView(message: _message),
        );
      }
    }
    senderNickname ??= widget.leftNickname ?? _message.senderNickname;
    senderFaceURL ??= widget.leftFaceUrl ?? _message.senderFaceUrl;
    return child = ChatItemContainer(
      id: _message.clientMsgID!,
      isISend: _isISend,
      leftNickname: senderNickname,
      leftFaceUrl: senderFaceURL,
      rightNickname: widget.rightNickname ?? OpenIM.iMManager.userInfo.nickname,
      rightFaceUrl: widget.rightFaceUrl ?? OpenIM.iMManager.userInfo.faceURL,
      showLeftNickname: widget.showLeftNickname,
      showRightNickname: widget.showRightNickname,
      timelineStr: widget.timelineStr,
      timeStr: IMUtils.getChatTimeline(_message.sendTime!, 'HH:mm:ss'),
      isSending: _message.status == MessageStatus.sending,
      isSendFailed: _message.status == MessageStatus.failed,
      isBubbleBg: child == null ? true : isBubbleBg,
      ignorePointer: widget.ignorePointer,
      sendStatusStream: widget.sendStatusSubject,
      onFailedToResend: widget.onFailedToResend,
      onLongPressLeftAvatar: widget.onLongPressLeftAvatar,
      onLongPressRightAvatar: widget.onLongPressRightAvatar,
      onTapLeftAvatar: widget.onTapLeftAvatar,
      onTapRightAvatar: widget.onTapRightAvatar,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onClickItemView,
        child: child ?? ChatText(text: StrRes.unsupportedMessage),
      ),
    );
  }
}
