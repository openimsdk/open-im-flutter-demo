import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:openim_common/openim_common.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/controller/app_controller.dart';
import '../../core/controller/im_controller.dart';
import '../../core/im_callback.dart';
import '../../routes/app_navigator.dart';
import '../../widgets/screen_lock_title.dart';

class HomeLogic extends SuperController {
  final pushLogic = Get.find<PushController>();
  final imLogic = Get.find<IMController>();
  final cacheLogic = Get.find<CacheController>();
  final initLogic = Get.find<AppController>();
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final unhandledFriendApplicationCount = 0.obs;
  final unhandledGroupApplicationCount = 0.obs;
  final unhandledCount = 0.obs;
  String? _lockScreenPwd;
  bool _isShowScreenLock = false;
  bool? _isAutoLogin;
  final auth = LocalAuthentication();
  final _errorController = PublishSubject<String>();
  var conversationsAtFirstPage = <ConversationInfo>[];

  Function()? onScrollToUnreadMessage;

  switchTab(index) {
    this.index.value = index;
  }

  scrollToUnreadMessage() {
    onScrollToUnreadMessage?.call();
  }

  _getUnreadMsgCount() {
    OpenIM.iMManager.conversationManager.getTotalUnreadMsgCount().then((count) {
      unreadMsgCount.value = int.tryParse(count) ?? 0;
      initLogic.showBadge(unreadMsgCount.value);
    });
  }

  void getUnhandledFriendApplicationCount() async {
    var i = 0;
    var list = await OpenIM.iMManager.friendshipManager.getFriendApplicationListAsRecipient();
    var haveReadList = DataSp.getHaveReadUnHandleFriendApplication();
    haveReadList ??= <String>[];
    for (var info in list) {
      var id = IMUtils.buildFriendApplicationID(info);
      if (!haveReadList.contains(id)) {
        if (info.handleResult == 0) i++;
      }
    }
    unhandledFriendApplicationCount.value = i;
    unhandledCount.value = unhandledGroupApplicationCount.value + i;
  }

  void getUnhandledGroupApplicationCount() async {
    var i = 0;
    var list = await OpenIM.iMManager.groupManager.getGroupApplicationListAsRecipient();
    var haveReadList = DataSp.getHaveReadUnHandleGroupApplication();
    haveReadList ??= <String>[];
    for (var info in list) {
      var id = IMUtils.buildGroupApplicationID(info);
      if (!haveReadList.contains(id)) {
        if (info.handleResult == 0) i++;
      }
    }
    unhandledGroupApplicationCount.value = i;
    unhandledCount.value = unhandledFriendApplicationCount.value + i;
  }

  @override
  void onInit() {
    _isAutoLogin = Get.arguments != null ? Get.arguments['isAutoLogin'] : false;
    if (_isAutoLogin == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showLockScreenPwd());
    }
    if (Get.arguments != null) {
      conversationsAtFirstPage = Get.arguments['conversations'] ?? [];
    }
    imLogic.unreadMsgCountEventSubject.listen((value) {
      unreadMsgCount.value = value;
    });
    imLogic.friendApplicationChangedSubject.listen((value) {
      getUnhandledFriendApplicationCount();
    });
    imLogic.groupApplicationChangedSubject.listen((value) {
      getUnhandledGroupApplicationCount();
    });

    imLogic.imSdkStatusPublishSubject.listen((value) {
      if (value.status == IMSdkStatus.syncStart) {
        _getRTCInvitationStart();
      }
    });

    Apis.kickoffController.stream.listen((event) {
      DataSp.removeLoginCertificate();
      PushController.logout();
      AppNavigator.startLogin();
    });
    super.onInit();
  }

  @override
  void onReady() {
    _getRTCInvitationStart();
    _getUnreadMsgCount();
    getUnhandledFriendApplicationCount();
    getUnhandledGroupApplicationCount();
    cacheLogic.initCallRecords();
    cacheLogic.initFavoriteEmoji();
    super.onReady();
  }

  @override
  void onClose() {
    _errorController.close();
    super.onClose();
  }

  _localAuth() async {
    final didAuthenticate = await IMUtils.checkingBiometric(auth);
    if (didAuthenticate) {
      Get.back();
    }
  }

  _showLockScreenPwd() async {
    if (_isShowScreenLock) return;
    _lockScreenPwd = DataSp.getLockScreenPassword();
    if (null != _lockScreenPwd) {
      final isEnabledBiometric = DataSp.isEnabledBiometric() == true;
      bool enabled = false;
      if (isEnabledBiometric) {
        final isSupportedBiometrics = await auth.isDeviceSupported();
        final canCheckBiometrics = await auth.canCheckBiometrics;
        enabled = isSupportedBiometrics && canCheckBiometrics;
      }
      _isShowScreenLock = true;
      screenLock(
        context: Get.context!,
        correctString: _lockScreenPwd!,
        maxRetries: 3,
        title: ScreenLockTitle(stream: _errorController.stream),
        canCancel: false,
        customizedButtonChild: enabled ? const Icon(Icons.fingerprint) : null,
        customizedButtonTap: enabled ? () async => await _localAuth() : null,
        onUnlocked: () {
          _isShowScreenLock = false;
          Get.back();
        },
        onMaxRetries: (_) async {
          Get.back();
          await LoadingView.singleton.wrap(asyncFunction: () async {
            await imLogic.logout();
            await DataSp.removeLoginCertificate();
            await DataSp.clearLockScreenPassword();
            await DataSp.closeBiometric();
            PushController.logout();
          });
          AppNavigator.startLogin();
        },
        onError: (retries) {
          _errorController.sink.add(
            retries.toString(),
          );
        },
      );
    }
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}

  void _getRTCInvitationStart() async {}

  @override
  void onHidden() {}
}
