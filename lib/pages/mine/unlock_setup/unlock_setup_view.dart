import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'unlock_setup_logic.dart';

class UnlockSetupPage extends StatelessWidget {
  final logic = Get.find<UnlockSetupLogic>();

  UnlockSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.unlockSettings),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => Column(
            children: [
              12.verticalSpace,
              _buildItemView(
                label: StrRes.password,
                switchOn: logic.passwordEnabled.value,
                onChanged: (_) => logic.togglePwdLock(),
                isTopRadius: true,
              ),
              if (logic.passwordEnabled.value &&
                  (logic.isSupportedBiometric.value &&
                      logic.canCheckBiometrics.value))
                Container(
                  margin: EdgeInsets.only(left: 26.w, right: 10.w),
                  color: Styles.c_E8EAEF,
                  height: .5,
                ),
              if (logic.passwordEnabled.value &&
                  (logic.isSupportedBiometric.value &&
                      logic.canCheckBiometrics.value))
                _buildItemView(
                  label: StrRes.biometrics,
                  switchOn: logic.biometricsEnabled.value,
                  onChanged: (_) => logic.toggleBiometricLock(),
                  isBottomRadius: true,
                ),
            ],
          )),
    );
  }

  Widget _buildItemView({
    required String label,
    bool isTopRadius = false,
    bool isBottomRadius = false,
    bool switchOn = false,
    ValueChanged<bool>? onChanged,
  }) =>
      Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTopRadius ? 6.r : 0),
            topRight: Radius.circular(isTopRadius ? 6.r : 0),
            bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
            bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
          ),
        ),
        child: Row(
          children: [
            label.toText..style = Styles.ts_0C1C33_17sp,
            const Spacer(),
            CupertinoSwitch(
              value: switchOn,
              activeColor: Styles.c_0089FF,
              onChanged: onChanged,
            ),
          ],
        ),
      );
}
