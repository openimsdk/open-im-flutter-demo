import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';

import '../../live_client.dart';
import 'widgets/call_state.dart';
import 'widgets/participant.dart';

class SingleRoomView extends SignalView {
  const SingleRoomView({
    super.key,
    required super.callType,
    required super.initState,
    required super.userID,
    required super.callEventSubject,
    required super.autoPickup,
    super.roomID,
    super.onClose,
    super.onBindRoomID,
    super.onBusyLine,
    super.onDial,
    super.onStartCalling,
    super.onTapCancel,
    super.onTapHangup,
    super.onTapPickup,
    super.onTapReject,
    super.onWaitingAccept,
    super.onSyncUserInfo,
    super.onError,
    super.onRoomDisconnected,
  });

  @override
  SignalState<SingleRoomView> createState() => _SingleRoomViewState();
}

class _SingleRoomViewState extends SignalState<SingleRoomView> {
  EventsListener<RoomEvent>? _listener;
  Room? _room;

  @override
  void dispose() {
    // always dispose listener
    (() async {
      _room?.removeListener(_onRoomDidUpdate);
      await _listener?.dispose();
      await _room?.remoteParticipants.values.firstOrNull?.dispose();
      await _room?.localParticipant?.dispose();
      await _room?.disconnect();
      await _room?.dispose();
    })();
    super.dispose();
  }

  @override
  Future<void> connect() async {
    final url = certificate.liveURL!;
    final token = certificate.token!;
    final busyLineUsers = certificate.busyLineUserIDList ?? [];
    if (busyLineUsers.isNotEmpty) {
      widget.onBusyLine?.call();
      widget.onClose?.call();
      return;
    }
    // Try to connect to a room
    // This will throw an Exception if it fails for any reason.
    try {
      //create new room
      _room = Room();

      // Create a Listener before connecting
      _listener = _room?.createListener();
      // Try to connect to the room
      // This will throw an Exception if it fails for any reason.
      await _room?.connect(url, token,
          roomOptions: RoomOptions(
              dynacast: true,
              adaptiveStream: true,
              defaultCameraCaptureOptions: const CameraCaptureOptions(params: VideoParametersPresets.h720_169),
              defaultVideoPublishOptions: VideoPublishOptions(
                  simulcast: true,
                  videoCodec: 'VP9',
                  videoEncoding: const VideoEncoding(
                    maxBitrate: 5 * 1000 * 1000,
                    maxFramerate: 15,
                  ))));
      if (!mounted) return;
      _room?.addListener(_onRoomDidUpdate);
      if (null != _listener) _setUpListeners();
      if (null != _room) roomDidUpdateSubject.add(_room!);
      _sortParticipants();
      if (CallState.call == callState || CallState.connecting == callState) {
        widget.onWaitingAccept?.call();
      }
      WidgetsBindingCompatible.instance?.addPostFrameCallback((_) {
        _publish();
      });
    } catch (error, stackTrace) {
      widget.onError?.call(error, stackTrace);
    }
  }

  void _setUpListeners() => _listener!
    ..on<RoomDisconnectedEvent>((event) async {
      Logger.print('Room disconnected: reason => ${event.reason}');
      WidgetsBindingCompatible.instance?.addPostFrameCallback((_) {
        widget.onRoomDisconnected?.call();
        widget.onClose?.call();
      });
    })
    ..on<RoomRecordingStatusChanged>((event) {})
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<ParticipantConnectedEvent>((_) => onParticipantConnected())
    ..on<ParticipantDisconnectedEvent>((_) => onParticipantDisconnected())
    ..on<DataReceivedEvent>((event) {
      String decoded = 'Failed to decode';
      try {
        decoded = utf8.decode(event.data);
      } catch (_) {
        Logger.print('Failed to decode: $_');
      }
    });

  void _publish() async {
    // video will fail when running in ios simulator
    try {
      final enabled = widget.callType == CallType.video;
      await _room?.localParticipant?.setCameraEnabled(enabled);
    } catch (error, stackTrace) {
      Logger.print('could not publish video: $error $stackTrace');
    }
    try {
      await _room?.localParticipant?.setMicrophoneEnabled(enabledMicrophone);
    } catch (error, stackTrace) {
      Logger.print('could not publish audio: $error $stackTrace');
    }
  }

  void _onRoomDidUpdate() {
    _sortParticipants();
    if (null != _room) roomDidUpdateSubject.add(_room!);
  }

  void _sortParticipants() {
    if (null == _room) return;

    final localParticipant = _room!.localParticipant;
    if (null != localParticipant) {
      VideoTrack? videoTrack;
      for (var t in localParticipant.videoTrackPublications) {
        if (!t.isScreenShare) {
          videoTrack = t.track;
          break;
        }
      }
      localParticipantTrack = ParticipantTrack(
        participant: localParticipant,
        videoTrack: videoTrack,
        isScreenShare: false,
      );
    }

    final participant = _room!.remoteParticipants.values.firstOrNull;
    if (null != participant) {
      VideoTrack? videoTrack;
      for (var t in participant.videoTrackPublications) {
        if (!t.isScreenShare) {
          videoTrack = t.track;
          break;
        }
      }
      remoteParticipantTrack = ParticipantTrack(
        participant: participant,
        videoTrack: videoTrack,
        isScreenShare: false,
      );
    }

    if (null != remoteParticipantTrack) {
      onParticipantConnected();
    }
    setState(() {});
  }

  @override
  bool existParticipants() {
    return _room?.remoteParticipants.isNotEmpty == true;
  }
}
