import 'dart:ui';

import 'package:get/get.dart';
import 'package:openim_demo/src/res/lang/en_US.dart';
import 'package:openim_demo/src/res/lang/zh_CN.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static final fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'zh_CN': zh_CN,
      };
}

class StrRes {
  static get welcomeUse => 'welcomeUse'.tr;

  static get phoneNum => 'phoneNum'.tr;

  static get plsInputPhone => 'plsInputPhone'.tr;

  static get pwd => 'pwd'.tr;

  static get plsInputPwd => 'plsInputPwd'.tr;

  static get forgetPwd => 'forgetPwd'.tr;

  static get newUserRegister => 'newUserRegister'.tr;

  static get login => 'login'.tr;

  static get iReadAgree => 'iReadAgree'.tr;

  static get serviceAgreement => 'serviceAgreement'.tr;

  static get privacyPolicy => 'privacyPolicy'.tr;

  static get phoneOrPwdIsEmpty => 'phoneOrPwdIsEmpty'.tr;

  static get phoneOrPwdIsError => 'phoneOrPwdIsError'.tr;

  static get nowRegister => 'nowRegister'.tr;

  static get verifyCodeSentToPhone => 'verifyCodeSentToPhone'.tr;

  static get plsInputCode => 'plsInputCode'.tr;

  static get after => 'after'.tr;

  static get resendVerifyCode => 'resendVerifyCode'.tr;

  static get sendVerifyCode => 'sendVerifyCode'.tr;

  static get plsSetupPwd => 'plsSetupPwd'.tr;

  static get pwdExplanation => 'pwdExplanation'.tr;

  static get pwdRule => 'pwdRule'.tr;

  static get nextStep => 'nextStep'.tr;

  static get plsFullSelfInfo => 'plsFullSelfInfo'.tr;

  static get clickUpdateAvatar => 'clickUpdateAvatar'.tr;

  static get yourName => 'yourName'.tr;

  static get plsWriteRealName => 'plsWriteRealName'.tr;

  static get enterApp => 'enterApp'.tr;

  static get home => 'home'.tr;

  static get contacts => 'contacts'.tr;

  static get mine => 'mine'.tr;

  static get search => 'search'.tr;

  static get top => 'top'.tr;

  static get cancelTop => 'cancelTop'.tr;

  static get remove => 'remove'.tr;

  static get markRead => 'markRead'.tr;

  static get album => 'album'.tr;

  static get camera => 'camera'.tr;

  static get videoCall => 'videoCall'.tr;

  static get location => 'location'.tr;

  static get file => 'file'.tr;

  static get carte => 'carte'.tr;

  static get voiceInput => 'voiceInput'.tr;

  static get haveRead => 'haveRead'.tr;

  static get unread => 'unread'.tr;

  static get copy => 'copy'.tr;

  static get delete => 'delete'.tr;

  static get forward => 'forward'.tr;

  static get reply => 'reply'.tr;

  static get revoke => 'revoke'.tr;

  static get multiChoice => 'multiChoice'.tr;

  static get translation => 'translation'.tr;

  static get download => 'download'.tr;

  static get chatSetup => 'chatSetup'.tr;

  static get findChatHistory => 'findChatHistory'.tr;

  static get picture => 'picture'.tr;

  static get video => 'video'.tr;

  static get voice => 'voice'.tr;

  static get topContacts => 'topContacts'.tr;

  static get notDisturb => 'notDisturb'.tr;

  static get complaint => 'complaint'.tr;

  static get clearHistory => 'clearHistory'.tr;

  static get selectByFriends => 'selectByFriends'.tr;

  static get selectByGroup => 'selectByGroup'.tr;

  static get selectByTag => 'selectByTag'.tr;

  static get selectByGroupChat => 'selectByGroupChat'.tr;

  static get draftText => 'draftText'.tr;

  static get you => 'you'.tr;

  static get revokeMsg => 'revokeMsg'.tr;

  static get cancel => 'cancel'.tr;

  static get mergeForward => 'mergeForward'.tr;

