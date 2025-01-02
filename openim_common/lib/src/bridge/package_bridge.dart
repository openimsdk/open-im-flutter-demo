import 'package:flutter/material.dart';

class PackageBridge {
  PackageBridge._();

  static SelectContactsBridge? selectContactsBridge;
  static ViewUserProfileBridge? viewUserProfileBridge;
  static OrganizationMultiSelBridge? organizationBridge;
  static ScanBridge? scanBridge;
  static RTCBridge? rtcBridge;
}

abstract class ScanBridge {
  scanOutUserID(String userID);

  scanOutGroupID(String groupID);
}

abstract class OrganizationMultiSelBridge {
  Widget get checkedConfirmView;

  bool get isMultiModel;

  bool isChecked(dynamic info);

  bool isDefaultChecked(dynamic info);

  Function()? onTap(dynamic info);

  toggleChecked(dynamic info);

  removeItem(dynamic info);

  updateDefaultCheckedList(List<String> userIDList);
}

abstract class ViewUserProfileBridge {
  viewUserProfile(
    String userID,
    String? nickname,
    String? faceURL, [
    String? groupID,
  ]);
}

abstract class SelectContactsBridge {
  Future<T?>? selectContacts<T>(
    int type, {
    List<String>? defaultCheckedIDList,
    List<dynamic>? checkedList,
    List<String>? excludeIDList,
    bool openSelectedSheet = false,
    String? groupID,
    String? ex,
  });
}

abstract class RTCBridge {
  bool get hasConnection;
  void dismiss();
}

class GetTags {
  static final List<String> _chatTags = <String>[];
  static final List<String> _momentsTags = <String>[];
  static final List<String> _userMomentsTags = <String>[];
  static final List<String> _momentsDetailTags = <String>[];
  static final List<String> _userProfileTags = <String>[];

  static void createChatTag() {
    _chatTags.add('_${DateTime.now().millisecondsSinceEpoch}');
  }

  static void createMomentsTag() {
    _momentsTags.add('_${DateTime.now().millisecondsSinceEpoch}');
  }

  static void createUserMomentsTag() {
    _userMomentsTags.add('_${DateTime.now().millisecondsSinceEpoch}');
  }

  static void createMomentsDetailTag() {
    _momentsDetailTags.add('_${DateTime.now().millisecondsSinceEpoch}');
  }

  static void createUserProfileTag() {
    _userProfileTags.add('_${DateTime.now().millisecondsSinceEpoch}');
  }

  static void destroyChatTag() {
    _chatTags.removeLast();
  }

  static void destroyMomentsTag() {
    _momentsTags.removeLast();
  }

  static void destroyUserMomentsTag() {
    _userMomentsTags.removeLast();
  }

  static void destroyMomentsDetailTag() {
    _momentsDetailTags.removeLast();
  }

  static void destroyUserProfileTag() {
    _userProfileTags.removeLast();
  }

  static String? get chat => _chatTags.isNotEmpty ? _chatTags.last : null;

  static String get moments => _momentsTags.last;

  static String get userMoments => _userMomentsTags.last;

  static String get momentsDetail => _momentsDetailTags.last;

  static String get userProfile => _userProfileTags.last;
}
