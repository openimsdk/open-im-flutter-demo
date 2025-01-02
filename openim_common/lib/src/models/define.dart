import 'dart:io';

import 'package:openim_common/openim_common.dart';

enum OperationType { participants, roomSettings, leave, end, setting, onlyClose, kickOff } // case setting for app setting

enum OperationParticipantType {
  pined,
  focus,
  camera,
  microphone,
  nickname,
  setHost,
  kickoff,
  muteAll,
}

enum RoomSetting { allowParticipantUnMute, allowParticipantVideo, onlyHostCanShareScreen, defaultMuted, lockMeeting, audioEncouragement }

enum MeetingStatus {
  scheduled,
  inProgress,
  completed,
}

extension MeetingStatusExt on MeetingStatus {
  String get rawValue {
    switch (this) {
      case MeetingStatus.scheduled:
        return 'Scheduled';
      case MeetingStatus.inProgress:
        return 'In-Progress';
      case MeetingStatus.completed:
        return 'Completed';
    }
  }

  static MeetingStatus fromString(String str) {
    switch (str) {
      case 'Scheduled':
        return MeetingStatus.scheduled;
      case 'In-Progress':
        return MeetingStatus.inProgress;
      case 'Completed':
        return MeetingStatus.completed;
      default:
        throw Exception('Invalid MeetingStatus: $str');
    }
  }
}

enum Weekdays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension WeekdaysExt on Weekdays {
  String get title {
    switch (this) {
      case Weekdays.monday:
        return StrRes.monday;
      case Weekdays.tuesday:
        return StrRes.tuesday;
      case Weekdays.wednesday:
        return StrRes.wednesday;
      case Weekdays.thursday:
        return StrRes.thursday;
      case Weekdays.friday:
        return StrRes.friday;
      case Weekdays.saturday:
        return StrRes.saturday;
      case Weekdays.sunday:
        return StrRes.sunday;
    }
  }

  String get rawValue {
    switch (this) {
      case Weekdays.monday:
        return 'Monday';
      case Weekdays.tuesday:
        return 'Tuesday';
      case Weekdays.wednesday:
        return 'Wednesday';
      case Weekdays.thursday:
        return 'Thursday';
      case Weekdays.friday:
        return 'Friday';
      case Weekdays.saturday:
        return 'Saturday';
      case Weekdays.sunday:
        return 'Sunday';
    }
  }

  static Weekdays fromString(String str) {
    switch (str) {
      case 'Monday':
        return Weekdays.monday;
      case 'Tuesday':
        return Weekdays.tuesday;
      case 'Wednesday':
        return Weekdays.wednesday;
      case 'Thursday':
        return Weekdays.thursday;
      case 'Friday':
        return Weekdays.friday;
      case 'Saturday':
        return Weekdays.saturday;
      case 'Sunday':
        return Weekdays.sunday;
      default:
        throw Exception('Invalid Weekdays: $str');
    }
  }
}

enum HostType {
  host,
  coHost,
}

extension HostTypeExt on HostType {
  static HostType fromString(String str) {
    switch (str) {
      case 'Host':
        return HostType.host;
      case 'CoHost':
        return HostType.coHost;
      default:
        throw Exception('Invalid HostType: $str');
    }
  }
}

enum MxNLayoutViewType { oneXn, twoXtwo, threeXthree }

extension MxNLayoutViewTypeExt on MxNLayoutViewType {
  int get rawValue {
    switch (this) {
      case MxNLayoutViewType.oneXn:
        return 1;
      case MxNLayoutViewType.twoXtwo:
        return 2;
      case MxNLayoutViewType.threeXthree:
        return 3;
      default:
        return 1;
    }
  }
}