  static get confirmSendTo => 'confirmSendTo'.tr;

  static get confirmSendCarte => 'confirmSendCarte'.tr;

  static get send => 'send'.tr;

  static get chatRecord => 'chatRecord'.tr;

  static get callVoice => 'callVoice'.tr;

  static get callVideo => 'callVideo'.tr;

  static get waitingAcceptVoiceCall => 'waitingAcceptVoiceCall'.tr;

  static get beInvitedVoiceCall => 'beInvitedVoiceCall'.tr;

  static get waitingAcceptVideoCall => 'waitingAcceptVideoCall'.tr;

  static get beInvitedVideoCall => 'beInvitedVideoCall'.tr;

  static get convertVoice => 'convertVoice'.tr;

  static get switchCamera => 'switchCamera'.tr;

  static get hangup => 'hangup'.tr;

  static get pickup => 'pickup'.tr;

  static get refuse => 'refuse'.tr;

  static get micOpen => 'micOpen'.tr;

  static get micClose => 'micClose'.tr;

  static get speakerOpen => 'speakerOpen'.tr;

  static get speakerClose => 'speakerClose'.tr;

  static get newFriend => 'newFriend'.tr;

  static get myFriend => 'myFriend'.tr;

  static get myGroup => 'myGroup'.tr;

  static get oftenContacts => 'oftenContacts'.tr;

  static get add => 'add'.tr;

  static get createAndJoinGroup => 'createAndJoinGroup'.tr;

  static get createGroup => 'createGroup'.tr;

  static get createGroupDescribe => 'createGroupDescribe'.tr;

  static get joinGroup => 'joinGroup'.tr;

  static get joinGroupDescribe => 'joinGroupDescribe'.tr;

  static get addFriend => 'addFriend'.tr;

  static get addGroup => 'addGroup'.tr;

  static get searchDescribe => 'searchDescribe'.tr;

  static get scan => 'scan'.tr;

  static get scanDescribe => 'scanDescribe'.tr;

  static get newFriendApplication => 'newFriendApplication'.tr;

  static get accept => 'accept'.tr;

  static get greet => 'greet'.tr;

  static get addSuccessfully => 'addSuccessfully'.tr;

  static get addFailed => 'addFailed'.tr;

  static get searchFriend => 'searchFriend'.tr;

  static get myInfo => 'myInfo'.tr;

  static get newsNotify => 'newsNotify'.tr;

  static get accountSetup => 'accountSetup'.tr;

  static get aboutUs => 'aboutUs'.tr;

  static get logout => 'logout'.tr;

  static get copySuccessfully => 'copySuccessfully'.tr;

  static get qrcode => 'qrcode'.tr;

  static get qrcodeTips => 'qrcodeTips'.tr;

  static get remark => 'remark'.tr;

  static get idCode => 'idCode'.tr;

  static get recommendToFriends => 'recommendToFriends'.tr;

  static get addBlacklist => 'addBlacklist'.tr;

  static get relieveRelationship => 'relieveRelationship'.tr;

  static get sendMsg => 'sendMessage'.tr;

  static get appCall => 'appCall'.tr;

  static get launchGroup => 'launchGroup'.tr;

  static get myQrcode => 'myQrcode'.tr;

  static get inviteScan => 'inviteScan'.tr;

  static get scanQrcodeCarte => 'scanQrcodeCarte'.tr;

  static get searchFriendNoResult => 'searchFriendNoResult'.tr;

  static get searchPrefix => 'searchPrefix'.tr;

  static get notAddSelf => 'notAddSelf'.tr;

  static get friendVerify => 'friendVerify'.tr;

  static get sendFriendRequest => 'sendFriendRequest'.tr;

  static get remarkName => 'remarkName'.tr;

  static get sendSuccessfully => 'sendSuccessfully'.tr;

  static get sendFailed => 'sendFailed'.tr;

  static get friendRequests => 'friendRequests'.tr;

  static get acceptFriendRequests => 'acceptFriendRequests'.tr;

  static get setupRemark => 'setupRemark'.tr;

