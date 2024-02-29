import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'pages/single/room.dart';

enum CallType { audio, video }

enum CallObj { single, group }

enum CallState {
  call,
  beCalled,
  reject,
  beRejected,
  calling,
  beAccepted,
  hangup,
  beHangup,
  connecting,
  otherAccepted,
  otherReject,
  cancel,
  beCanceled,
  timeout,
  join,
  networkError,
}

class CallEvent {
  CallState state;
  SignalingInfo data;
  dynamic fields;

  CallEvent(this.state, this.data, {this.fields});

  @override
  String toString() {
    return 'CallEvent{state: $state, data: $data, fields: $fields}';
  }
}

class OpenIMLiveClient implements RTCBridge {
  OpenIMLiveClient._();

  static final OpenIMLiveClient singleton = OpenIMLiveClient._();

  factory OpenIMLiveClient() {
    PackageBridge.rtcBridge = singleton;
    return singleton;
  }

  @override
  bool get hasConnection => isBusy;

  @override
  void dismiss() {
    close();
  }

  static OverlayEntry? _holder;

  bool isBusy = false;

  String? currentRoomID;
  Future Function(int duration, bool isPositive)? onTapHangup;

  quitClose(String roomID) async {
    if (currentRoomID == roomID) {
      await onTapHangup?.call(0, true);
      closeByRoomID(roomID);
    }
  }

  closeByRoomID(String roomID) {
    if (currentRoomID == roomID) {
      close();
    }
  }

  close() {
    if (_holder != null) {
      _holder?.remove();
      _holder = null;
    }
    isBusy = false;
    currentRoomID = null;
    // The next line disables the wakelock again.
    WakelockPlus.disable();
  }

  start(
    BuildContext ctx, {
    required PublishSubject<CallEvent> callEventSubject,
    String? roomID,
    CallState initState = CallState.call,
    CallType callType = CallType.video,
    CallObj callObj = CallObj.single,
    required String inviterUserID,
    required List<String> inviteeUserIDList,
    String? groupID,
    Future<SignalingCertificate> Function()? onDialSingle,
    Future<SignalingCertificate> Function()? onDialGroup,
    Future<SignalingCertificate> Function()? onJoinGroup,
    Future<SignalingCertificate> Function()? onTapPickup,
    Future Function()? onTapCancel,
    Future Function(int duration, bool isPositive)? onTapHangup,
    Future Function()? onTapReject,
    Future<UserInfo?> Function(String userID)? onSyncUserInfo,
    Future<GroupInfo?> Function(String groupID)? onSyncGroupInfo,
    Future<List<GroupMembersInfo>> Function(String groupID, List<String> memberIDList)? onSyncGroupMemberInfo,
    bool autoPickup = false,
    Function()? onWaitingAccept,
    Function()? onBusyLine,
    Function()? onStartCalling,
    Function(dynamic error, dynamic stack)? onError,
    Function()? onClose,
    Function()? onRoomDisconnected,
  }) {
    if (isBusy) return;
    // close();
    isBusy = true;
    currentRoomID = roomID;
    this.onTapHangup = onTapHangup;

    FocusScope.of(ctx).requestFocus(FocusNode());

    if (callObj == CallObj.single) {
      _holder = OverlayEntry(
          builder: (context) => SingleRoomView(
                callType: callType,
                initState: initState,
                callEventSubject: callEventSubject,
                roomID: roomID,
                userID: initState == CallState.call ? inviteeUserIDList.first : inviterUserID,
                onDial: onDialSingle,
                onTapCancel: onTapCancel,
                onTapHangup: onTapHangup,
                onTapReject: onTapReject,
                onTapPickup: onTapPickup,
                onSyncUserInfo: onSyncUserInfo,
                autoPickup: autoPickup,
                onBindRoomID: (roomID) => currentRoomID = roomID,
                onWaitingAccept: onWaitingAccept,
                onBusyLine: onBusyLine,
                onStartCalling: onStartCalling,
                onError: onError,
                onRoomDisconnected: onRoomDisconnected,
                onClose: () {
                  onClose?.call();
                  close();
                },
              ));
    } else {}

    Overlay.of(ctx).insert(_holder!);
    // The following line will enable the Android and iOS wakelock.
    WakelockPlus.enable();
  }
}
