import 'dart:ui';

import 'package:get/get.dart';

import 'lang/en_US.dart';
import 'lang/zh_CN.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static const fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'zh_CN': zh_CN,
      };
}

class StrRes {
  StrRes._();

  static String get welcome => 'welcome'.tr;

  static String get phoneNumber => 'phoneNumber'.tr;
  static String get userID => 'userID'.tr;

  static String get plsEnterPhoneNumber => 'plsEnterPhoneNumber'.tr;

  static String get password => 'password'.tr;

  static String get plsEnterPassword => 'plsEnterPassword'.tr;

  static String get account => 'account'.tr;

  static String get plsEnterAccount => 'plsEnterAccount'.tr;

  static String get plsEnterEmail => 'plsEnterEmail'.tr;

  static String get forgetPassword => 'forgetPassword'.tr;

  static String get verificationCodeLogin => 'verificationCodeLogin'.tr;

  static String get login => 'login'.tr;

  static String get noAccountYet => 'noAccountYet'.tr;

  static String get loginNow => 'loginNow'.tr;

  static String get registerNow => 'registerNow'.tr;

  static String get lockPwdErrorHint => 'lockPwdErrorHint'.tr;

  static String get newUserRegister => 'newUserRegister'.tr;

  static String get verificationCode => 'verificationCode'.tr;

  static String get sendVerificationCode => 'sendVerificationCode'.tr;

  static String get resendVerificationCode => 'resendVerificationCode'.tr;

  static String get verificationCodeTimingReminder => 'verificationCodeTimingReminder'.tr;

  static String get defaultVerificationCode => 'defaultVerificationCode'.tr;

  static String get plsEnterVerificationCode => 'plsEnterVerificationCode'.tr;

  static String get invitationCode => 'invitationCode'.tr;

  static String get plsEnterInvitationCode => 'plsEnterInvitationCode'.tr;

  static String get optional => 'optional'.tr;

  static String get nextStep => 'nextStep'.tr;

  static String get plsEnterRightPhone => 'plsEnterRightPhone'.tr;

  static String get plsEnterRightPhoneOrEmail => 'plsEnterRightPhoneOrEmail'.tr;

  static String get enterVerificationCode => 'enterVerificationCode'.tr;

  static String get setPassword => 'setPassword'.tr;

  static String get plsConfirmPasswordAgain => 'plsConfirmPasswordAgain'.tr;

  static String get confirmPassword => 'confirmPassword'.tr;

  static String get wrongPasswordFormat => 'wrongPasswordFormat'.tr;

  static String get plsCompleteInfo => 'plsCompleteInfo'.tr;

  static String get plsEnterYourNickname => 'plsEnterYourNickname'.tr;

  static String get setInfo => 'setInfo'.tr;

  static String get loginPwdFormat => 'loginPwdFormat'.tr;

  static String get passwordLogin => 'passwordLogin'.tr;

  static String get through => 'through'.tr;

  static String get home => 'home'.tr;

  static String get contacts => 'contacts'.tr;

  static String get workbench => 'workbench'.tr;

  static String get mine => 'mine'.tr;

  static String get draftText => 'draftText'.tr;

  static String get everyone => 'everyone'.tr;

  static String get you => 'you'.tr;

  static String get someoneMentionYou => 'someoneMentionYou'.tr;

  static String get groupAc => 'groupAc'.tr;

  static String get createGroupNtf => 'createGroupNtf'.tr;

  static String get editGroupInfoNtf => 'editGroupInfoNtf'.tr;

  static String get quitGroupNtf => 'quitGroupNtf'.tr;

  static String get invitedJoinGroupNtf => 'invitedJoinGroupNtf'.tr;

  static String get kickedGroupNtf => 'kickedGroupNtf'.tr;

  static String get joinGroupNtf => 'joinGroupNtf'.tr;

  static String get dismissGroupNtf => 'dismissGroupNtf'.tr;

  static String get transferredGroupNtf => 'transferredGroupNtf'.tr;

  static String get muteMemberNtf => 'muteMemberNtf'.tr;

  static String get muteCancelMemberNtf => 'muteCancelMemberNtf'.tr;

  static String get muteGroupNtf => 'muteGroupNtf'.tr;

  static String get muteCancelGroupNtf => 'muteCancelGroupNtf'.tr;

  static String get friendAddedNtf => 'friendAddedNtf'.tr;

  static String get openPrivateChatNtf => 'openPrivateChatNtf'.tr;

  static String get closePrivateChatNtf => 'closePrivateChatNtf'.tr;

  static String get meetingEnableVideo => 'meetingEnableVideo'.tr;

  static String get memberInfoChangedNtf => 'memberInfoChangedNtf'.tr;

  static String get unsupportedMessage => 'unsupportedMessage'.tr;

  static String get picture => 'picture'.tr;

  static String get video => 'video'.tr;