  static get remarkNotEmpty => 'remarkNotEmpty'.tr;

  static get save => 'save'.tr;

  static get saveSuccessfully => 'saveSuccessfully'.tr;

  static get saveFailed => 'saveFailed'.tr;

  static get see => 'see'.tr;

  static get seeAllFriendRequests => 'seeAllFriendRequests'.tr;

  static get areYouSureDelFriend => 'areYouSureDelFriend'.tr;

  static get areYouSureAddBlacklist => 'areYouSureAddBlacklist'.tr;

  static get areYouSureClearAllHistory => 'areYouSureClearAllHistory'.tr;

  static get sure => 'sure'.tr;

  static get clearAll => 'clearAll'.tr;

  static get selectedNum => 'selectedNum'.tr;

  static get confirmNum => 'confirmNum'.tr;

  static get createGroupNameHint => 'createGroupNameHint'.tr;

  static get groupMember => 'groupMember'.tr;

  static get completeCreation => 'completeCreation'.tr;

  static get xPerson => 'xPerson'.tr;

  static get avatar => 'avatar'.tr;

  static get nickname => 'nickname'.tr;

  static get qrcodeCarte => 'qrcodeCarte'.tr;

  static get setupNickname => 'setupNickname'.tr;

  static get groupSetup => 'groupSetup'.tr;

  static get groupName => 'groupName'.tr;

  static get groupAnnouncement => 'groupAnnouncement'.tr;

  static get groupPermissionTransfer => 'groupPermissionTransfer'.tr;

  static get myNicknameInGroup => 'myNicknameInGroup'.tr;

  static get groupQrcode => 'groupQrcode'.tr;

  static get groupIDCode => 'groupIDCode'.tr;

  static get seeChatHistory => 'seeChatHistory'.tr;

  static get chatTop => 'chatTop'.tr;

  static get quitGroup => 'quitGroup'.tr;

  static get modifyGroupName => 'modifyGroupName'.tr;

  static get modifyGroupNameHint => 'modifyGroupNameHint'.tr;

  static get finished => 'finished'.tr;

  static get plsEditGroupAnnouncement => 'plsEditGroupAnnouncement'.tr;

  static get groupQrcodeTips => 'groupQrcodeTips'.tr;

  static get groupIDTips => 'groupIDTips'.tr;

  static get copyGroupID => 'copyGroupID'.tr;

  static get modifyGroupUserNicknameHint => 'modifyGroupUserNicknameHint'.tr;

  static get confirmDelMember => 'confirmDelMember'.tr;

  static get confirmTransferGroupToUser => 'confirmTransferGroupToUser'.tr;

  static get quitGroupHint => 'quitGroupHint'.tr;

  static get quitGroupTransferPermissionHint =>
      'quitGroupTransferPermissionHint'.tr;

  static get searchGroupHint => 'searchGroupHint'.tr;

  static get iCreateGroup => 'iCreateGroup'.tr;

  static get iJoinGroup => 'iJoinGroup'.tr;

  static get scanQrcodeJoin => 'scanQrcodeJoin'.tr;

  static get scanQrCodeJoinHint => 'scanQrCodeJoinHint'.tr;

  static get idCodeJoin => 'idCodeJoin'.tr;

  static get idCodeJoinHint => 'idCodeJoinHint'.tr;

  static get confirmLogout => 'confirmLogout'.tr;

  static get notDisturbModel => 'notDisturbModel'.tr;

  static get enableRing => 'enableRing'.tr;

  static get enableVibration => 'enableVibration'.tr;

  static get addMyMethod => 'addMyMethod'.tr;

  static get blacklist => 'blacklist'.tr;

  static get addMyMethodHint => 'addMyMethodHint'.tr;

  static get blacklistHint => 'blacklistHint'.tr;

  static get removeBlacklistHint => 'removeBlacklistHint'.tr;

  static get goToRate => 'goToRate'.tr;

  static get checkVersion => 'checkVersion'.tr;

  static get newFuncIntroduction => 'newFuncIntroduction'.tr;

