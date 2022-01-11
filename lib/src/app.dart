import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_pages.dart';
import 'package:openim_demo/src/utils/logger_util.dart';
import 'package:openim_demo/src/widgets/app_view.dart';

import 'core/controller/im_controller.dart';
import 'core/controller/jpush_controller.dart';
import 'core/controller/permission_controller.dart';

class EnterpriseChatApp extends StatelessWidget {
  const EnterpriseChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppView(
      builder: (locale) => GetMaterialApp(
        debugShowCheckedModeBanner: true,
        enableLog: true,
        builder: EasyLoading.init(),
        logWriterCallback: Logger.print,
        translations: TranslationService(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // DefaultCupertinoLocalizations.delegate,
        ],
        fallbackLocale: TranslationService.fallbackLocale,
        locale: locale,
        localeResolutionCallback: (locale, list) {
          Get.locale ??= locale;
        },
        supportedLocales: [
          const Locale('zh', 'CN'),
          const Locale('en', 'US'),
        ],
        getPages: AppPages.routes,
        initialBinding: InitBinding(),
        initialRoute: AppRoutes.SPLASH,
      ),
    );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PermissionController>(PermissionController());
    Get.put<IMController>(IMController());
    Get.put<JPushController>(JPushController());
  }
}
