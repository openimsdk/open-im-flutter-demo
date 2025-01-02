import 'dart:convert';

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
  String? appURl;

  UpgradeInfoV2({
    this.buildBuildVersion,
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
    this.buildFileSize,
    this.appURl,
  });

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
    appURl = json['appURl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['buildBuildVersion'] = buildBuildVersion;
    data['forceUpdateVersion'] = forceUpdateVersion;
    data['forceUpdateVersionNo'] = forceUpdateVersionNo;
    data['needForceUpdate'] = needForceUpdate;
    data['downloadURL'] = downloadURL;
    data['buildHaveNewVersion'] = buildHaveNewVersion;
    data['buildVersionNo'] = buildVersionNo;
    data['buildVersion'] = buildVersion;
    data['buildUpdateDescription'] = buildUpdateDescription;
    data['appKey'] = appKey;
    data['buildKey'] = buildKey;
    data['buildName'] = buildName;
    data['buildIcon'] = buildIcon;
    data['buildFileKey'] = buildFileKey;
    data['buildFileSize'] = buildFileSize;
    data['appURl'] = appURl;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
