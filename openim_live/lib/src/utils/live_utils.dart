import 'package:collection/collection.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';

import '../../openim_live.dart';

class LiveUtils {
  /// Regex of url.
  static const String regexUrl = '[a-zA-Z]+://[^\\s]*';

  /// Return whether input matches regex of url.
  static bool isURL(String input) {
    return matches(regexUrl, input);
  }

  static bool matches(String regex, String input) {
    if (input.isEmpty) return false;
    return RegExp(regex).hasMatch(input);
  }

  static String seconds2HMS(int seconds) {
    int h = 0;
    int m = 0;
    int s = 0;
    int temp = seconds % 3600;
    if (seconds > 3600) {
      h = seconds ~/ 3600;
      if (temp != 0) {
        if (temp > 60) {
          m = temp ~/ 60;
          if (temp % 60 != 0) {
            s = temp % 60;
          }
        } else {
          s = temp;
        }
      }
    } else {
      m = seconds ~/ 60;
      if (seconds % 60 != 0) {
        s = seconds % 60;
      }
    }
    if (h == 0) {
      return '${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}';
    }
    return "${h < 10 ? '0$h' : h}:${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";
  }

  static VideoTrack? activeVideoTrack(RemoteParticipant participant) {
    for (final trackPublication in participant.videoTrackPublications) {
      Logger.print(
          'video track ${trackPublication.sid} subscribed ${trackPublication.subscribed} muted ${trackPublication.muted}');
      if (trackPublication.subscribed && !trackPublication.muted) {
        return trackPublication.track;
      }
    }
    return null;
  }

  /// 剔除房间观察者
  static List<RemoteParticipant> removeObserver(String roomID, Room room) {
    return room.remoteParticipants.values.where((element) {
      Logger.print(
          'removeObserver roomID:$roomID  userID:${element.identity}   ${roomID == element.identity}');
      return roomID != element.identity;
    }).toList();
  }

  /// 单聊获取真正通话的对象
  static RemoteParticipant? getRemoteParticipant(String? roomID, Room? room) {
    return room?.remoteParticipants.values
        .where((element) => roomID != element.identity)
        .firstOrNull;
  }

  /// 我主动发起通话，一开始roomID为null，拨号成功返回roomID
  /// 我被邀请通话，一开始就存在roomID
  static bool isSameRoom(CallEvent event, String? roomID) {
    var signalingInfo = event.data;
    var opUserID = signalingInfo.userID;
    var invitation = signalingInfo.invitation!;
    // var inviterUserID = invitation.inviterUserID;
    // var inviteeUserIDList = invitation.inviteeUserIDList;
    // var groupID = invitation.groupID;
    // var roomID = invitation.roomID;
    // var timeout = invitation.timeout;
    // var mediaType = invitation.mediaType;
    // var sessionType = invitation.sessionType;
    // var platformID = invitation.platformID;
    Logger.print('${event.state}--当前房间：$roomID--信令来自：${invitation.roomID}');
    return roomID == invitation.roomID;
  }
}
