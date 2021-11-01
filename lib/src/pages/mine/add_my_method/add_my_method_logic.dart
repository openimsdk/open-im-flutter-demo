import 'package:get/get.dart';

class AddMyMethodLogic extends GetxController {
  var enabledPhone = true.obs;
  var enabledIDCode = true.obs;

  void togglePhone() {
    enabledPhone.value = !enabledPhone.value;
  }

  void toggleIDCode() {
    enabledIDCode.value = !enabledIDCode.value;
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
