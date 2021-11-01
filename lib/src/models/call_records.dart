class CallRecords {
  String uid;
  String name;
  String? icon;
  String type;
  bool success;
  bool incomingCall;
  int date;
  int duration;

  CallRecords({
    required this.uid,
    required this.name,
    this.icon,
    required this.type,
    required this.success,
    required this.incomingCall,
    required this.date,
    required this.duration,
  });

  CallRecords.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        icon = json['icon'],
        type = json['type'],
        success = json['success'],
        incomingCall = json['incomingCall'],
        date = json['date'],
        duration = json['duration'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['type'] = this.type;
    data['success'] = this.success;
    data['incomingCall'] = this.incomingCall;
    data['date'] = this.date;
    data['duration'] = this.duration;
    return data;
  }
}