  static get appServiceAgreement => 'appServiceAgreement'.tr;

  static get appPrivacyPolicy => 'appPrivacyPolicy'.tr;

  static get copyrightInformation => 'copyrightInformation'.tr;

  static get confirmRecommendFriend => 'confirmRecommendFriend'.tr;

  static get callConnecting => 'callConnecting'.tr;

  static get call => 'call'.tr;

  static get allCall => 'allCall'.tr;

  static get missedCall => 'missedCall'.tr;

  static get incomingCall => 'incomingCall'.tr;

  static get outgoingCall => 'outgoingCall'.tr;

  static get groupCallVideoInvite => 'groupCallVideoInvite'.tr;

  static get groupCallVoiceInvite => 'groupCallVoiceInvite'.tr;

  static get xPersonGroupVideoCalling => 'xPersonGroupVideoCalling'.tr;

  static get xPersonGroupVoiceCalling => 'xPersonGroupVoiceCalling'.tr;

  static get languageSetup => 'languageSetup'.tr;

  static get language => 'language'.tr;

  static get english => 'english'.tr;

  static get chinese => 'chinese'.tr;

  static get followSystem => 'followSystem'.tr;

  static get typing => 'typing'.tr;

  static get startDownload => 'startDownload'.tr;

  static get fileSaveToPath => 'fileSaveToPath'.tr;

  static get picSaveToPath => 'picSaveToPath'.tr;

  static get videoSaveToPath => 'videoSaveToPath'.tr;

  static get callX => 'callX'.tr;

  static get sentSuccessfully => 'sentSuccessfully'.tr;

  static get onlyTheOwnerCanModify => 'onlyTheOwnerCanModify'.tr;

  static get plsInputPhoneAndPwd => 'plsInputPhoneAndPwd'.tr;

  static get plsInputRightPhone => 'plsInputRightPhone'.tr;

  static get plsUploadAvatar => 'plsUploadAvatar'.tr;

  static get nameNotEmpty => 'nameNotEmpty'.tr;

  static get pwdFormatError => 'pwdFormatError'.tr;

  static get verifyCodeError => 'verifyCodeError'.tr;

  static get email => 'email'.tr;

  static get plsInputEmail => 'plsInputEmail'.tr;

  static get phoneRegister => 'phoneRegister'.tr;

  static get emailRegister => 'emailRegister'.tr;

  static get plsInputRightEmail => 'plsInputRightEmail'.tr;

  static get verifyCodeSentToEmail => 'verifyCodeSentToEmail'.tr;

  static get clearSuccess => 'clearSuccess'.tr;

  static get googleMap => 'googleMap'.tr;

  static get appleMap => 'appleMap'.tr;

  static get baiduMap => 'baiduMap'.tr;

  static get amapMap => 'amapMap'.tr;

  static get tencentMap => 'tencentMap'.tr;

  static get upgradeFind => 'upgradeFind'.tr;

  static get upgradeVersion => 'upgradeVersion'.tr;

  static get upgradeDescription => 'upgradeDescription'.tr;

  static get upgradeIgnore => 'upgradeIgnore'.tr;

  static get upgradeLater => 'upgradeLater'.tr;

  static get upgradeNow => 'upgradeNow'.tr;

  static get notificationChannelName => 'notificationChannelName'.tr;

  static get notificationChannelDescription =>
      'notificationChannelDescription'.tr;

  static get notificationTitle => 'notificationTitle'.tr;

  static get notificationBody => 'notificationBody'.tr;

  static get serviceChannelName => 'serviceChannelName'.tr;

  static get serviceChannelDescription => 'serviceChannelDescription'.tr;

  static get serviceNotificationBody => 'serviceNotificationBody'.tr;

  static get notFindGroup => 'notFindGroup'.tr;

  static get groupIdJoin => 'groupIdJoin'.tr;

  static get groupIdJoinHint => 'groupIdJoinHint'.tr;

  static get searchUserDescribe => 'searchUserDescribe'.tr;

  static get searchGroupDescribe => 'searchGroupDescribe'.tr;

