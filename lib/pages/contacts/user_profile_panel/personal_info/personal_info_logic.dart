import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:url_launcher/url_launcher.dart';

import '../user_profile _panel_logic.dart';

class PersonalInfoLogic extends GetxController {
  final userProfilesLogic = Get.find<UserProfilePanelLogic>(tag: GetTags.userProfile);
  late String userID;
  final userFullInfo = UserFullInfo().obs;

  @override
  void onInit() {
    userID = Get.arguments['userID'];
    super.onInit();
  }

  @override
  void onReady() {
    _queryUserFullInfo();
    super.onReady();
  }

  void _queryUserFullInfo() async {
    final existUser = UserCacheManager().getUserInfo(userID);
    if (existUser != null) {
      userFullInfo.update((val) {
        val?.nickname = existUser.nickname;
        val?.faceURL = existUser.faceURL;
        val?.status = existUser.status;
        val?.level = existUser.level;
        val?.phoneNumber = existUser.phoneNumber;
        val?.areaCode = existUser.areaCode;
        val?.birth = existUser.birth;
        val?.email = existUser.email;
        val?.gender = existUser.gender;
        val?.mobile = existUser.mobile;
      });
    }

    final list = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.getUserFullInfo(userIDList: [userID]),
    );
    final info = list?.firstOrNull;
    if (null != info) {
      UserCacheManager().addOrUpdateUserInfo(userID, info);

      userFullInfo.update((val) {
        val?.nickname = info.nickname;
        val?.faceURL = info.faceURL;
        val?.gender = info.gender;
        val?.englishName = info.englishName;
        val?.birth = info.birth;
        val?.telephone = info.telephone;
        val?.phoneNumber = info.phoneNumber;
        val?.email = info.email;
      });
    }
  }

  String? get nickname => IMUtils.emptyStrToNull(userProfilesLogic.userInfo.value.nickname) ?? IMUtils.emptyStrToNull(userFullInfo.value.nickname);

  String? get faceURL => IMUtils.emptyStrToNull(userProfilesLogic.userInfo.value.faceURL) ?? IMUtils.emptyStrToNull(userFullInfo.value.faceURL);

  bool get isMale => (userProfilesLogic.userInfo.value.gender ?? userFullInfo.value.gender) == 1;

  String? get englishName => IMUtils.emptyStrToNull(userFullInfo.value.englishName) ?? '-';

  int? get _birth => userProfilesLogic.userInfo.value.birth ?? userFullInfo.value.birth;

  String? get birth => _birth == null ? '-' : DateUtil.formatDateMs(_birth!, format: IMUtils.getTimeFormat1());

  String? get telephone => IMUtils.emptyStrToNull(userFullInfo.value.telephone) ?? '-';

  String? get phoneNumber => IMUtils.emptyStrToNull(userFullInfo.value.phoneNumber) ?? '-';

  String? get email => IMUtils.emptyStrToNull(userFullInfo.value.email) ?? '-';

  clickPhoneNumber() => _callSystemPhone(userFullInfo.value.phoneNumber);

  clickTel() => _callSystemPhone(userFullInfo.value.telephone);

  clickEmail() => _callSystemEmail(userFullInfo.value.email);

  _callSystemPhone(String? phone) async {
    final value = IMUtils.emptyStrToNull(phone);
    if (null != value) {
      final uri = Uri.parse('tel:$value');
      try {
        launchUrl(uri);
      } catch (_) {}
    }
  }

  _callSystemEmail(String? email) {
    final value = IMUtils.emptyStrToNull(email);
    if (null != value) {
      final uri = Uri.parse('mailto:$value');
      try {
        launchUrl(uri);
      } catch (_) {}
    }
  }
}
