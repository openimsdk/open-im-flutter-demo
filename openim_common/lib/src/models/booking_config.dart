import 'define.dart';

class BookingConfig {
  String name;
  int beginTime;
  int duration;
  int timeZone;
  int endsIn;
  int repeatTimes;

  int interval;
  List<int>? repeatDaysOfWeek;
  int monthUnit;
  List<int>? dates;

  bool enableMeetingPassword;
  String? meetingPassword;
  bool enableEnterBeforeHost;
  bool enableMicrophone;
  bool enableCamera;

  BookingConfig({
    required this.name,
    required this.beginTime,
    required this.duration,
    this.timeZone = 8,
    this.endsIn = 0,
    this.repeatTimes = 0,
    this.interval = 0,
    this.repeatDaysOfWeek,
    this.monthUnit = 0,
    this.dates,
    this.enableMeetingPassword = false,
    this.meetingPassword,
    this.enableEnterBeforeHost = true,
    this.enableMicrophone = true,
    this.enableCamera = true,
  });

  factory BookingConfig.fromMap(Map<String, dynamic> json) => BookingConfig(
        name: json['name'],
        beginTime: json['beginTime'],
        duration: json['duration'],
        timeZone: json['timeZone'],
        endsIn: json['endsIn'],
        repeatTimes: json['repeatTimes'],
        interval: json['interval'],
        repeatDaysOfWeek: json['repeatDaysOfWeek'],
        monthUnit: json['monthUnit'],
        dates: json['dates'],
        enableMeetingPassword: json['enableMeetingPassword'],
        meetingPassword: json['meetingPassword'],
        enableEnterBeforeHost: json['enableEnterBeforeHost'],
        enableMicrophone: json['enableMicrophone'],
        enableCamera: json['enableCamera'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'beginTime': beginTime,
        'duration': duration,
        'timeZone': timeZone,
        'endsIn': endsIn,
        'repeatTimes': repeatTimes,
        'interval': interval,
        'repeatDaysOfWeek': repeatDaysOfWeek,
        'monthUnit': monthUnit,
        'dates': dates,
        'enableMeetingPassword': enableMeetingPassword,
        'meetingPassword': meetingPassword,
        'enableEnterBeforeHost': enableEnterBeforeHost,
        'enableMicrophone': enableMicrophone,
        'enableCamera': enableCamera,
      };
}
