import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/widgets/app_view.dart';
import 'package:rxdart/rxdart.dart';

class IMCallback {
  // Function(UserInfo u)? onSelfInfoUpdated;
  // Function(List<ConversationInfo> list)? onConversationChanged;
  // Function(List<ConversationInfo> list)? onNewConversation;
  Function(String msgId)? onRecvMessageRevoked;
  Function(List<HaveReadInfo> list)? onRecvC2CReadReceipt;
  Function(String msgId, int progress)? onMsgSendProgress;
  Function(Message msg)? onRecvNewMessage;

  Function(UserInfo u)? onBlackListAdd;
  Function(UserInfo u)? onBlackListDeleted;
  // Function(UserInfo u)? onFriendApplicationListAccept;
  // Function(UserInfo u)? onFriendApplicationListAdded;
  // Function(UserInfo u)? onFriendApplicationListDeleted;
  // Function(UserInfo u)? onFriendApplicationListReject;
  // Function(UserInfo u)? onFriendInfoChanged;
  // Function(UserInfo u)? onFriendListAdded;
  // Function(UserInfo u)? onFriendListDeleted;
  // Function(String gid, GroupMembersInfo op, int agreeOrReject, String opReason)?
  //     onApplicationProcessed;
  // Function(String gid)? onGroupCreated;
  // Function(String gid, GroupInfo info)? onGroupInfoChanged;
  Function(String gid, List<GroupMembersInfo> list)? onMemberEnter;
  Function(String gid, GroupMembersInfo op, List<GroupMembersInfo> list)?
      onMemberInvited;
  Function(String gid, GroupMembersInfo op, List<GroupMembersInfo> list)?
      onMemberKicked;
  Function(String gid, GroupMembersInfo info)? onMemberLeave;

  Function(String gid, GroupMembersInfo info, String opReason)?
      onReceiveJoinApplication;
  // Function(int count)? onUnreadMsgCountChanged;

  //
  var conversationAddedSubject = BehaviorSubject<List<ConversationInfo>>();
  var conversationChangedSubject = BehaviorSubject<List<ConversationInfo>>();

  // 未读消息数
  var unreadMsgCountEventSubject = BehaviorSubject<int>();

  // 好友申请列表新增
  var friendApplicationChangedSubject = BehaviorSubject<UserInfo>();

  // 好友申请列表新增
  // var friendApplicationRejectEventSubject = BehaviorSubject<UserInfo>();
  // 好友申请列表新增
  // var friendApplicationAcceptEventSubject = BehaviorSubject<UserInfo>();
  // 新增好友
  var friendAddSubject = BehaviorSubject<UserInfo>();

  // 删除好友
  var friendDelSubject = BehaviorSubject<UserInfo>();

  // 好友信息改变
  var friendInfoChangedSubject = BehaviorSubject<UserInfo>();

  // 自己信息更新
  var selfInfoUpdatedSubject = BehaviorSubject<UserInfo>();

  // 组信息更新
  var groupInfoUpdatedSubject = BehaviorSubject<GroupInfo>();

  var initializedSubject = BehaviorSubject<bool>();

  void selfInfoUpdated(UserInfo u) {
    // if (null != onSelfInfoUpdated) {
    //   onSelfInfoUpdated!(u);
    // }
    selfInfoUpdatedSubject.addSafely(u);
  }

  void recvMessageRevoked(String id) {
    if (null != onRecvMessageRevoked) {
      onRecvMessageRevoked!(id);
    }
  }

  void recvC2CReadReceipt(List<HaveReadInfo> list) {
    if (null != onRecvC2CReadReceipt) {
      onRecvC2CReadReceipt!(list);
    }
  }

  void recvNewMessage(Message msg) {
    initLogic.showNotification(msg);
    if (null != onRecvNewMessage) {
      onRecvNewMessage!(msg);
    }
  }

  void progressCallback(String msgId, int progress) {
    if (null != onMsgSendProgress) {
      onMsgSendProgress!(msgId, progress);
    }
  }

  void blackListAdd(UserInfo u) {
    if (null != onBlackListAdd) {
      onBlackListAdd!(u);
    }
  }

