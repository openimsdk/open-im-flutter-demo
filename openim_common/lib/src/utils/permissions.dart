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
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.camera.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void storage(Function()? onGranted) async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.storage.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void microphone(Function()? onGranted) async {
    if (await Permission.microphone.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.microphone.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void location(Function()? onGranted) async {
    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.location.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void speech(Function()? onGranted) async {
    if (await Permission.speech.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.speech.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void photos(Function()? onGranted) async {
    if (await Permission.photos.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.photos.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void notification(Function()? onGranted) async {
    if (await Permission.notification.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.notification.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void ignoreBatteryOptimizations(Function()? onGranted) async {
    if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.ignoreBatteryOptimizations.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void cameraAndMicrophone(Function()? onGranted) async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      // Permission.speech,
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
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses;
  }
}
