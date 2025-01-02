import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:openim_common/openim_common.dart';

class UnlockSetupLogic extends GetxController {
  final passwordEnabled = false.obs;
  final fingerprintEnabled = false.obs;
  final gestureEnabled = false.obs;
  final biometricsEnabled = false.obs;
  final isSupportedBiometric = false.obs;
  final canCheckBiometrics = false.obs;
  String? lockScreenPwd;
  final auth = LocalAuthentication();
  late List<BiometricType> availableBiometrics;

  @override
  void onInit() {
    checkingSupported();
    lockScreenPwd = DataSp.getLockScreenPassword();
    biometricsEnabled.value = DataSp.isEnabledBiometric() == true;
    passwordEnabled.value = lockScreenPwd != null;
    super.onInit();
  }

  void checkingSupported() async {
    isSupportedBiometric.value = await auth.isDeviceSupported();
    canCheckBiometrics.value = await auth.canCheckBiometrics;
    availableBiometrics = await auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {}

    if (availableBiometrics.contains(BiometricType.strong) || availableBiometrics.contains(BiometricType.weak)) {}
  }

  void toggleBiometricLock() async {
    if (biometricsEnabled.value) {
      await DataSp.closeBiometric();
      biometricsEnabled.value = false;
    } else {
      final didAuthenticate = await IMUtils.checkingBiometric(auth);
      if (didAuthenticate) {
        await DataSp.openBiometric();
        biometricsEnabled.value = true;
      }
    }
  }

  void togglePwdLock() {
    if (passwordEnabled.value) {
      closePwdLock();
    } else {
      openPwdLock();
    }
  }

  void closePwdLock() {
    screenLock(
      context: Get.context!,
      correctString: lockScreenPwd!,
      title: StrRes.plsEnterPwd.toText..style = Styles.ts_FFFFFF_17sp,
      onUnlocked: () async {
        await DataSp.clearLockScreenPassword();
        await DataSp.closeBiometric();
        passwordEnabled.value = false;
        biometricsEnabled.value = false;
        Get.back();
      },
    );
  }

  void openPwdLock() {
    final controller = InputController();
    screenLockCreate(
      context: Get.context!,
      inputController: controller,
      title: StrRes.plsEnterNewPwd.toText..style = Styles.ts_FFFFFF_17sp,
      confirmTitle: StrRes.plsConfirmNewPwd.toText..style = Styles.ts_FFFFFF_17sp,
      cancelButton: StrRes.cancel.toText..style = Styles.ts_FFFFFF_17sp,
      onConfirmed: (matchedText) async {
        lockScreenPwd = matchedText;
        await DataSp.putLockScreenPassword(matchedText);
        passwordEnabled.value = true;
        Get.back();
      },
      footer: TextButton(
        onPressed: () {
          controller.unsetConfirmed();
        },
        child: StrRes.reset.toText..style = Styles.ts_0089FF_17sp,
      ),
    );
  }
}
