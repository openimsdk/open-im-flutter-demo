import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
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
    this.mediaItemBuilder,
    this.itemViewBuilder,
    this.customTypeBuilder,
    this.notificationTypeBuilder,
    this.sendStatusSubject,
    this.visibilityChange,
    this.timelineStr,
    this.leftNickname,
    this.leftFaceUrl,
    this.rightNickname,
    this.rightFaceUrl,
    required this.message,
    this.textScaleFactor = 1.0,
    this.readingDuration = 30,
    this.enabledReadStatus = true,
    this.showLongPressMenu = true,
    this.isPlayingSound = false,
    this.ignorePointer = false,
    this.enabledAddEmojiMenu = true,
    this.enabledCopyMenu = true,
    this.enabledDelMenu = true,
    this.enabledForwardMenu = true,
    this.enabledReplyMenu = true,
    this.enabledRevokeMenu = true,
    this.showLeftNickname = true,
    this.showRightNickname = false,
    this.onTapAddEmojiMenu,
    this.highlightColor,
    this.allAtMap = const {},
    this.patterns = const [],
    this.onTapLeftAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onLongPressRightAvatar,
    this.onTapCopyMenu,
    this.onTapDelMenu,
    this.onTapForwardMenu,
    this.onTapRevokeMenu,
    this.onVisibleTrulyText,
    this.onPopMenuShowChanged,
    this.onFailedToResend,
    this.closePopMenuSubject,
    this.onClickItemView,
    this.fileDownloadProgressView,
    required this.onTapUserProfile,
  }) : super(key: key);
  final ItemViewBuilder? mediaItemBuilder;
  final ItemViewBuilder? itemViewBuilder;
  final CustomTypeBuilder? customTypeBuilder;
  final NotificationTypeBuilder? notificationTypeBuilder;

  final Subject<MsgStreamEv<bool>>? sendStatusSubject;

  final ItemVisibilityChange? visibilityChange;
  final String? timelineStr;
  final String? leftNickname;
  final String? leftFaceUrl;
  final String? rightNickname;
  final String? rightFaceUrl;
  final Message message;

  final double textScaleFactor;

  final int readingDuration;

  final bool enabledReadStatus;

  final bool showLongPressMenu;

  final bool isPlayingSound;

  final bool ignorePointer;
  final bool enabledCopyMenu;
  final bool enabledDelMenu;
  final bool enabledForwardMenu;
  final bool enabledReplyMenu;
  final bool enabledRevokeMenu;
  final bool enabledAddEmojiMenu;
  final bool showLeftNickname;
  final bool showRightNickname;

  final Color? highlightColor;
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final Function()? onTapLeftAvatar;
  final Function()? onTapRightAvatar;
  final Function()? onLongPressLeftAvatar;
  final Function()? onLongPressRightAvatar;
  final Function()? onTapCopyMenu;
  final Function()? onTapDelMenu;
  final Function()? onTapForwardMenu;
  final Function()? onTapRevokeMenu;
  final Function()? onTapAddEmojiMenu;
  final Function(String? text)? onVisibleTrulyText;
  final Function(bool show)? onPopMenuShowChanged;
  final Function()? onClickItemView;
  final ValueChanged<({String userID, String name, String? faceURL, String? groupID})> onTapUserProfile;

  final Function()? onFailedToResend;

  final Subject<bool>? closePopMenuSubject;

  final Widget? fileDownloadProgressView;
  @override
  State<ChatItemView> createState() => _ChatItemViewState();
}

class _ChatItemViewState extends State<ChatItemView> {
  final _popupCtrl = CustomPopupMenuController();

  Message get _message => widget.message;

  bool get _isISend => _message.sendID == OpenIM.iMManager.userID;

  late StreamSubscription<bool> _keyboardSubs;
  StreamSubscription<bool>? _closeMenuSubs;