  static get applyJoin => 'applyJoin'.tr;

  static get enterGroup => 'enterGroup'.tr;

  static get enterGroupVerify => 'enterGroupVerify'.tr;

  static get enterGroupHint => 'enterGroupHint'.tr;

  static get groupApplicationNotification => 'groupApplicationNotification'.tr;

  static get applyReason => 'applyReason'.tr;

  static get approve => 'approve'.tr;

  static get approved => 'approved'.tr;

  static get rejected => 'rejected'.tr;

  static get passGroupApplication => 'passGroupApplication'.tr;

  static get rejectGroupApplication => 'rejectGroupApplication'.tr;

  static get defaultAvatar => 'defaultAvatar'.tr;

  static get welcomeHint => 'welcomeHint'.tr;

  static get noMore => 'noMore'.tr;

  static get online => 'online'.tr;

  static get offline => 'offline'.tr;

  static get phoneOnline => 'phoneOnline'.tr;

  static get pcOnline => 'pcOnline'.tr;

  static get webOnline => 'webOnline'.tr;

  static get webMiniOnline => 'webMiniOnline'.tr;

  static get blockFriends => 'blockFriends'.tr;

  static get groupMessageSettings => 'groupMessageSettings'.tr;

  static get friendMessageSettings => 'friendMessageSettings'.tr;

  static get receiveMessageButNotPrompt => 'receiveMessageButNotPrompt'.tr;

  static get blockGroupMessages => 'blockGroupMessages'.tr;

  static get accountWarn => 'accountWarn'.tr;

  static get accountException => 'accountException'.tr;

  static get inviteMember => 'inviteMember'.tr;

  static get removeMember => 'removeMember'.tr;

  static get groupOwner => 'groupOwner'.tr;

  static get groupAdmin => 'groupAdmin'.tr;

  static get announcementHint => 'announcementHint'.tr;

  static get publish => 'publish'.tr;

  static get more => 'more'.tr;

  static get iKnow => 'iKnow'.tr;

  static get workbench => 'workbench'.tr;

  static get callDuration => 'callDuration'.tr;

  static get cancelled => 'cancelled'.tr;

  static get cancelledByCaller => 'cancelledByCaller'.tr;

  static get rejectedByCaller => 'rejectedByCaller'.tr;

  static get callTimeout => 'callTimeout'.tr;

  static get unsupportedMessage => 'unsupportedMessage'.tr;

  static get gender => 'gender'.tr;

  static get birthday => 'birthday'.tr;

  static get man => 'man'.tr;

  static get woman => 'woman'.tr;

  static get personalInfo => 'personalInfo'.tr;

  static get getVerificationCode => 'getVerificationCode'.tr;

  static get setupNewPassword => 'setupNewPassword'.tr;

  static get plsInputNewPassword => 'plsInputNewPassword'.tr;

  static get confirmModify => 'confirmModify'.tr;

  static get edit => 'edit'.tr;

  static get favoriteEmoticons => 'favoriteEmoticons'.tr;

  static get manageEmoticons => 'manageEmoticons'.tr;

  static get deleteEmoticons => 'deleteEmoticons'.tr;

  static get calEmoticonsNum => 'calEmoticonsNum'.tr;

  static get completed => 'completed'.tr;

  static get burnAfterReading => 'burnAfterReading'.tr;

  static get setChatBackground => 'setChatBackground'.tr;

  static get fontSize => 'fontSize'.tr;

  static get little => 'little'.tr;

  static get standard => 'standard'.tr;

  static get big => 'big'.tr;

  static get setSuccessfully => 'setSuccessfully'.tr;

  static get face => 'face'.tr;

  static get tag => 'tag'.tr;

  static get emptyTag => 'emptyTag'.tr;

  static get newTag => 'newTag'.tr;

  static get tagName => 'tagName'.tr;

  static get tagMember => 'tagMember'.tr;

  static get plsInputTagName => 'plsInputTagName'.tr;

  static get plsSelectTagMember => 'plsSelectTagMember'.tr;

  static get confirmDeleteTag => 'confirmDeleteTag'.tr;