  static String get voice => 'voice'.tr;

  static String get location => 'location'.tr;

  static String get file => 'file'.tr;

  static String get carte => 'carte'.tr;

  static String get emoji => 'emoji'.tr;

  static String get chatRecord => 'chatRecord'.tr;

  static String get revokeMsg => 'revokeMsg'.tr;

  static String get aRevokeBMsg => 'aRevokeBMsg'.tr;

  static String get blockedByFriendHint => 'blockedByFriendHint'.tr;

  static String get deletedByFriendHint => 'deletedByFriendHint'.tr;

  static String get sendFriendVerification => 'sendFriendVerification'.tr;

  static String get removedFromGroupHint => 'removedFromGroupHint'.tr;

  static String get groupDisbanded => 'groupDisbanded'.tr;

  static String get search => 'search'.tr;

  static String get synchronizing => 'synchronizing'.tr;

  static String get syncFailed => 'syncFailed'.tr;

  static String get connecting => 'connecting'.tr;

  static String get connectionFailed => 'connectionFailed'.tr;

  static String get top => 'top'.tr;

  static String get cancelTop => 'cancelTop'.tr;

  static String get markHasRead => 'markHasRead'.tr;

  static String get delete => 'delete'.tr;

  static String get nPieces => 'nPieces'.tr;

  static String get online => 'online'.tr;

  static String get offline => 'offline'.tr;

  static String get phoneOnline => 'phoneOnline'.tr;

  static String get pcOnline => 'pcOnline'.tr;

  static String get webOnline => 'webOnline'.tr;

  static String get webMiniOnline => 'webMiniOnline'.tr;

  static String get upgradeFind => 'upgradeFind'.tr;

  static String get upgradeVersion => 'upgradeVersion'.tr;

  static String get upgradeDescription => 'upgradeDescription'.tr;

  static String get upgradeIgnore => 'upgradeIgnore'.tr;

  static String get upgradeLater => 'upgradeLater'.tr;

  static String get upgradeNow => 'upgradeNow'.tr;

  static String get upgradePermissionTips => 'upgradePermissionTips'.tr;

  static String get inviteYouCall => 'inviteYouCall'.tr;

  static String get rejectCall => 'rejectCall'.tr;

  static String get acceptCall => 'acceptCall'.tr;

  static String get callVoice => 'callVoice'.tr;

  static String get callVideo => 'callVideo'.tr;

  static String get sentSuccessfully => 'sentSuccessfully'.tr;

  static String get copySuccessfully => 'copySuccessfully'.tr;

  static String get day => 'day'.tr;

  static String get hour => 'hour'.tr;

  static String get hours => 'hours'.tr;

  static String get minute => 'minute'.tr;

  static String get seconds => 'seconds'.tr;

  static String get cancel => 'cancel'.tr;

  static String get determine => 'determine'.tr;

  static String get toolboxAlbum => 'toolboxAlbum'.tr;

  static String get toolboxCall => 'toolboxCall'.tr;

  static String get toolboxCamera => 'toolboxCamera'.tr;

  static String get toolboxCard => 'toolboxCard'.tr;

  static String get toolboxFile => 'toolboxFile'.tr;

  static String get toolboxLocation => 'toolboxLocation'.tr;

  static String get toolboxDirectionalMessage => 'toolboxDirectionalMessage'.tr;

  static String get send => 'send'.tr;

  static String get holdTalk => 'holdTalk'.tr;

  static String get releaseToSend => 'releaseToSend'.tr;

  static String get releaseToSendSwipeUpToCancel => 'releaseToSendSwipeUpToCancel'.tr;

  static String get liftFingerToCancelSend => 'liftFingerToCancelSend'.tr;

  static String get callDuration => 'callDuration'.tr;

  static String get cancelled => 'cancelled'.tr;

  static String get cancelledByCaller => 'cancelledByCaller'.tr;

  static String get rejectedByCaller => 'rejectedByCaller'.tr;

  static String get callTimeout => 'callTimeout'.tr;

  static String get rejected => 'rejected'.tr;

  static String get networkAnomaly => 'networkAnomaly'.tr;

  static String get forwardMaxCountHint => 'forwardMaxCountHint'.tr;

  static String get typing => 'typing'.tr;

  static String get addSuccessfully => 'addSuccessfully'.tr;

  static String get addFailed => 'addFailed'.tr;

  static String get setSuccessfully => 'setSuccessfully'.tr;

  static String get callingBusy => 'callingBusy'.tr;

  static String get groupCallHint => 'groupCallHint'.tr;

  static String get joinIn => 'joinIn'.tr;

  static String get menuCopy => 'menuCopy'.tr;

  static String get menuDel => 'menuDel'.tr;

  static String get menuForward => 'menuForward'.tr;

  static String get menuReply => 'menuReply'.tr;

  static String get menuMulti => 'menuMulti'.tr;

