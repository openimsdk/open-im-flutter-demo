/// 蒲公英
class UpgradeInfoV2 {
  String? buildBuildVersion;
  String? forceUpdateVersion;
  String? forceUpdateVersionNo;
  bool? needForceUpdate;
  String? downloadURL;
  bool? buildHaveNewVersion;
  String? buildVersionNo;
  String? buildVersion;
  String? buildUpdateDescription;
  String? appKey;
  String? buildKey;
  String? buildName;
  String? buildIcon;
  String? buildFileKey;
  String? buildFileSize;

  UpgradeInfoV2(
      {this.buildBuildVersion,
      this.forceUpdateVersion,
      this.forceUpdateVersionNo,
      this.needForceUpdate,
      this.downloadURL,
      this.buildHaveNewVersion,
      this.buildVersionNo,
      this.buildVersion,
      this.buildUpdateDescription,
      this.appKey,
      this.buildKey,
      this.buildName,
      this.buildIcon,
      this.buildFileKey,
      this.buildFileSize});

  UpgradeInfoV2.fromJson(Map<String, dynamic> json) {
    buildBuildVersion = json['buildBuildVersion'];
    forceUpdateVersion = json['forceUpdateVersion'];
    forceUpdateVersionNo = json['forceUpdateVersionNo'];
    needForceUpdate = json['needForceUpdate'];
    downloadURL = json['downloadURL'];
    buildHaveNewVersion = json['buildHaveNewVersion'];
    buildVersionNo = json['buildVersionNo'];
    buildVersion = json['buildVersion'];
    buildUpdateDescription = json['buildUpdateDescription'];
    appKey = json['appKey'];
    buildKey = json['buildKey'];
    buildName = json['buildName'];
    buildIcon = json['buildIcon'];
    buildFileKey = json['buildFileKey'];
    buildFileSize = json['buildFileSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buildBuildVersion'] = this.buildBuildVersion;
    data['forceUpdateVersion'] = this.forceUpdateVersion;
    data['forceUpdateVersionNo'] = this.forceUpdateVersionNo;
    data['needForceUpdate'] = this.needForceUpdate;
    data['downloadURL'] = this.downloadURL;
    data['buildHaveNewVersion'] = this.buildHaveNewVersion;
    data['buildVersionNo'] = this.buildVersionNo;
    data['buildVersion'] = this.buildVersion;
    data['buildUpdateDescription'] = this.buildUpdateDescription;
    data['appKey'] = this.appKey;
    data['buildKey'] = this.buildKey;
    data['buildName'] = this.buildName;
    data['buildIcon'] = this.buildIcon;
    data['buildFileKey'] = this.buildFileKey;
    data['buildFileSize'] = this.buildFileSize;
    return data;
  }
}
