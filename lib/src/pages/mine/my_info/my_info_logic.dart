import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/bottom_sheet_view.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';

class MyInfoLogic extends GetxController {
  final imLogic = Get.find<IMController>();

  @override
  void onInit() {
    super.onInit();
  }

  void setupUserName() {
    AppNavigator.startSetUserName();
    // Get.toNamed(AppRoutes.SETUP_USER_NAME);
  }

  void myQrcode() {
    AppNavigator.startMyQrcode();
    // Get.toNamed(AppRoutes.MY_QRCODE);
  }

  void myID() {
    AppNavigator.startMyID();
    // Get.toNamed(AppRoutes.MY_ID);
  }

  void openPhotoSheet() {
    IMWidget.openPhotoSheet(onData: (path, url) {
      if (url != null) {
        OpenIM.iMManager.userManager.setSelfInfo(faceURL: url);
      }
    });
  }

  void openDatePicker() {
    var appLocale = Get.locale;
    var format = "yyyy/MM/dd";
    var locale = DateTimePickerLocale.en_us;
    if (appLocale!.languageCode.toLowerCase().contains("zh")) {
      format = "yyyy年/MM月/dd日";
      locale = DateTimePickerLocale.zh_cn;
    }
    DatePicker.showDatePicker(
      Get.context!,
      locale: locale,
      dateFormat: format,
      maxDateTime: DateTime.now(),
      onConfirm: (dateTime, List<int> selectedIndex) {
        // _updateBirthday(dateTime.toString());
      },
    );
  }

  void selectGender() {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.man,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            onTap: () => _updateGender(1),
          ),
          SheetItem(
            label: StrRes.woman,
            onTap: () => _updateGender(2),
          ),
        ],
      ),
    );
  }

  void _updateGender(int gender) {
    LoadingView.singleton.wrap(
      asyncFunction: () => OpenIM.iMManager.userManager
          .setSelfInfo(gender: gender)
          .then((value) => imLogic.userInfo.update((val) {
                val?.gender = gender;
              })),
    );
  }

  void _updateBirthday(String birthday) {
    LoadingView.singleton.wrap(
      asyncFunction: () => OpenIM.iMManager.userManager
          .setSelfInfo(birth: 0)
          .then((value) => imLogic.userInfo.update((val) {
                // val?.birth = birthday;
              })),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
