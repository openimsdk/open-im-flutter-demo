import 'dart:io';

import 'package:app_installer/app_installer.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/common/apis.dart';
import 'package:openim_enterprise_chat/src/models/upgrade_info.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';
import 'package:openim_enterprise_chat/src/widgets/loading_view.dart';
import 'package:openim_enterprise_chat/src/widgets/upgrade_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';

import 'data_persistence.dart';
import 'http_util.dart';
import 'im_util.dart';

class UpgradeManger {
  PackageInfo? packageInfo;
  UpgradeInfoV2? upgradeInfoV2;
  var isShowUpgradeDialog = false;
  var isNowIgnoreUpdate = false;
  final subject = PublishSubject<double>();

  void closeSubject() {
    subject.close();
  }

  void ignoreUpdate() {
    DataPersistence.putIgnoreVersion(upgradeInfoV2!.buildVersion!);
    Get.back();
  }

  void laterUpdate() {
    isNowIgnoreUpdate = true;
    Get.back();
  }

  getAppInfo() async {
    if (packageInfo == null) {
      packageInfo = await PackageInfo.fromPlatform();
    }
  }

  void nowUpdate() async {
    if (Platform.isAndroid) {
      PermissionUtil.storage(() async {
        var path = await IMUtil.createTempFile(
          dir: 'apk',
          fileName: '${packageInfo!.appName}.apk',
        );
        HttpUtil.download(
          upgradeInfoV2!.downloadURL!,
          cachePath: path,
          onProgress: (int count, int total) {
            subject.add(count / total);
            if (count == total) {
              AppInstaller.installApk(path);
            }
          },
        );
      });
    } else {
      // if (await canLaunch(upgradeInfo!.url!)) {
      //   launch(upgradeInfo!.url!);
      // }
    }
  }

  void checkUpdate() async {
    if (!Platform.isAndroid) return;
    LoadingView.singleton.wrap(asyncFunction: () async {
      await getAppInfo();
      return Apis.checkUpgradeV2();
    }).then((value) {
      upgradeInfoV2 = value;
      if (!canUpdate) {
        IMWidget.showToast('已是最新版本');
        return;
      }
      Get.dialog(UpgradeViewV2(
        upgradeInfo: upgradeInfoV2!,
        packageInfo: packageInfo!,
        onNow: nowUpdate,
        subject: subject,
      ));
    });
  }

  /// 自动检测更新
  autoCheckVersionUpgrade() async {
    if (!Platform.isAndroid) return;
    if (isShowUpgradeDialog || isNowIgnoreUpdate) return;
    await getAppInfo();
    upgradeInfoV2 = await Apis.checkUpgradeV2();
    String? ignore = DataPersistence.getIgnoreVersion();
    if (ignore == upgradeInfoV2!.buildVersion) {
      isNowIgnoreUpdate = true;
      return;
    }
    if (!canUpdate) return;
    isShowUpgradeDialog = true;
    Get.dialog(UpgradeViewV2(
      upgradeInfo: upgradeInfoV2!,
      packageInfo: packageInfo!,
      onLater: laterUpdate,
      onIgnore: ignoreUpdate,
      onNow: nowUpdate,
      subject: subject,
    )).whenComplete(() => isShowUpgradeDialog = false);
  }

  bool get canUpdate =>
      IMUtil.compareVersion(
        packageInfo!.version,
        upgradeInfoV2!.buildVersion!,
      ) <
      0;
}