  static String get menuRevoke => 'menuRevoke'.tr;

  static String get menuAdd => 'menuAdd'.tr;

  static String get nMessage => 'nMessage'.tr;

  static String get plsSelectLocation => 'plsSelectLocation'.tr;

  static String get groupAudioCallHint => 'groupAudioCallHint'.tr;

  static String get groupVideoCallHint => 'groupVideoCallHint'.tr;

  static String get reEdit => 'reEdit'.tr;

  static String get download => 'download'.tr;

  static String get playSpeed => 'playSpeed'.tr;

  static String get googleMap => 'googleMap'.tr;

  static String get appleMap => 'appleMap'.tr;

  static String get baiduMap => 'baiduMap'.tr;

  static String get amapMap => 'amapMap'.tr;

  static String get tencentMap => 'tencentMap'.tr;

  static String get offlineMeetingMessage => 'offlineMeetingMessage'.tr;

  static String get offlineMessage => 'offlineMessage'.tr;

  static String get offlineCallMessage => 'offlineCallMessage'.tr;

  static String get logoutHint => 'logoutHint'.tr;

  static String get myInfo => 'myInfo'.tr;

  static String get workingCircle => 'workingCircle'.tr;

  static String get accountSetup => 'accountSetup'.tr;

  static String get aboutUs => 'aboutUs'.tr;

  static String get logout => 'logout'.tr;

  static String get qrcode => 'qrcode'.tr;

  static String get qrcodeHint => 'qrcodeHint'.tr;

  static String get favoriteFace => 'favoriteFace'.tr;

  static String get favoriteManage => 'favoriteManage'.tr;

  static String get favoriteCount => 'favoriteCount'.tr;

  static String get favoriteDel => 'favoriteDel'.tr;

  static String get hasRead => 'hasRead'.tr;

  static String get unread => 'unread'.tr;

  static String get nPersonUnRead => 'nPersonUnRead'.tr;

  static String get allRead => 'allRead'.tr;

  static String get messageRecipientList => 'messageRecipientList'.tr;

  static String get hasReadCount => 'hasReadCount'.tr;

  static String get unreadCount => 'unreadCount'.tr;

  static String get newFriend => 'newFriend'.tr;

  static String get newGroup => 'newGroup'.tr;

  static String get newGroupRequest => 'newGroupRequest'.tr;

  static String get myFriend => 'myFriend'.tr;

  static String get myGroup => 'myGroup'.tr;

  static String get add => 'add'.tr;

  static String get scan => 'scan'.tr;

  static String get scanHint => 'scanHint'.tr;

  static String get addFriend => 'addFriend'.tr;

  static String get addFriendHint => 'addFriendHint'.tr;

  static String get createGroup => 'createGroup'.tr;

  static String get createGroupHint => 'createGroupHint'.tr;

  static String get addGroup => 'addGroup'.tr;

  static String get addGroupHint => 'addGroupHint'.tr;

  static String get searchIDAddFriend => 'searchIDAddFriend'.tr;

  static String get searchIDAddGroup => 'searchIDAddGroup'.tr;

  static String get searchIDIs => 'searchIDIs'.tr;

  static String get searchPhoneIs => 'searchPhoneIs'.tr;

  static String get searchEmailIs => 'searchEmailIs'.tr;

  static String get searchNicknameIs => 'searchNicknameIs'.tr;

  static String get searchGroupNicknameIs => 'searchGroupNicknameIs'.tr;

  static String get noFoundUser => 'noFoundUser'.tr;

  static String get noFoundGroup => 'noFoundGroup'.tr;

  static String get joinGroupMethod => 'joinGroupMethod'.tr;

  static String get joinGroupDate => 'joinGroupDate'.tr;

  static String get byInviteJoinGroup => 'byInviteJoinGroup'.tr;

  static String get byIDJoinGroup => 'byIDJoinGroup'.tr;

  static String get byQrcodeJoinGroup => 'byQrcodeJoinGroup'.tr;

  static String get groupID => 'groupID'.tr;

  static String get setAsAdmin => 'setAsAdmin'.tr;

  static String get setMute => 'setMute'.tr;

  static String get organizationInfo => 'organizationInfo'.tr;

  static String get organization => 'organization'.tr;

  static String get department => 'department'.tr;

  static String get position => 'position'.tr;

  static String get personalInfo => 'personalInfo'.tr;

  static String get audioAndVideoCall => 'audioAndVideoCall'.tr;

  static String get sendMessage => 'sendMessage'.tr;

  static String get viewDynamics => 'viewDynamics'.tr;

  static String get avatar => 'avatar'.tr;

  static String get name => 'name'.tr;

  static String get nickname => 'nickname'.tr;

  static String get gender => 'gender'.tr;

  static String get englishName => 'englishName'.tr;

  static String get birthDay => 'birthDay'.tr;

