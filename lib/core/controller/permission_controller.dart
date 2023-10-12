import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  @override
  void onInit() async {
    final permissions = [
      Permission.notification,
    ];

    for (var permission in permissions) {
      final state = await permission.request();
    }
    super.onInit();
  }
}
