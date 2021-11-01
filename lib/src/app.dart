
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/routes/app_pages.dart';
import 'package:openim_enterprise_chat/src/utils/logger_util.dart';
import 'package:openim_enterprise_chat/src/widgets/app_view.dart';

import 'core/controller/im_controller.dart';
import 'core/controller/jpush_controller.dart';
import 'core/controller/permission_controller.dart';

class EnterpriseChatApp extends StatelessWidget {
 const EnterpriseChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppInitView(
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: true,
        enableLog: true,
        builder: EasyLoading.init(),
        logWriterCallback: Logger.print,
        translations: TranslationService(),
        fallbackLocale: TranslationService.fallbackLocale,
        locale: Locale('zh', 'CN'),
        getPages: AppPages.routes,
        initialBinding: InitBinding(),
        initialRoute: AppRoutes.SPLASH,
      ),
    );
    // return ScreenUtilInit(
    //   designSize: Size(Config.UI_W, Config.UI_H),
    //   builder: () => GetMaterialApp(
    //     debugShowCheckedModeBanner: true,
    //     enableLog: true,
    //     logWriterCallback: Logger.print,
    //     translations: TranslationService(),
    //     fallbackLocale: TranslationService.fallbackLocale,
    //     locale: Locale('zh', 'CN'),
    //     getPages: AppPages.routes,
    //     initialBinding: InitBinding(),
    //     initialRoute: AppRoutes.SPLASH,
    //   ),
    // );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PermissionController>(PermissionController());
    Get.put<IMController>(IMController());
    // Get.put<CallController>(CallController());
    Get.put<JPushController>(JPushController());
    // Get.lazyPut(() => JPushController());
    // Get.lazyPut(() => CallController());
    // Get.lazyPut(() => IMController());
    // Get.lazyPut(() => PermissionController());
  }
}
