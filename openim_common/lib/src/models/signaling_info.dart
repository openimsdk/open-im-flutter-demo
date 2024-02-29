import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class SignalingInfo {
  String? userID;

  InvitationInfo? invitation;

  OfflinePushInfo? offlinePushInfo;

  SignalingInfo({
    this.userID,
    this.invitation,
    this.offlinePushInfo,
  });

  SignalingInfo.fromJson(Map<String, dynamic> json) {
    invitation = json['invitation'] == null ? null : InvitationInfo.fromJson(json['invitation']);
    offlinePushInfo = json['offlinePushInfo'] == null ? null : OfflinePushInfo.fromJson(json['offlinePushInfo']);
    userID = json['userID'] ?? invitation?.inviterUserID;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = this.userID;
    data['invitation'] = this.invitation?.toJson();
    data['offlinePushInfo'] = this.offlinePushInfo?.toJson();
    return data;
  }
}

class InvitationInfo {
  String? inviterUserID;

  List<String>? inviteeUserIDList;

  String? groupID;

  String? roomID;

  int? timeout;

  String? mediaType;

  int? sessionType;

  int? platformID;

  InvitationInfo(
      {this.inviterUserID, this.inviteeUserIDList, this.groupID, this.roomID, this.timeout, this.mediaType, this.sessionType, this.platformID});

  InvitationInfo.fromJson(Map<String, dynamic> json) {
    inviterUserID = json['inviterUserID'];
    inviteeUserIDList = json['inviteeUserIDList']?.cast<String>();
    groupID = json['groupID'];
    roomID = json['roomID'];
    timeout = json['timeout'];
    mediaType = json['mediaType'];
    sessionType = json['sessionType'];
    platformID = json['platformID'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['inviterUserID'] = this.inviterUserID;
    data['inviteeUserIDList'] = this.inviteeUserIDList;
    data['groupID'] = this.groupID;
    data['roomID'] = this.roomID;
    data['timeout'] = this.timeout;
    data['mediaType'] = this.mediaType;
    data['sessionType'] = this.sessionType;
    data['platformID'] = this.platformID;
    return data;
  }
}

class SignalingCertificate {
  String? token;

  String? roomID;

  String? liveURL;

  List<String>? busyLineUserIDList;

  SignalingCertificate({
    this.token,
    this.roomID,
    this.liveURL,
    this.busyLineUserIDList,
  });

  SignalingCertificate.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    roomID = json['roomID'];
    liveURL = json['serverUrl'];
    busyLineUserIDList = json['busyLineUserIDList']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['token'] = this.token;
    data['roomID'] = this.roomID;
    data['serverUrl'] = this.liveURL;
    data['busyLineUserIDList'] = this.busyLineUserIDList;
    return data;
  }
}

class RoomCallingInfo {
  InvitationInfo? invitation;
  List<Participant>? participant;
  String? roomID;
  String? token;
  String? liveURL;
  String? groupID;

  RoomCallingInfo({
    this.invitation,
    this.participant,
    this.roomID,
    this.token,
    this.liveURL,
    this.groupID,
  });

  RoomCallingInfo.fromJson(Map<String, dynamic> json) {
    invitation = json['invitation'] != null ? InvitationInfo.fromJson(json['invitation']) : null;
    if (json['participant'] != null) {
      participant = <Participant>[];
      json['participant'].forEach((v) {
        participant!.add(Participant.fromJson(v));
      });
    }
    roomID = json['roomID'] ?? invitation?.roomID;
    token = json['token'];
    liveURL = json['liveURL'];
    groupID = json['groupID'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (this.invitation != null) {
      data['invitation'] = this.invitation!.toJson();
    }
    if (this.participant != null) {
      data['participant'] = this.participant!.map((v) => v.toJson()).toList();
    }
    data['roomID'] = this.roomID;
    data['token'] = this.token;
    data['liveURL'] = this.liveURL;
    data['groupID'] = this.groupID;
    return data;
  }
}

class Participant {
  GroupInfo? groupInfo;
  GroupMembersInfo? groupMemberInfo;
  UserInfo? userInfo;

  Participant({this.groupInfo, this.groupMemberInfo, this.userInfo});

  Participant.fromJson(Map<String, dynamic> json) {
    groupInfo = json['groupInfo'] != null ? GroupInfo.fromJson(json['groupInfo']) : null;
    groupMemberInfo = json['groupMemberInfo'] != null ? GroupMembersInfo.fromJson(json['groupMemberInfo']) : null;
    userInfo = json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (this.groupInfo != null) {
      data['groupInfo'] = this.groupInfo!.toJson();
    }
    if (this.groupMemberInfo != null) {
      data['groupMemberInfo'] = this.groupMemberInfo!.toJson();
    }
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo!.toJson();
    }
    return data;
  }
}

class CustomSignaling {
  String? roomID;
  String? customInfo;

  CustomSignaling({this.roomID, this.customInfo});

  CustomSignaling.fromJson(Map<String, dynamic> json) {
    roomID = json['roomID'];
    customInfo = json['customInfo'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['roomID'] = roomID;
    data['customInfo'] = customInfo;
    return data;
  }
}
