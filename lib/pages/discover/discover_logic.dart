import 'package:get/get.dart';
import 'package:openim/core/controller/app_controller.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

class DiscoverLogic extends GetxController {
  final refreshCtrl = RefreshController();
  final appLogic = Get.find<AppController>();
  final list = <Rx<UniMPInfo>>[].obs;
  final url = ''.obs;

  @override
  void onReady() {
    super.onReady();

    final temp = appLogic.clientConfigMap['discoverPageURL'];

    if (temp == null) {
      appLogic.queryClientConfig().then((value) {
        if (value['discoverPageURL'] == null) {
          url.value = 'https://www.openim.io';
        } else {
          url.value = value['discoverPageURL'];
        }
      });
    } else {
      url.value = temp;
    }
  }
}
