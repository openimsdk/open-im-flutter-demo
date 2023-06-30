class TagGroup {
  List<TagInfo>? tags;

  TagGroup({this.tags});

  TagGroup.fromJson(Map<String, dynamic> json) {
    if (json['tags'] != null) {
      tags = <TagInfo>[];
      json['tags'].forEach((v) {
        tags!.add(TagInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TagInfo {
  String? tagID;
  String? tagName;
  List<TagUserInfo>? users;
  int? createTime;

  TagInfo({this.tagID, this.tagName, this.users, this.createTime});

  TagInfo.fromJson(Map<String, dynamic> json) {
    tagID = json['tagID'];
    tagName = json['tagName'];
    if (json['users'] != null) {
      users = <TagUserInfo>[];
      json['users'].forEach((v) {
        users!.add(TagUserInfo.fromJson(v));
      });
    }
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tagID'] = tagID;
    data['tagName'] = tagName;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    data['createTime'] = createTime;
    return data;
  }
}

class TagUserInfo {
  String? userID;
  String? nickname;
  String? faceURL;

  TagUserInfo({this.userID, this.nickname, this.faceURL});

  TagUserInfo.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    nickname = json['nickname'];
    faceURL = json['faceURL'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['nickname'] = nickname;
    data['faceURL'] = faceURL;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagUserInfo &&
          runtimeType == other.runtimeType &&
          userID == other.userID;

  @override
  int get hashCode => userID.hashCode;
}