  static String get tel => 'tel'.tr;

  static String get mobile => 'mobile'.tr;

  static String get email => 'email'.tr;

  static String get man => 'man'.tr;

  static String get woman => 'woman'.tr;

  static String get friendSetup => 'friendSetup'.tr;

  static String get setupRemark => 'setupRemark'.tr;

  static String get recommendToFriend => 'recommendToFriend'.tr;

  static String get addToBlacklist => 'addToBlacklist'.tr;

  static String get unfriend => 'unfriend'.tr;

  static String get areYouSureDelFriend => 'areYouSureDelFriend'.tr;

  static String get areYouSureAddBlacklist => 'areYouSureAddBlacklist'.tr;

  static String get remark => 'remark'.tr;

  static String get save => 'save'.tr;

  static String get saveSuccessfully => 'saveSuccessfully'.tr;

  static String get saveFailed => 'saveFailed'.tr;

  static String get groupVerification => 'groupVerification'.tr;

  static String get friendVerification => 'friendVerification'.tr;

  static String get sendEnterGroupApplication => 'sendEnterGroupApplication'.tr;

  static String get sendToBeFriendApplication => 'sendToBeFriendApplication'.tr;

  static String get sendSuccessfully => 'sendSuccessfully'.tr;

  static String get sendFailed => 'sendFailed'.tr;

  static String get canNotAddFriends => 'canNotAddFriends'.tr;

  static String get mutedAll => 'mutedAll'.tr;

  static String get tenMinutes => 'tenMinutes'.tr;

  static String get oneHour => 'oneHour'.tr;

  static String get twelveHours => 'twelveHours'.tr;

  static String get oneDay => 'oneDay'.tr;

  static String get custom => 'custom'.tr;

  static String get unmute => 'unmute'.tr;

  static String get youMuted => 'youMuted'.tr;

  static String get groupMuted => 'groupMuted'.tr;

  static String get notDisturbMode => 'notDisturbMode'.tr;

  static String get allowRing => 'allowRing'.tr;

  static String get allowVibrate => 'allowVibrate'.tr;

  static String get forbidAddMeToFriend => 'forbidAddMeToFriend'.tr;

  static String get blacklist => 'blacklist'.tr;

  static String get unlockSettings => 'unlockSettings'.tr;

  static String get changePassword => 'changePassword'.tr;

  static String get clearChatHistory => 'clearChatHistory'.tr;

  static String get confirmClearChatHistory => 'confirmClearChatHistory'.tr;

  static String get languageSetup => 'languageSetup'.tr;

  static String get language => 'language'.tr;

  static String get english => 'english'.tr;

  static String get chinese => 'chinese'.tr;

  static String get followSystem => 'followSystem'.tr;

  static String get blacklistEmpty => 'blacklistEmpty'.tr;

  static String get remove => 'remove'.tr;

  static String get fingerprint => 'fingerprint'.tr;

  static String get gesture => 'gesture'.tr;

  static String get biometrics => 'biometrics'.tr;

  static String get plsEnterPwd => 'plsEnterPwd'.tr;

  static String get plsEnterOldPwd => 'plsEnterOldPwd'.tr;

  static String get plsEnterNewPwd => 'plsEnterNewPwd'.tr;

  static String get plsConfirmNewPwd => 'plsConfirmNewPwd'.tr;

  static String get reset => 'reset'.tr;

  static String get oldPwd => 'oldPwd'.tr;

  static String get newPwd => 'newPwd'.tr;

  static String get confirmNewPwd => 'confirmNewPwd'.tr;

  static String get plsEnterConfirmPwd => 'plsEnterConfirmPwd'.tr;

  static String get twicePwdNoSame => 'twicePwdNoSame'.tr;

  static String get changedSuccessfully => 'changedSuccessfully'.tr;

  static String get checkNewVersion => 'checkNewVersion'.tr;

  static String get chatContent => 'chatContent'.tr;

  static String get topContacts => 'topContacts'.tr;

  static String get messageNotDisturb => 'messageNotDisturb'.tr;

  static String get messageNotDisturbHint => 'messageNotDisturbHint'.tr;

  static String get burnAfterReading => 'burnAfterReading'.tr;

  static String get timeSet => 'timeSet'.tr;

  static String get setChatBackground => 'setChatBackground'.tr;

  static String get setDefaultBackground => 'setDefaultBackground'.tr;

  static String get fontSize => 'fontSize'.tr;

  static String get little => 'little'.tr;

  static String get standard => 'standard'.tr;

  static String get big => 'big'.tr;

  static String get thirtySeconds => 'thirtySeconds'.tr;

  static String get fiveMinutes => 'fiveMinutes'.tr;

  static String get clearAll => 'clearAll'.tr;

  static String get clearSuccessfully => 'clearSuccessfully'.tr;

  static String get groupChatSetup => 'groupChatSetup'.tr;

