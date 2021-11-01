import 'package:flutter_openim_widget/ui/util/permission_util.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  @override
  void onInit() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await PermissionUtil.request([
      Permission.camera,
      Permission.storage,
      Permission.microphone,
      Permission.speech,
      Permission.location,
    ]);
    super.onInit();
  }
}
