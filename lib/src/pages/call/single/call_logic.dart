// import 'package:flutter_ion/src/_library/apps/biz/proto/biz.pbenum.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:openim_enterprise_chat/src/core/controller/call_controller.dart';
//
// class CallLogic extends GetxController {
//   /// voice|video
//   var type = "".obs;
//   var defaultType = "";
//   late String uid;
//   late String name;
//   late String icon;
//   final callCtrl = Get.find<CallController>();
//   var state = CallState.CALL.obs;
//   var currentX = 0.0.obs;
//   var currentY = 0.0.obs;
//   var smallView = false.obs;
//
//   @override
//   void onInit() {
//     currentX.value = 255.w;
//     currentY.value = 48.h;
//     uid = Get.arguments['uid'];
//     name = Get.arguments['name'];
//     icon = Get.arguments['icon'];
//     state.value = callCtrl.state = Get.arguments['state'];
//     type.value = defaultType = Get.arguments['type'];
//     callCtrl.streamType = streamType;
//     print(
//         '-----------CallLogic--init-${type.value}----${state.value}------------');
//     // callCtrl.stateSubject.stream.distinct().listen((event) {
//     //   print('-----------CallLogic listen---$event-----------------');
//     //   state.value = event;
//     //   switch (event) {
//     //     case CallState.CANCEL:
//     //     case CallState.BE_CANCELED:
//     //     case CallState.HANGUP:
//     //     case CallState.BE_HANGUP:
//     //     case CallState.REJECT:
//     //     case CallState.BE_REJECTED:
//     //       // Get.back();
//     //       break;
//     //     default:
//     //       break;
//     //   }
//     // });
//     callCtrl.stateChanged = (state_) {
//       print('-----------CallLogic listen---$state_-----------------');
//       state.value = state_;
//       switch (state_) {
//         case CallState.CANCEL:
//         case CallState.BE_CANCELED:
//         case CallState.HANGUP:
//         case CallState.BE_HANGUP:
//         case CallState.REJECT:
//         case CallState.BE_REJECTED:
//           Get.back();
//           break;
//         default:
//           break;
//       }
//     };
//     super.onInit();
//   }
//
//   void toggleWindowSize() {
//     smallView.value = !smallView.value;
//   }
//
//   void updateXY(double dx, double dy) {
//     currentX.value += dx;
//     currentY.value += dy;
//   }
//
//   bool isVoiceCall() => type.value == "voice";
//
//   StreamType get streamType =>
//       isVoiceCall() ? StreamType.Voice : StreamType.Video;
//
//   SessionType get sessionType => SessionType.Single;
//
//   /// 转到语音通话
//   toVoice() {
//     callCtrl.trackControl();
//     // type.value = callCtrl.localVideoEnabled.value ? 'video' : 'voice';
//     type.value = 'video';
//   }
//
//   /// 接听
//   accept() {
//     callCtrl.mediaHandle(MediaOperation.Accept, [uid], streamType, sessionType);
//   }
//
//   ///拒绝
//   refuse() {
//     callCtrl.mediaHandle(MediaOperation.Refuse, [uid], streamType, sessionType);
//   }
//
//   /// 挂断
//   hangup() {
//     callCtrl.mediaHandle(MediaOperation.HangUp, [uid], streamType, sessionType);
//   }
//
//   /// 取消通话
//   cancel() {
//     callCtrl.mediaHandle(MediaOperation.Cancel, [uid], streamType, sessionType);
//   }
//
//   /// 静音
//   toggleMuteLocal() {
//     callCtrl.toggleMuteLocal();
//   }
//
//   /// 扬声器
//   toggleSpeaker() {
//     callCtrl.toggleSpeaker();
//   }
//
//   /// 切换摄像头
//   switchCamera() {
//     callCtrl.switchCamera();
//   }
//
//   @override
//   void onReady() {
//     if(state.value == CallState.CALL){
//       callCtrl.mediaHandle(MediaOperation.Dial, [uid], streamType, sessionType);
//     }
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     callCtrl.close();
//     super.onClose();
//   }
// }