  static get messageReadStatus => 'messageReadStatus'.tr;

  static get assignSearchContent => 'assignSearchContent'.tr;

  static get noFoundMessage => 'noFoundMessage'.tr;

  static get thisWeek => 'thisWeek'.tr;

  static get thisMonth => 'thisMonth'.tr;

  static get dismissGroup => 'dismissGroup'.tr;

  static get dismissGroupHint => 'dismissGroupHint'.tr;

  static get mutedGroup => 'mutedGroup'.tr;

  static get setMute => 'setMute'.tr;

  static get tenMinutes => 'tenMinutes'.tr;

  static get oneHour => 'oneHour'.tr;

  static get twelveHours => 'twelveHours'.tr;

  static get oneDay => 'oneDay'.tr;

  static get custom => 'custom'.tr;

  static get day => 'day'.tr;

  static get workNotification => 'workNotification'.tr;

  static get customEmoji => 'customEmoji'.tr;

  static get createGroupNotification => 'createGroupNotification'.tr;

  static get editGroupInfoNotification => 'editGroupInfoNotification'.tr;

  static get quitGroupNotification => 'quitGroupNotification'.tr;

  static get invitedJoinGroupNotification => 'invitedJoinGroupNotification'.tr;

  static get kickedGroupNotification => 'kickedGroupNotification'.tr;

  static get joinGroupNotification => 'joinGroupNotification'.tr;

  static get dismissGroupNotification => 'dismissGroupNotification'.tr;

  static get transferredGroupNotification => 'transferredGroupNotification'.tr;

  static get muteGroupMemberNotification => 'muteGroupMemberNotification'.tr;

  static get muteCancelGroupMemberNotification =>
      'muteCancelGroupMemberNotification'.tr;

  static get muteGroupNotification => 'muteGroupNotification'.tr;

  static get muteCancelGroupNotification => 'muteCancelGroupNotification'.tr;

  static get friendAddedNotification => 'friendAddedNotification'.tr;

  static get openPrivateChatNotification => 'openPrivateChatNotification'.tr;

  static get closePrivateChatNotification => 'closePrivateChatNotification'.tr;

  static get clearChatHistory => 'clearChatHistory'.tr;

  static get organization => 'organization'.tr;

  static get selectFromAlbum => 'selectFromAlbum'.tr;

  static get recover => 'recover'.tr;

  static get confirmClearChatHistory => 'confirmClearChatHistory'.tr;

  static get groupMemberInfoChangedNotification =>
      'groupMemberInfoChangedNotification'.tr;

  static get rejectFriendRequest => 'rejectFriendRequest'.tr;

  static get rejectSuccessfully => 'rejectSuccessfully'.tr;

  static get rejectFailed => 'rejectFailed'.tr;

  static get oneMinutes => 'oneMinutes'.tr;

  static get hour => 'hour'.tr;

  static get minute => 'minute'.tr;

  static get seconds => 'seconds'.tr;

  static get scanQrLogin => 'scanQrLogin'.tr;

  static get pcLoginConfirmation => 'pcLoginConfirmation'.tr;

  static get confirmLogin => 'confirmLogin'.tr;

  static get cancelLogin => 'cancelLogin'.tr;

  static get loginSuccessful => 'loginSuccessful'.tr;

  static get loginFailed => 'loginFailed'.tr;

  static get searchAll => 'searchAll'.tr;

  static get searchContacts => 'searchContacts'.tr;

  static get searchGroup => 'searchGroup'.tr;

  static get searchChatHistory => 'searchChatHistory'.tr;

  static get searchFile => 'searchFile'.tr;

  static get seeMore => 'seeMore'.tr;

  static get relatedChatHistory => 'relatedChatHistory'.tr;

  static get groupNicknameIs => 'groupNicknameIs'.tr;

  static get joinGroupTimeIs => 'joinGroupTimeIs'.tr;

  static get noSearchResult => 'noSearchResult'.tr;

  static get organizationInformation => 'organizationInformation'.tr;