  static String get viewAllGroupMembers => 'viewAllGroupMembers'.tr;

  static String get groupManage => 'groupManage'.tr;

  static String get myGroupMemberNickname => 'myGroupMemberNickname'.tr;

  static String get topChat => 'topChat'.tr;

  static String get muteAllMember => 'muteAllMember'.tr;

  static String get exitGroup => 'exitGroup'.tr;

  static String get dismissGroup => 'dismissGroup'.tr;

  static String get dismissGroupHint => 'dismissGroupHint'.tr;

  static String get quitGroupHint => 'quitGroupHint'.tr;

  static String get joinGroupSet => 'joinGroupSet'.tr;

  static String get allowAnyoneJoinGroup => 'allowAnyoneJoinGroup'.tr;

  static String get inviteNotVerification => 'inviteNotVerification'.tr;

  static String get needVerification => 'needVerification'.tr;

  static String get addMember => 'addMember'.tr;

  static String get delMember => 'delMember'.tr;

  static String get groupOwner => 'groupOwner'.tr;

  static String get groupAdmin => 'groupAdmin'.tr;

  static String get notAllowSeeMemberProfile => 'notAllowSeeMemberProfile'.tr;

  static String get notAllAddMemberToBeFriend => 'notAllAddMemberToBeFriend'.tr;

  static String get transferGroupOwnerRight => 'transferGroupOwnerRight'.tr;

  static String get plsEnterRightEmail => 'plsEnterRightEmail'.tr;

  static String get plsEnterRightAccount => 'plsEnterRightAccount'.tr;

  static String get groupName => 'groupName'.tr;

  static String get groupAcPermissionTips => 'groupAcPermissionTips'.tr;

  static String get plsEnterGroupAc => 'plsEnterGroupAc'.tr;

  static String get edit => 'edit'.tr;

  static String get publish => 'publish'.tr;

  static String get groupMember => 'groupMember'.tr;

  static String get selectedPeopleCount => 'selectedPeopleCount'.tr;

  static String get confirmSelectedPeople => 'confirmSelectedPeople'.tr;

  static String get confirm => 'confirm'.tr;

  static String get confirmTransferGroupToUser => 'confirmTransferGroupToUser'.tr;

  static String get removeGroupMember => 'removeGroupMember'.tr;

  static String get searchNotResult => 'searchNotResult'.tr;

  static String get groupQrcode => 'groupQrcode'.tr;

  static String get groupQrcodeHint => 'groupQrcodeHint'.tr;

  static String get approved => 'approved'.tr;

  static String get accept => 'accept'.tr;

  static String get reject => 'reject'.tr;

  static String get waitingForVerification => 'waitingForVerification'.tr;

  static String get rejectSuccessfully => 'rejectSuccessfully'.tr;

  static String get rejectFailed => 'rejectFailed'.tr;

  static String get applyJoin => 'applyJoin'.tr;

  static String get enterGroup => 'enterGroup'.tr;

  static String get applyReason => 'applyReason'.tr;

  static String get invite => 'invite'.tr;

  static String get sourceFrom => 'sourceFrom'.tr;

  static String get byMemberInvite => 'byMemberInvite'.tr;

  static String get bySearch => 'bySearch'.tr;

  static String get byScanQrcode => 'byScanQrcode'.tr;

  static String get iCreatedGroup => 'iCreatedGroup'.tr;

  static String get iJoinedGroup => 'iJoinedGroup'.tr;

  static String get nPerson => 'nPerson'.tr;

  static String get searchNotFound => 'searchNotFound'.tr;

  static String get organizationStructure => 'organizationStructure'.tr;

  static String get recentConversations => 'recentConversations'.tr;

  static String get selectAll => 'selectAll'.tr;

  static String get plsEnterGroupNameHint => 'plsEnterGroupNameHint'.tr;

  static String get completeCreation => 'completeCreation'.tr;

  static String get sendCarteConfirmHint => 'sendCarteConfirmHint'.tr;

  static String get sentSeparatelyTo => 'sentSeparatelyTo'.tr;

  static String get sentTo => 'sentTo'.tr;

  static String get leaveMessage => 'leaveMessage'.tr;

  static String get mergeForwardHint => 'mergeForwardHint'.tr;

  static String get mergeForward => 'mergeForward'.tr;

  static String get quicklyFindChatHistory => 'quicklyFindChatHistory'.tr;

  static String get notFoundChatHistory => 'notFoundChatHistory'.tr;

  static String get globalSearchAll => 'globalSearchAll'.tr;

  static String get globalSearchContacts => 'globalSearchContacts'.tr;

  static String get globalSearchGroup => 'globalSearchGroup'.tr;

  static String get globalSearchChatHistory => 'globalSearchChatHistory'.tr;

  static String get globalSearchChatFile => 'globalSearchChatFile'.tr;

