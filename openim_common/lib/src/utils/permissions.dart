import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Permissions._();

  static Future<bool> checkSystemAlertWindow() async {
    return await Permission.systemAlertWindow.isGranted;
  }

  static Future<bool> checkStorage() async {
    return await Permission.storage.isGranted;
  }

  static void camera(Function()? onGranted) async {
    if (await Permission.camera.request().isGranted) {
      onGranted?.call();
    }
    if (await Permission.camera.isPermanentlyDenied) {}
  }

  static void storage(Function()? onGranted) async {
    if (await Permission.storage.request().isGranted) {
      onGranted?.call();
    }
    if (await Permission.storage.isPermanentlyDenied) {}
  }

  static void microphone(Function()? onGranted) async {
    if (await Permission.microphone.request().isGranted) {
      onGranted?.call();
    }
    if (await Permission.microphone.isPermanentlyDenied) {}
  }

  static void location(Function()? onGranted) async {
    if (await Permission.location.request().isGranted) {
      onGranted?.call();
    }
    if (await Permission.location.isPermanentlyDenied) {}
  }

  static void speech(Function()? onGranted) async {
    if (await Permission.speech.request().isGranted) {
      onGranted?.call();
    }
    if (await Permission.speech.isPermanentlyDenied) {}
  }

  static void photos(Function()? onGranted) async {
    if (await Permission.photos.request().isGranted) {
      onGranted?.call();
    }
    if (await Permission.photos.isPermanentlyDenied) {}
  }

  static void notification(Function()? onGranted) async {
    if (await Permission.notification.request().isGranted) {
      onGranted?.call();
    }
    if (await Permission.notification.isPermanentlyDenied) {}
  }

  static void ignoreBatteryOptimizations(Function()? onGranted) async {
    if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
      onGranted?.call();
    }
    if (await Permission.ignoreBatteryOptimizations.isPermanentlyDenied) {}
  }

  static void cameraAndMicrophone(Function()? onGranted) async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
    ];
    bool isAllGranted = true;
    for (var permission in permissions) {
      final state = await permission.request();
      isAllGranted = isAllGranted && state.isGranted;
    }
    if (isAllGranted) {
      onGranted?.call();
    }
  }

  static Future<Map<Permission, PermissionStatus>> request(
      List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses;
  }
}
