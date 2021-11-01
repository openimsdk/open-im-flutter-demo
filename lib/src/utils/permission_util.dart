// import 'package:permission_handler/permission_handler.dart' as p;
//
// class PermissionUtil {
//   static void camera(Function() onGranted) async {
//     if (await p.Permission.camera.request().isGranted) {
//       // Either the permission was already granted before or the user just granted it.
//       onGranted();
//     }
//     if (await p.Permission.camera.isPermanentlyDenied) {
//       // The user opted to never again see the permission request dialog for this
//       // app. The only way to change the permission's status now is to let the
//       // user manually enable it in the system settings.
//     }
//   }
//
//   static void storage(Function() onGranted) async {
//     if (await p.Permission.storage.request().isGranted) {
//       // Either the permission was already granted before or the user just granted it.
//       onGranted();
//     }
//     if (await p.Permission.storage.isPermanentlyDenied) {
//       // The user opted to never again see the permission request dialog for this
//       // app. The only way to change the permission's status now is to let the
//       // user manually enable it in the system settings.
//     }
//   }
//
//   static void microphone(Function() onGranted) async {
//     if (await p.Permission.microphone.request().isGranted) {
//       // Either the permission was already granted before or the user just granted it.
//       onGranted();
//     }
//     if (await p.Permission.microphone.isPermanentlyDenied) {
//       // The user opted to never again see the permission request dialog for this
//       // app. The only way to change the permission's status now is to let the
//       // user manually enable it in the system settings.
//     }
//   }
//
// }
