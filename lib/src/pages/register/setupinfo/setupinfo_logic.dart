import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/core/controller/push_controller.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/http_util.dart';
import 'package:openim_demo/src/widgets/bottom_sheet_view.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';

import '../../../utils/data_persistence.dart';

class SetupSelfInfoLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  final nameCtrl = TextEditingController();
  final showNameClearBtn = false.obs;
  final icon = "".obs;
  String? phoneNumber;
  String? areaCode;
  String? email;
  String? invitationCode;
  late String verifyCode;
  late String password;
  final avatarIndex = 0.obs;
  final nickName = ''.obs;
  final gender = 1.obs;
  final birth = 0.obs;

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    areaCode = Get.arguments['areaCode'];
    email = Get.arguments['email'];
    verifyCode = Get.arguments['verifyCode'];
    password = Get.arguments['password'];
    invitationCode = Get.arguments['invitationCode'];
    avatarIndex.value = -1;
    birth.value = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // avatarIndex = Random().nextInt(indexAvatarList.length);
    super.onInit();
  }

  var stream = Stream.value(1);

  enterMain() async {
    if (nameCtrl.text.isEmpty) {
      IMWidget.showToast(StrRes.nameNotEmpty);
      return;
    }

    LoadingView.singleton.wrap(asyncFunction: () => _login());
  }

  _login() async {
    var data = await Apis.setPassword(
        nickname: nameCtrl.text,
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        verificationCode: verifyCode,
        invitationCode: invitationCode,
        gender: gender.value,
        birth: birth.value);
    var account = {
      "areaCode": areaCode,
      "phoneNumber": phoneNumber,
      "email": email
    };
    await DataPersistence.putLoginCertificate(data);
    await DataPersistence.putAccount(account);
    var uid = data.userID;
    var token = data.imToken;
    print('---------login---------- uid: $uid, token: $token');
    await imLogic.login(uid, token);
    await syncSelfInfo(uid);
    print('---------im login success-------');
    pushLogic.login(uid);
    print('---------jpush login success----');
    AppNavigator.startMain();
  }

  syncSelfInfo(String uid) async {
    if (icon.value.isNotEmpty == true) {
      final faceURL = await HttpUtil.uploadImageForMinio(path: icon.value);
      await Apis.updateUserInfo(userID: uid, faceURL: faceURL);
      // await OpenIM.iMManager.userManager.setSelfInfo(faceURL: faceURL);
    }
  }

  void pickerPic() {
    IMWidget.openPhotoSheet(
        onData: (path, url) {
          icon.value = url ?? '';
          if (icon.isNotEmpty) avatarIndex.value = -1;
        },
        isAvatar: true,
        fromCamera: false,
        fromGallery: false,
        onIndexAvatar: (index) {
          if (null != index) {
            avatarIndex.value = index;
            icon.value = "";
          }
        });
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
    this.gender.value = gender;
  }

  String get genderStr => gender.value == 1 ? '男' : '女';

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
        _updateBirthday(dateTime.millisecondsSinceEpoch ~/ 1000);
      },
    );
  }

  void _updateBirthday(int birthday) {
    birth.value = birthday;
  }

  @override
  void onReady() {
    nameCtrl.addListener(() {
      showNameClearBtn.value = nameCtrl.text.isNotEmpty;
    });

    super.onReady();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    super.onClose();
  }

  void openPhotoSheet() {
    IMWidget.openPhotoSheet(
        toUrl: false,
        onData: (path, url) {
          // 拿到本地的照片地址， 最后才上传
          icon.value = path;
        });
  }
}
