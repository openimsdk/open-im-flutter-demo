import 'dart:convert';

class OnlineStatus {
  String? userID;
  String? status;
  List<DetailPlatformStatus>? detailPlatformStatus;

  OnlineStatus({this.userID, this.status, this.detailPlatformStatus});

  OnlineStatus.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    status = json['status'];
    if (json['detailPlatformStatus'] != null) {
      detailPlatformStatus = <DetailPlatformStatus>[];
      json['detailPlatformStatus'].forEach((v) {
        detailPlatformStatus!.add(DetailPlatformStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['status'] = status;
    if (detailPlatformStatus != null) {
      data['detailPlatformStatus'] =
          detailPlatformStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class DetailPlatformStatus {
  String? platform;
  String? status;

  DetailPlatformStatus({this.platform, this.status});

  DetailPlatformStatus.fromJson(Map<String, dynamic> json) {
    platform = json['platform'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['platform'] = platform;
    data['status'] = status;
    return data;
  }
}
