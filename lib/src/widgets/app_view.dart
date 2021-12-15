import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/common/config.dart';
import 'package:openim_enterprise_chat/src/core/controller/app_controller.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key, required this.builder}) : super(key: key);
  final Widget Function(Locale? locale) builder;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (controller) => FocusDetector(
        onForegroundGained: () => controller.runningBackground(false),
        onForegroundLost: () => controller.runningBackground(true),
        child: ScreenUtilInit(
          designSize: Size(Config.UI_W, Config.UI_H),
          builder: () => builder(controller.getLocale()),
        ),
      ),
    );
  }
}
