import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'core/controller/im_controller.dart';
import 'routes/app_pages.dart';
import 'widgets/app_view.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppView(
      builder: (locale, builder) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        enableLog: true,
        builder: builder,
        logWriterCallback: Logger.print,
        translations: TranslationService(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        fallbackLocale: TranslationService.fallbackLocale,
        locale: locale,
        localeResolutionCallback: (locale, list) {
          Get.locale ??= locale;
          return locale;
        },
        supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
        getPages: AppPages.routes,
        initialBinding: InitBinding(),
        initialRoute: AppRoutes.splash,
        theme: _themeData,
      ),
    );
  }

  ThemeData get _themeData => ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade50,
        canvasColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white),
        textSelectionTheme: const TextSelectionThemeData().copyWith(cursorColor: Colors.blue),
        checkboxTheme: const CheckboxThemeData().copyWith(
          checkColor: WidgetStateProperty.all(Colors.white),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            }
            if (states.contains(WidgetState.selected)) {
              return Colors.blue;
            }
            return Colors.white;
          }),
          side: BorderSide(color: Colors.grey.shade500, width: 1),
        ),
        dialogTheme: const DialogTheme().copyWith(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
            foregroundColor: const WidgetStatePropertyAll(Colors.black),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData()
            .copyWith(color: Colors.white, linearTrackColor: Colors.grey[300], circularTrackColor: Colors.grey[300]),
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemBlue,
          barBackgroundColor: Colors.white,
          applyThemeToAll: true,
          textTheme: const CupertinoTextThemeData().copyWith(
            navActionTextStyle: TextStyle(color: CupertinoColors.label, fontSize: 17.sp),
            actionTextStyle: TextStyle(color: CupertinoColors.systemBlue, fontSize: 17.sp),
            textStyle: TextStyle(color: CupertinoColors.label, fontSize: 17.sp),
            navLargeTitleTextStyle: TextStyle(color: CupertinoColors.label, fontSize: 20.sp),
            navTitleTextStyle: TextStyle(color: CupertinoColors.label, fontSize: 17.sp),
            pickerTextStyle: TextStyle(color: CupertinoColors.label, fontSize: 17.sp),
            tabLabelTextStyle: TextStyle(color: CupertinoColors.label, fontSize: 17.sp),
            dateTimePickerTextStyle: TextStyle(color: CupertinoColors.label, fontSize: 17.sp),
          ),
        ),
      );
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IMController>(IMController());
    Get.put<PushController>(PushController());
    Get.put<CacheController>(CacheController());
    Get.put<DownloadController>(DownloadController());
  }
}