  static get businessOrOrganization => 'businessOrOrganization'.tr;

  static get department => 'department'.tr;

  static get position => 'position'.tr;

  static get viewNews => 'viewNews'.tr;

  static get moreInfo => 'moreInfo'.tr;

  static get previewFontSize => 'previewFontSize'.tr;

  static get reset => 'reset'.tr;

  static get groupNickname => 'groupNickname'.tr;

  static get joinGroupTime => 'joinGroupTime'.tr;

  static get makeAdmin => 'makeAdmin'.tr;

  static get searchFriendLabel => 'searchFriendLabel'.tr;

  static get searchDeptMemberLabel => 'searchDeptMemberLabel'.tr;

  static get friends => 'friends'.tr;

  static get colleague => 'colleague'.tr;

  static get group => 'group'.tr;

  static get toBeProcessed => 'toBeProcessed'.tr;

  static get everyone => 'everyone'.tr;

  static get inviteYouCall => 'inviteYouCall'.tr;

  static get rejectCall => 'rejectCall'.tr;

  static get acceptCall => 'acceptCall'.tr;

  static get joinGroupSet => 'joinGroupSet'.tr;

  static get allowAnyoneJoinGroup => 'allowAnyoneJoinGroup'.tr;

  static get inviteNotVerification => 'inviteNotVerification'.tr;

  static get needVerification => 'needVerification'.tr;

  static get createWorkGroup => 'createWorkGroup'.tr;

  static get groupType => 'groupType'.tr;

  static get generalGroup => 'generalGroup'.tr;

  static get workGroup => 'workGroup'.tr;

  static get groupMemberPermissions => 'groupMemberPermissions'.tr;

  static get notViewMemberProfiles => 'notViewMemberProfiles'.tr;

  static get notAddMemberToFriend => 'notAddMemberToFriend'.tr;

  static get joinGroupMethod => 'joinGroupMethod'.tr;

  static get byInviteJoinGroup => 'byInviteJoinGroup'.tr;

  static get byIDJoinGroup => 'byIDJoinGroup'.tr;

  static get byQrcodeJoinGroup => 'byQrcodeJoinGroup'.tr;

  static get groupNoticePermissionTips => 'groupNoticePermissionTips'.tr;

  static get invite => 'invite'.tr;

  static get joinIn => 'joinIn'.tr;

  static get invitationCode => 'invitationCode'.tr;

  static get workMoments => 'workMoments'.tr;

  static get momentsNewMessage => 'momentsNewMessage'.tr;

  static get momentsAtUsers => 'momentsAtUsers'.tr;

  static get loading => 'loading'.tr;

  static get message => 'message'.tr;

  static get publishGraphic => 'publishGraphic'.tr;

  static get publishVideo => 'publishVideo'.tr;

  static get whoCanView => 'whoCanView'.tr;

  static get atWhoView => 'atWhoView'.tr;

  static get momentsPublic => 'momentsPublic'.tr;

  static get momentsPublicSub => 'momentsPublicSub'.tr;

  static get momentsPrivate => 'momentsPrivate'.tr;

  static get momentsPrivateSub => 'momentsPrivateSub'.tr;

  static get momentsPart => 'momentsPart'.tr;

  static get momentsPartSub => 'momentsPartSub'.tr;

  static get momentsBlocked => 'momentsBlocked'.tr;

  static get momentsBlockedSub => 'momentsBlockedSub'.tr;

  static get momentsSelectedFromGroup => 'momentsSelectedFromGroup'.tr;

  static get momentsSelectedFromAddressBook =>
      'momentsSelectedFromAddressBook'.tr;

  static get rollUp => 'rollUp'.tr;

  static get fullText => 'fullText'.tr;

  static get comment => 'comment'.tr;

  static get manyPeopleLikeIt => 'manyPeopleLikeIt'.tr;

  static get confirmClearMessage => 'confirmClearMessage'.tr;

  static get likeYou => 'likeYou'.tr;

  static get commentYou => 'commentYou'.tr;

  static get detail => 'detail'.tr;

  static get mentionYou => 'mentionYou'.tr;