  static String get relatedChatHistory => 'relatedChatHistory'.tr;

  static String get seeMoreRelatedContacts => 'seeMoreRelatedContacts'.tr;

  static String get seeMoreRelatedGroup => 'seeMoreRelatedGroup'.tr;

  static String get seeMoreRelatedChatHistory => 'seeMoreRelatedChatHistory'.tr;

  static String get seeMoreRelatedFile => 'seeMoreRelatedFile'.tr;

  static String get publishPicture => 'publishPicture'.tr;

  static String get publishVideo => 'publishVideo'.tr;

  static String get mentioned => 'mentioned'.tr;

  static String get comment => 'comment'.tr;

  static String get like => 'like'.tr;

  static String get reply => 'reply'.tr;

  static String get rollUp => 'rollUp'.tr;

  static String get fullText => 'fullText'.tr;

  static String get selectAssetsFromCamera => 'selectAssetsFromCamera'.tr;

  static String get selectAssetsFromAlbum => 'selectAssetsFromAlbum'.tr;

  static String get selectAssetsFirst => 'selectAssetsFirst'.tr;

  static String get whoCanWatch => 'whoCanWatch'.tr;

  static String get remindWhoToWatch => 'remindWhoToWatch'.tr;

  static String get public => 'public'.tr;

  static String get everyoneCanSee => 'everyoneCanSee'.tr;

  static String get partiallyVisible => 'partiallyVisible'.tr;

  static String get visibleToTheSelected => 'visibleToTheSelected'.tr;

  static String get partiallyInvisible => 'partiallyInvisible'.tr;

  static String get invisibleToTheSelected => 'invisibleToTheSelected'.tr;

  static String get private => 'private'.tr;

  static String get onlyVisibleToMe => 'onlyVisibleToMe'.tr;

  static String get selectVideoLimit => 'selectVideoLimit'.tr;

  static String get selectContactsLimit => 'selectContactsLimit'.tr;

  static String get message => 'message'.tr;

  static String get commentedYou => 'commentedYou'.tr;
  static String get commentedWho => 'commentedWho'.tr;

  static String get likedYou => 'likedYou'.tr;

  static String get mentionedYou => 'mentionedYou'.tr;
  static String get mentionedWho => 'mentionedWho'.tr;

  static String get replied => 'replied'.tr;

  static String get detail => 'detail'.tr;

  static String get totalNPicture => 'totalNPicture'.tr;

  static String get noDynamic => 'noDynamic'.tr;

  static String get callRecords => 'callRecords'.tr;

  static String get allCall => 'allCall'.tr;

  static String get missedCall => 'missedCall'.tr;

  static String get incomingCall => 'incomingCall'.tr;

  static String get outgoingCall => 'outgoingCall'.tr;

  static String get microphone => 'microphone'.tr;

  static String get speaker => 'speaker'.tr;

  static String get hangUp => 'hangUp'.tr;

  static String get pickUp => 'pickUp'.tr;

  static String get waitingCallHint => 'waitingCallHint'.tr;

  static String get waitingVoiceCallHint => 'waitingVoiceCallHint'.tr;

  static String get invitedVoiceCallHint => 'invitedVoiceCallHint'.tr;

  static String get waitingVideoCallHint => 'waitingVideoCallHint'.tr;

  static String get invitedVideoCallHint => 'invitedVideoCallHint'.tr;

  static String get waitingToAnswer => 'waitingToAnswer'.tr;

  static String get invitedYouToCall => 'invitedYouToCall'.tr;

  static String get calling => 'calling'.tr;

  static String get nPeopleCalling => 'nPeopleCalling'.tr;

  static String get busyVideoCallHint => 'busyVideoCallHint'.tr;

  static String get inviterBusyVideoCallHint => 'inviterBusyVideoCallHint'.tr;

  static String get whoInvitedVoiceCallHint => 'whoInvitedVoiceCallHint'.tr;

  static String get whoInvitedVideoCallHint => 'whoInvitedVideoCallHint'.tr;

  static String get plsInputMeetingSubject => 'plsInputMeetingSubject'.tr;

  static String get meetingStartTime => 'meetingStartTime'.tr;

  static String get meetingDuration => 'meetingDuration'.tr;

  static String get enterMeeting => 'enterMeeting'.tr;

  static String get meetingNo => 'meetingNo'.tr;

  static String get yourMeetingName => 'yourMeetingName'.tr;

  static String get plsInputMeetingNo => 'plsInputMeetingNo'.tr;

  static String get plsInputYouMeetingName => 'plsInputYouMeetingName'.tr;

  static String get meetingSubjectIs => 'meetingSubjectIs'.tr;

  static String get meetingStartTimeIs => 'meetingStartTimeIs'.tr;

  static String get meetingDurationIs => 'meetingDurationIs'.tr;

  static String get meetingHostIs => 'meetingHostIs'.tr;

