import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/pages/mine/edit_my_info/edit_my_info_logic.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';

class MyInfoLogic extends GetxController {
  final imLogic = Get.find<IMController>();

  // final userInfo = UserFullInfo.fromJson(OpenIM.iMManager.uInfo.toJson()).obs;

  @override
  void onInit() {
    // imLogic.selfInfoUpdatedSubject.listen(_onChangedSefInfo);
    super.onInit();
  }

  _onChangedSefInfo(UserInfo userInfo) {}

  void editMyName() => AppNavigator.startEditMyInfo();

  void editEnglishName() => AppNavigator.startEditMyInfo(
        attr: EditAttr.englishName,
      );

  void editTel() => AppNavigator.startEditMyInfo(
        attr: EditAttr.telephone,
      );

  void editMobile() => AppNavigator.startEditMyInfo(
        attr: EditAttr.mobile,
      );

  void editEmail() => AppNavigator.startEditMyInfo(
        attr: EditAttr.email,
      );

  void openPhotoSheet() {
    IMViews.openPhotoSheet(onData: (path, url) async {
      if (url != null) {
        LoadingView.singleton.wrap(
          asyncFunction: () =>
              Apis.updateUserInfo(userID: OpenIM.iMManager.userID, faceURL: url)
                  .then((value) => imLogic.userInfo.update((val) {
                        val?.faceURL = url;
                      })),
        );
      }
    });
  }

  void openDatePicker() {
    var appLocale = Get.locale;
    var isZh = appLocale!.languageCode.toLowerCase().contains("zh");
    DatePicker.showDatePicker(
      Get.context!,
      locale: isZh ? LocaleType.zh : LocaleType.en,
      maxTime: DateTime.now(),
      theme: DatePickerTheme(
        cancelStyle: Styles.ts_0C1C33_17sp,
        doneStyle: Styles.ts_0089FF_17sp,
        itemStyle: Styles.ts_0C1C33_17sp,
      ),
      onConfirm: (dateTime) {
        _updateBirthday(dateTime.millisecondsSinceEpoch ~/ 1000);
      },
    );
  }

  void selectGender() {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.man,
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
      asyncFunction: () =>
          Apis.updateUserInfo(userID: OpenIM.iMManager.userID, gender: gender)
              .then((value) => imLogic.userInfo.update((val) {
                    val?.gender = gender;
                  })),
    );
  }

  void _updateBirthday(int birthday) {
    LoadingView.singleton.wrap(
      asyncFunction: () => Apis.updateUserInfo(
        userID: OpenIM.iMManager.userID,
        birth: birthday * 1000,
      ).then((value) => imLogic.userInfo.update((val) {
            val?.birth = birthday * 1000;
          })),
    );
  }

  @override
  void onReady() {
    _queryMyFullIno();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void _queryMyFullIno() async {
    // final info = await LoadingView.singleton.wrap(
    //   asyncFunction: () => Apis.queryMyFullInfo(
    //       // userID: OpenIM.iMManager.uid,
    //       ),
    // );
    // if (null != info) {
    //   userInfo.update((val) {
    //     val?.nickname = _trimNullStr(info.nickname) ?? val.nickname;
    //     val?.englishName = _trimNullStr(info.englishName) ?? val.englishName;
    //     val?.faceURL = _trimNullStr(info.faceURL) ?? val.faceURL;
    //     val?.gender = info.gender ?? val.gender;
    //     val?.mobile = _trimNullStr(info.mobile) ?? val.mobile;
    //     val?.telephone = _trimNullStr(info.telephone) ?? val.telephone;
    //     val?.birth = info.birth ?? val.birth;
    //     val?.email = _trimNullStr(info.email) ?? val.email;
    //   });
    // }
  }

  static _trimNullStr(String? value) => IMUtils.emptyStrToNull(value);
}
