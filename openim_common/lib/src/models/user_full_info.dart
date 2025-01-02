class UserFullInfo {
  String? userID;
  String? password;
  String? account;
  String? phoneNumber;
  String? areaCode;
  String? nickname;
  String? remark;
  String? englishName;
  String? faceURL;
  int? gender;
  String? mobileAreaCode;
  String? mobile;
  String? telephone;
  int? level;
  int? birth;
  String? email;
  int? order;
  int? status;
  int? allowAddFriend;
  int? allowBeep;
  int? allowVibration;
  int? forbidden;
  String? ex;
  String? station;
  int? globalRecvMsgOpt;
  bool isFriendship = false;
  bool isBlacklist = false;
  List<DepartmentInfo>? departmentList;

  bool get isMale => gender == 1;

  String get showName => remark?.isNotEmpty == true ? remark! : (nickname?.isNotEmpty == true ? nickname! : userID!);

  UserFullInfo({
    this.userID,
    this.password,
    this.account,
    this.phoneNumber,
    this.areaCode,
    this.nickname,
    this.remark,
    this.englishName,
    this.faceURL,
    this.gender,
    this.mobileAreaCode,
    this.mobile,
    this.telephone,
    this.level,
    this.birth,
    this.email,
    this.order,
    this.status,
    this.allowAddFriend,
    this.allowBeep,
    this.allowVibration,
    this.forbidden,
    this.station,
    this.ex,
    this.globalRecvMsgOpt,
    this.isFriendship = false,
    this.isBlacklist = false,
    this.departmentList,
  });

  UserFullInfo.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    password = json['password'];
    account = json['account'];
    phoneNumber = json['phoneNumber'];
    areaCode = json['areaCode'];
    nickname = json['nickname'];
    remark = json['remark'];
    englishName = json['englishName'];
    faceURL = json['faceURL'];
    gender = json['gender'];
    mobileAreaCode = json['mobileAreaCode'];
    mobile = json['mobile'];
    telephone = json['telephone'];
    level = json['level'];
    birth = json['birth'];
    email = json['email'];
    order = json['order'];
    status = json['status'];
    allowAddFriend = json['allowAddFriend'];
    allowBeep = json['allowBeep'];
    allowVibration = json['allowVibration'];
    forbidden = json['forbidden'];
    station = json['station'];
    ex = json['ex'];
    globalRecvMsgOpt = json['globalRecvMsgOpt'];
    isFriendship = json['isFriendship'] ?? false;
    isBlacklist = json['isBlacklist'] ?? false;
    departmentList = json['departmentList'] == null
        ? null
        : (json['departmentList'] as List).map((e) => DepartmentInfo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['password'] = password;
    data['account'] = account;
    data['phoneNumber'] = phoneNumber;
    data['areaCode'] = areaCode;
    data['nickname'] = nickname;
    data['remark'] = remark;
    data['englishName'] = englishName;
    data['faceURL'] = faceURL;
    data['gender'] = gender;
    data['mobileAreaCode'] = mobileAreaCode;
    data['telephone'] = telephone;
    data['level'] = level;
    data['birth'] = birth;
    data['email'] = email;
    data['order'] = order;
    data['status'] = status;
    data['allowAddFriend'] = allowAddFriend;
    data['allowBeep'] = allowBeep;
    data['allowVibration'] = allowVibration;
    data['forbidden'] = forbidden;
    data['station'] = station;
    data['ex'] = ex;
    data['globalRecvMsgOpt'] = globalRecvMsgOpt;
    data['isFriendship'] = isFriendship;
    data['isBlacklist'] = isBlacklist;
    data['departmentList'] = departmentList?.map((e) => e.toJson()).toList();
    return data;
  }
}

class DepartmentInfo {
  String? departmentID;
  String? departmentFaceURL;
  String? departmentName;
  String? departmentParentID;
  int? departmentOrder;
  int? departmentDepartmentType;
  String? departmentRelatedGroupID;
  int? departmentCreateTime;
  int? memberOrder;
  String? memberPosition;
  int? memberLeader;
  int? memberStatus;
  int? memberEntryTime;
  int? memberTerminationTime;
  int? memberCreateTime;

  DepartmentInfo(
      {this.departmentID,
      this.departmentFaceURL,
      this.departmentName,
      this.departmentParentID,
      this.departmentOrder,
      this.departmentDepartmentType,
      this.departmentRelatedGroupID,
      this.departmentCreateTime,
      this.memberOrder,
      this.memberPosition,
      this.memberLeader,
      this.memberStatus,
      this.memberEntryTime,
      this.memberTerminationTime,
      this.memberCreateTime});

  DepartmentInfo.fromJson(Map<String, dynamic> json) {
    departmentID = json['departmentID'];
    departmentFaceURL = json['departmentFaceURL'];
    departmentName = json['departmentName'];
    departmentParentID = json['departmentParentID'];
    departmentOrder = json['departmentOrder'];
    departmentDepartmentType = json['departmentDepartmentType'];
    departmentRelatedGroupID = json['departmentRelatedGroupID'];
    departmentCreateTime = json['departmentCreateTime'];
    memberOrder = json['memberOrder'];
    memberPosition = json['memberPosition'];
    memberLeader = json['memberLeader'];
    memberStatus = json['memberStatus'];
    memberEntryTime = json['memberEntryTime'];
    memberTerminationTime = json['memberTerminationTime'];
    memberCreateTime = json['memberCreateTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['departmentID'] = departmentID;
    data['departmentFaceURL'] = departmentFaceURL;
    data['departmentName'] = departmentName;
    data['departmentParentID'] = departmentParentID;
    data['departmentOrder'] = departmentOrder;
    data['departmentDepartmentType'] = departmentDepartmentType;
    data['departmentRelatedGroupID'] = departmentRelatedGroupID;
    data['departmentCreateTime'] = departmentCreateTime;
    data['memberOrder'] = memberOrder;
    data['memberPosition'] = memberPosition;
    data['memberLeader'] = memberLeader;
    data['memberStatus'] = memberStatus;
    data['memberEntryTime'] = memberEntryTime;
    data['memberTerminationTime'] = memberTerminationTime;
    data['memberCreateTime'] = memberCreateTime;
    return data;
  }
}