  static String get meetingNoIs => 'meetingNoIs'.tr;

  static String get meetingMessageClickHint => 'meetingMessageClickHint'.tr;

  static String get meetingMessage => 'meetingMessage'.tr;

  static String get openMeeting => 'openMeeting'.tr;

  static String get didNotStart => 'didNotStart'.tr;

  static String get started => 'started'.tr;

  static String get meetingInitiatorIs => 'meetingInitiatorIs'.tr;

  static String get meetingDetail => 'meetingDetail'.tr;

  static String get meetingOrganizerIs => 'meetingOrganizerIs'.tr;

  static String get updateMeetingInfo => 'updateMeetingInfo'.tr;

  static String get cancelMeeting => 'cancelMeeting'.tr;

  static String get videoMeeting => 'videoMeeting'.tr;

  static String get joinMeeting => 'joinMeeting'.tr;

  static String get bookAMeeting => 'bookAMeeting'.tr;

  static String get quickMeeting => 'quickMeeting'.tr;

  static String get confirmTheChanges => 'confirmTheChanges'.tr;

  static String get invitesYouToVideoConference => 'invitesYouToVideoConference'.tr;

  static String get over => 'over'.tr;

  static String get meetingMute => 'meetingMute'.tr;

  static String get meetingUnmute => 'meetingUnmute'.tr;

  static String get meetingCloseVideo => 'meetingCloseVideo'.tr;

  static String get meetingOpenVideo => 'meetingOpenVideo'.tr;

  static String get meetingEndSharing => 'meetingEndSharing'.tr;

  static String get meetingShareScreen => 'meetingShareScreen'.tr;

  static String get meetingMembers => 'meetingMembers'.tr;

  static String get settings => 'settings'.tr;

  static String get leaveMeeting => 'leaveMeeting'.tr;

  static String get endMeeting => 'endMeeting'.tr;

  static String get leaveMeetingConfirmHint => 'leaveMeetingConfirmHint'.tr;

  static String get endMeetingConfirmHit => 'endMeetingConfirmHit'.tr;

  static String get meetingSettings => 'meetingSettings'.tr;

  static String get allowMembersOpenMic => 'allowMembersOpenMic'.tr;

  static String get allowMembersOpenVideo => 'allowMembersOpenVideo'.tr;

  static String get onlyHostShareScreen => 'onlyHostShareScreen'.tr;

  static String get onlyHostInviteMember => 'onlyHostInviteMember'.tr;

  static String get defaultMuteMembers => 'defaultMuteMembers'.tr;

  static String get pinThisMember => 'pinThisMember'.tr;

  static String get unpinThisMember => 'unpinThisMember'.tr;

  static String get allSeeHim => 'allSeeHim'.tr;

  static String get cancelAllSeeHim => 'cancelAllSeeHim'.tr;

  static String get muteAll => 'muteAll'.tr;

  static String get unmuteAll => 'unmuteAll'.tr;

  static String get members => 'members'.tr;

  static String get screenShare => 'screenShare'.tr;

  static String get screenShareHint => 'screenShareHint'.tr;

  static String get meetingClosedHint => 'meetingClosedHint'.tr;

  static String get meetingIsOver => 'meetingIsOver'.tr;

  static String get networkError => 'networkError'.tr;

  static String get shareSuccessfully => 'shareSuccessfully'.tr;

  static String get notFoundMinP => 'notFoundMinP'.tr;

  static String get notSendMessageNotInGroup => 'notSendMessageNotInGroup'.tr;

  static String get whoModifyGroupName => 'whoModifyGroupName'.tr;

  static String get accountWarn => 'accountWarn'.tr;

  static String get accountException => 'accountException'.tr;

  static String get tagGroup => 'tagGroup'.tr;

  static String get issueNotice => 'issueNotice'.tr;

  static String get createTagGroup => 'createTagGroup'.tr;

  static String get plsEnterTagGroupName => 'plsEnterTagGroupName'.tr;

  static String get tagGroupMember => 'tagGroupMember'.tr;

  static String get completeEdit => 'completeEdit'.tr;

  static String get emptyTagGroup => 'emptyTagGroup'.tr;

  static String get confirmDelTagGroupHint => 'confirmDelTagGroupHint'.tr;

  static String get editTagGroup => 'editTagGroup'.tr;

  static String get newBuild => 'newBuild'.tr;

  static String get receiveMember => 'receiveMember'.tr;

  static String get emptyNotification => 'emptyNotification'.tr;

  static String get notificationReceiver => 'notificationReceiver'.tr;

  static String get sendAnother => 'sendAnother'.tr;

  static String get confirmDelTagNotificationHint => 'confirmDelTagNotificationHint'.tr;

  static String get contentNotBlank => 'contentNotBlank'.tr;

  static String get plsEnterDescription => 'plsEnterDescription'.tr;

