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
}