  @override
  void dispose() {
    _popupCtrl.dispose();
    _keyboardSubs.cancel();
    _closeMenuSubs?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    final keyboardVisibilityCtrl = KeyboardVisibilityController();

    _keyboardSubs = keyboardVisibilityCtrl.onChange.listen((bool visible) {
      _popupCtrl.hideMenu();
    });

    _popupCtrl.addListener(() {
      widget.onPopMenuShowChanged?.call(_popupCtrl.menuIsShowing);
    });

    _closeMenuSubs = widget.closePopMenuSubject?.listen((value) {
      if (value == true) {
        _popupCtrl.hideMenu();
      }
    });
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
      onVisibilityLost: () {
        widget.visibilityChange?.call(widget.message, false);
      },
      onVisibilityGained: () {
        widget.visibilityChange?.call(widget.message, true);
      },
    );
  }

  Widget get _child => widget.itemViewBuilder?.call(context, _message) ?? _buildChildView();

  Widget _buildChildView() {
    Widget? child;
    String? senderNickname;
    String? senderFaceURL;
    bool isBubbleBg = false;
    /* if (_message.isCallType) {
    } else if (_message.isMeetingType) {
    } else if (_message.isDeletedByFriendType) {
    } else if (_message.isBlockedByFriendType) {
    } else if (_message.isEmojiType) {
    } else if (_message.isTagType) {
    }*/
    if (_message.isTextType) {
      isBubbleBg = true;
      child = ChatText(
        text: _message.textElem!.content!,
        patterns: widget.patterns,
        textScaleFactor: widget.textScaleFactor,
        onVisibleTrulyText: widget.onVisibleTrulyText,
      );
    } else if (_message.isPictureType) {
      child = widget.mediaItemBuilder?.call(context, _message) ??
          ChatPictureView(
            isISend: _isISend,
            message: _message,
          );
    } else if (_message.isVoiceType) {
      isBubbleBg = true;
      final sound = _message.soundElem;
      child = ChatVoiceView(
        isISend: _isISend,
        soundPath: sound?.soundPath,
        soundUrl: sound?.sourceUrl,
        duration: sound?.duration,
        isPlaying: widget.isPlayingSound,
      );
    } else if (_message.isVideoType) {
      child = widget.mediaItemBuilder?.call(context, _message) ??
          ChatVideoView(
            isISend: _isISend,
            message: _message,
          );
    } else if (_message.isFileType) {
      child = ChatFileView(
        message: _message,
        isISend: _isISend,
        fileDownloadProgressView: widget.fileDownloadProgressView,
      );
    } else if (_message.isLocationType) {
      final location = _message.locationElem;
      child = ChatLocationView(
        description: location!.description!,
        latitude: location.latitude!,
        longitude: location.longitude!,
      );
    } else if (_message.isCardType) {
      child = ChatCarteView(cardElem: _message.cardElem!);
    } else if (_message.isCustomFaceType) {
      final face = _message.faceElem;
      child = ChatCustomEmojiView(
        index: face?.index,
        data: face?.data,
        isISend: _isISend,
        heroTag: _message.clientMsgID,
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
    } else if (_message.isRevokeType) {
      return child = ChatRevokeView(
        message: _message,
      );
    } else if (_message.isNotificationType) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ChatHintTextView(
          message: _message,
          onTapUserProfile: widget.onTapUserProfile,
        ),
      );
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
      hasRead: _message.isRead!,
      isSending: _message.isVideoType ? false : _message.status == MessageStatus.sending,
      isSendFailed: _message.status == MessageStatus.failed,
      isBubbleBg: child == null ? true : isBubbleBg,
      menus: widget.showLongPressMenu ? _menusItem : [],
      ignorePointer: widget.ignorePointer,
      readingDuration: widget.readingDuration,
      sendStatusStream: widget.sendStatusSubject,
      onFailedToResend: widget.onFailedToResend,
      popupMenuController: _popupCtrl,
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

  List<MenuInfo> get _menusItem => [
        if (widget.enabledCopyMenu)
          MenuInfo(
            icon: ImageRes.menuCopy,
            text: StrRes.menuCopy,
            enabled: widget.enabledCopyMenu,
            onTap: widget.onTapCopyMenu,
          ),
        if (widget.enabledDelMenu)
          MenuInfo(
            icon: ImageRes.menuDel,
            text: StrRes.menuDel,
            enabled: widget.enabledDelMenu,
            onTap: widget.onTapDelMenu,
          ),
        if (widget.enabledForwardMenu)
          MenuInfo(
            icon: ImageRes.menuForward,
            text: StrRes.menuForward,
            enabled: widget.enabledForwardMenu,
            onTap: widget.onTapForwardMenu,
          ),
        if (widget.enabledRevokeMenu)
          MenuInfo(
            icon: ImageRes.menuRevoke,
            text: StrRes.menuRevoke,
            enabled: widget.enabledRevokeMenu,
            onTap: widget.onTapRevokeMenu,
          ),
        if (widget.enabledAddEmojiMenu)
          MenuInfo(
            icon: ImageRes.menuAddFace,
            text: StrRes.menuAdd,
            enabled: widget.enabledAddEmojiMenu,
            onTap: widget.onTapAddEmojiMenu,
          ),
      ];
}