  static String get gifNotSupported => 'gifNotSupported'.tr;

  static String get lookOver => 'lookOver'.tr;

  static String get groupRequestHandled => 'groupRequestHandled'.tr;

  static String get burnAfterReadingDescription => 'burnAfterReadingDescription'.tr;

  static String get periodicallyDeleteMessage => 'periodicallyDeleteMessage'.tr;

  static String get periodicallyDeleteMessageDescription => 'periodicallyDeleteMessageDescription'.tr;

  static String get nDay => 'nDay'.tr;

  static String get nWeek => 'nWeek'.tr;

  static String get nMonth => 'nMonth'.tr;

  static String get talkTooShort => 'talkTooShort'.tr;

  static String get quoteContentBeRevoked => 'quoteContentBeRevoked'.tr;

  static String get tapTooShort => 'tapTooShort'.tr;
  static String get createGroupTips => 'createGroupTips'.tr;
  static String get likedWho => 'likedWho'.tr;
  static String get otherCallHandle => 'otherCallHandle'.tr;
  static String get uploadErrorLog => 'uploadErrorLog'.tr;
  static String get uploaded => 'uploaded'.tr;
  static String get uploadLogWithLine => 'uploadLogWithLine'.tr;
  static String get setLines => 'setLines'.tr;

  static String get sdkApiAddress => 'sdkApiAddress'.tr;
  static String get sdkWsAddress => 'sdkWsAddress'.tr;
  static String get appAddress => 'appAddress'.tr;
  static String get serverAddress => 'serverAddress'.tr;
  static String get switchToIP => 'switchToIP'.tr;
  static String get switchToDomain => 'switchToDomain'.tr;
  static String get serverSettingTips => 'serverSettingTips'.tr;
  static String get logLevel => 'logLevel'.tr;
  static String get callFail => 'callFail'.tr;
  static String get searchByPhoneAndUid => 'search_by_phone_and_uid'.tr;
  static String get specialMessage => 'special_message'.tr;
  static String get editGroupName => 'edit_group_name'.tr;
  static String get editGroupTips => 'edit_group_tips'.tr;
  static String get tokenInvalid => 'tokenInvalid'.tr;
  static String get supportsTypeHint => 'supportsTypeHint'.tr;
  static String get permissionDeniedTitle => 'permissionDeniedTitle'.tr;
  static String get permissionDeniedHint => 'permissionDeniedHint'.tr;
  static String get camera => 'camera'.tr;
  static String get gallery => 'gallery'.tr;
  static String get notification => 'notification'.tr;
  static String get externalStorage => 'externalStorage'.tr;
  static String get monday => 'monday'.tr;
  static String get tuesday => 'tuesday'.tr;
  static String get wednesday => 'wednesday'.tr;
  static String get thursday => 'thursday'.tr;
  static String get friday => 'friday'.tr;
  static String get saturday => 'saturday'.tr;
  static String get sunday => 'sunday'.tr;
  static String get participantRemovedHit => 'participantRemovedHit'.tr;
  static String get hasBeenSet => 'hasBeenSet'.tr;
  static String get lockMeeting => 'lockMeeting'.tr;
  static String get lockMeetingHint => 'lockMeetingHint'.tr;
  static String get voiceMotivation => 'voiceMotivation'.tr;
  static String get voiceMotivationHint => 'voiceMotivationHint'.tr;
  static String get meetingIsLocked => 'meetingIsLocked'.tr;
  static String get today => 'today'.tr;
  static String get meetingIsEnded => 'meetingIsEnded'.tr;
  static String get oneXnViews => 'oneXnViews'.tr;
  static String get twoXtwoViews => 'twoXtwoViews'.tr;
  static String get threeXthreeViews => 'threeXthreeViews'.tr;
  static String get appointNewHost => 'appointNewHost'.tr;
  static String get appointNewHostHint => 'appointNewHostHint'.tr;
  static String get gridView => 'gridView'.tr;
  static String get gridViewHint => 'gridViewHint'.tr;
  static String get requestXDoHint => 'requestXDoHint'.tr;
  static String get keepClose => 'keepClose'.tr;
  static String get cancelMeetingConfirmHit => 'cancelMeetingConfirmHit'.tr;
  static String get iKnew => 'iKnew'.tr;
  static String get assignAndLeave => 'assignAndLeave'.tr;
  static String get muteAllHint => 'muteAllHint'.tr;
  static String get inProgressByTerminalHint => 'inProgressByTerminalHint'.tr;
  static String get restore => 'restore'.tr;
  static String get done => 'done'.tr;
  static String get networkNotStable => 'networkNotStable'.tr;
  static String get otherNetworkNotStableHint => 'otherNetworkNotStableHint'.tr;
  static String get callingInterruption => 'callingInterruption'.tr;
  static String get meeting => 'meeting'.tr;
  static String get directedTo => 'directedTo'.tr;
}