  void blackListDeleted(UserInfo u) {
    if (null != onBlackListDeleted) {
      onBlackListDeleted!(u);
    }
  }

  void friendApplicationListAccept(UserInfo u) {
    // if (null != onFriendApplicationListAccept) {
    //   onFriendApplicationListAccept!(u);
    // }
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendApplicationListAdded(UserInfo u) {
    // if (null != onFriendApplicationListAdded) {
    //   onFriendApplicationListAdded!(u);
    // }
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendApplicationListDeleted(UserInfo u) {
    // if (null != onFriendApplicationListDeleted) {
    //   onFriendApplicationListDeleted!(u);
    // }
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendApplicationListReject(UserInfo u) {
    // if (null != onFriendApplicationListReject) {
    //   onFriendApplicationListReject!(u);
    // }
    // friendApplicationAddSubject.addSafely(u);
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendInfoChanged(UserInfo u) {
    // if (null != onFriendInfoChanged) {
    //   onFriendInfoChanged!(u);
    // }
    friendInfoChangedSubject.addSafely(u);
  }

  void friendListAdded(UserInfo u) {
    // if (null != onFriendListAdded) {
    //   onFriendListAdded!(u);
    // }
    friendAddSubject.addSafely(u);
  }

  void friendListDeleted(u) {
    // if (null != onFriendListDeleted) {
    //   onFriendListDeleted!(u);
    // }
    friendDelSubject.addSafely(u);
  }

  void conversationChanged(List<ConversationInfo> list) {
    // if (null != onConversationChanged) {
    //   onConversationChanged!(list);
    // }
    conversationChangedSubject.addSafely(list);
  }

  void newConversation(List<ConversationInfo> list) {
    // if (null != onNewConversation) {
    //   onNewConversation!(list);
    // }
    conversationAddedSubject.addSafely(list);
  }

  void applicationProcessed(String groupId, GroupMembersInfo opUser,
      int agreeOrReject, String opReason) {
    // if (null != onApplicationProcessed) {
    //   onApplicationProcessed!(groupId, opUser, agreeOrReject, opReason);
    // }
  }

  void groupCreated(String groupId) {
    // if (null != onGroupCreated) {
    //   onGroupCreated!(groupId);
    // }
  }

  void groupInfoChanged(String groupId, GroupInfo info) {
    // if (null != onGroupInfoChanged) {
    //   onGroupInfoChanged!(groupId, info);
    // }
    groupInfoUpdatedSubject.addSafely(info);
  }

  void memberEnter(String groupId, List<GroupMembersInfo> list) {
    if (null != onMemberEnter) {
      onMemberEnter!(groupId, list);
    }
  }

  void memberInvited(
      String groupId, GroupMembersInfo opUser, List<GroupMembersInfo> list) {
    if (null != onMemberInvited) {
      onMemberInvited!(groupId, opUser, list);
    }
  }

  void memberKicked(
      String groupId, GroupMembersInfo opUser, List<GroupMembersInfo> list) {
    if (null != onMemberKicked) {
      onMemberKicked!(groupId, opUser, list);
    }
  }

  void memberLeave(String groupId, GroupMembersInfo info) {
    if (null != onMemberLeave) {
      onMemberLeave!(groupId, info);
    }
  }

  void receiveJoinApplication(
      String groupId, GroupMembersInfo info, String opReason) {
    if (null != onReceiveJoinApplication) {
      onReceiveJoinApplication!(groupId, info, opReason);
    }
  }

  void totalUnreadMsgCountChanged(int count) {
    // if (null != onUnreadMsgCountChanged) {
    //   onUnreadMsgCountChanged!(count);
    // }
    initLogic.showBadge(count);
    unreadMsgCountEventSubject.addSafely(count);
  }

  void close() {
    initializedSubject.close();
    friendApplicationChangedSubject.close();
    friendAddSubject.close();
    friendDelSubject.close();
    friendInfoChangedSubject.close();
    selfInfoUpdatedSubject.close();
    groupInfoUpdatedSubject.close();
    conversationAddedSubject.close();
    conversationChangedSubject.close();
  }

  final initLogic = Get.find<AppInitLogic>();
}