  static get note => 'note'.tr;

  static get momentsGone => 'momentsGone'.tr;

  static get momentsEmpty => 'momentsEmpty'.tr;

  static get noCameraPermission => 'noCameraPermission'.tr;

  static get forwardMaxCountTips => 'forwardMaxCountTips'.tr;

  static get noInternet => 'noInternet'.tr;

  static get connecting => 'connecting'.tr;

  static get connectingFailed => 'connectingFailed'.tr;

  static get synchronizing => 'synchronizing'.tr;

  static get syncFailed => 'syncFailed'.tr;

  static get tooManyPeopleTipsWhenCreateGroup =>
      'tooManyPeopleTipsWhenCreateGroup'.tr;

  static get justNow => 'justNow'.tr;

  static get groupAudioCallHint => 'groupAudioCallHint'.tr;

  static get groupVideoCallHint => 'groupVideoCallHint'.tr;

  static get callingBusy => 'callingBusy'.tr;

  static get groupCallForbidden => 'groupCallForbidden'.tr;

  static get launchMeeting => 'launchMeeting'.tr;

  static get joinMeeting => 'joinMeeting'.tr;

  static get plsInputMeetingSubject => 'plsInputMeetingSubject'.tr;

  static get meetingStartTime => 'meetingStartTime'.tr;

  static get meetingDuration => 'meetingDuration'.tr;

  static get enterMeeting => 'enterMeeting'.tr;

  static get meetingNo => 'meetingNo'.tr;

  static get yourMeetingName => 'yourMeetingName'.tr;

  static get plsInputMeetingNumber => 'plsInputMeetingNumber'.tr;

  static get plsInputYouMeetingName => 'plsInputYouMeetingName'.tr;

  static get meetingSubjectIs => 'meetingSubjectIs'.tr;

  static get meetingStartTimeIs => 'meetingStartTimeIs'.tr;

  static get meetingDurationIs => 'meetingDurationIs'.tr;

  static get meetingNumberIs => 'meetingNumberIs'.tr;

  static get meetingMessageClickHint => 'meetingMessageClickHint'.tr;

  static get meetingMessage => 'meetingMessage'.tr;

  static get openMeeting => 'openMeeting'.tr;

  static get didNotStart => 'didNotStart'.tr;

  static get started => 'started'.tr;

  static get meetingInitiator => 'meetingInitiator'.tr;

  static get usePwdLogin => 'usePwdLogin'.tr;

  static get useSMSLogin => 'useSMSLogin'.tr;

  static get verificationCode => 'verificationCode'.tr;

  static get plsInputVerificationCode => 'plsInputVerificationCode'.tr;

  static get unlockVerification => 'unlockVerification'.tr;

  static get password => 'password'.tr;

  static get fingerprint => 'fingerprint'.tr;

  static get gesture => 'gesture'.tr;

  static get biometrics => 'biometrics'.tr;

  static get plsEnterNewPwd => 'plsEnterNewPwd'.tr;

  static get plsEnterPwd => 'plsEnterPwd'.tr;

  static get plsConfirmNewPwd => 'plsConfirmNewPwd'.tr;

  static get resetInput => 'resetInput'.tr;

  static get forbidAddMeToFriend => 'forbidAddMeToFriend'.tr;

  static get doNotDisturbHint => 'doNotDisturbHint'.tr;

  static get lockPwdErrorHint => 'lockPwdErrorHint'.tr;

  static get notAddFriendHint => 'notAddFriendHint'.tr;

  static get gesturePwdConfirmErrorHint => 'gesturePwdConfirmErrorHint'.tr;

  static get deletedByFriendHint => 'deletedByFriendHint'.tr;

  static get blockedByFriendHint => 'blockedByFriendHint'.tr;

  static get sendFriendVerification => 'sendFriendVerification'.tr;
  static get optional => 'optional'.tr;

  static get invitationCodeNotEmpty => 'invitationCodeNotEmpty'.tr;

  static get plsInputInvitationCode => 'plsInputInvitationCode'.tr;
}
