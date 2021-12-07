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
    final data = Map<String, dynamic>();
    data['userID'] = this.userID;
    data['status'] = this.status;
    if (this.detailPlatformStatus != null) {
      data['detailPlatformStatus'] =
          this.detailPlatformStatus!.map((v) => v.toJson()).toList();
    }
    return data;
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
    final data = Map<String, dynamic>();
    data['platform'] = this.platform;
    data['status'] = this.status;
    return data;
  }
}
