// import 'dart:async';
//
// import 'package:flutter_ion/src/_library/apps/biz/proto/biz.pbenum.dart';
// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
// import 'package:get/get.dart';
// import 'package:openim_enterprise_chat/src/core/controller/call_controller.dart';
// import 'package:openim_enterprise_chat/src/core/rtc/seat.dart';
//
// class GroupCallLogic extends GetxController {
//   final callCtrl = Get.find<CallController>();
//   late String gid;
//   late String senderUid;
//   late List<String> participantIdList;
//   late String type;
//   var state = CallState.CALL.obs;
//   var senderName = "".obs;
//   var senderIcon = "".obs;
//
//   var seatMap = <String, Rx<Seat>>{}.obs;
//
//   Timer? _checkVideoTracksTimer;
//
//   @override
//   void onInit() {
//     gid = Get.arguments['gid'];
//     senderUid = Get.arguments['senderUid'];
//     participantIdList = Get.arguments['receiverIds'] ?? [];
//     type = Get.arguments['type'];
//     state.value = Get.arguments['state'];
//
//     if (participantIdList.isEmpty) {
//       participantIdList.addAll(callCtrl.uidMappingStream.keys);
//     }
//     if (!participantIdList.contains(senderUid)) {
//       participantIdList.add(senderUid);
//     }
//
//     // 移除自己 自己使用本地流已经用户信息
//     participantIdList.remove(OpenIM.iMManager.uid);
//
//     // 初始化通话成员
//     participantIdList.forEach((uid) {
//       seatMap.addAll({
//         uid: Seat(
//           uid: uid,
//           participant: callCtrl.uidMappingStream[uid],
//           peer: callCtrl.uidMappingPeer[uid],
//         ).obs
//       });
//     });
//
//     // 更新rtc流
//     callCtrl.onStreamChanged = (uid, par) {
//       print('-----onStreamChanged:  $uid---   par:$par');
//       if (null != par) {
//         var seat = seatMap[uid];
//         if (seat == null) {
//           seat = Seat(uid: uid).obs;
//           seatMap.addAll({uid: seat});
//         }
//         seat.update((val) {
//           val?.participant = par;
//         });
//       } else {
//         seatMap.remove(uid);
//       }
//     };
//
//     // 更新peer
//     callCtrl.onPeerChanged = (uid, peer) {
//       if (null != peer) {
//         var seat = seatMap[uid];
//         if (seat == null) {
//           seat = Seat(uid: uid).obs;
//           seatMap.addAll({uid: seat});
//         }
//         seat.update((val) {
//           val?.peer = peer;
//         });
//       } else {
//         seatMap.remove(uid);
//       }
//     };
//
//     callCtrl.onStateChanged = (state) {
//       this.state.value = state;
//       print('-------state:$state');
//     };
//
//     _checkVideoTracks();
//     super.onInit();
//   }
//
//   @override
//   void onReady() {
//     _queryCallingMembersInfo();
//     if (state.value == CallState.CALL) {
//       callCtrl.mediaHandle(
//           MediaOperation.Dial,
//           participantIdList,
//           isVoiceCall() ? StreamType.Voice : StreamType.Video,
//           SessionType.Group);
//     }
//     super.onReady();
//   }
//
//   bool isVoiceCall() => type == "voice";
//
//   /// 更新用户信息
//   void _queryCallingMembersInfo() async {
//     if (participantIdList.isEmpty) return;
//     var list = await OpenIM.iMManager.getUsersInfo(participantIdList);
//     list.forEach((element) {
//       if (element.uid == senderUid) {
//         senderName.value = element.getShowName();
//         senderIcon.value = element.icon ?? '';
//       }
//       var seat = seatMap[element.uid];
//       seat!.update((val) {
//         val?.user = element;
//       });
//     });
//   }
//
//   String getMemberName(index) {
//     var seat = seatMap.values.elementAt(index).value;
//     if (seat.user != null) {
//       return seat.user!.getShowName();
//     } else if (seat.peer != null) {
//       return seat.peer!.info['name'] ?? '';
//     }
//     return "";
//   }
//
//   String? getMemberAvatar(index) {
//     var seat = seatMap.values.elementAt(index).value;
//     if (seat.user != null) {
//       return seat.user!.icon;
//     } else if (seat.peer != null) {
//       return seat.peer!.info['icon'];
//     }
//     return null;
//   }
//
//   void _checkVideoTracks() {
//     _checkVideoTracksTimer?.cancel();
//     _checkVideoTracksTimer = Timer.periodic(Duration(seconds: 2), (timer) {
//       seatMap.forEach((key, value) {
//         var participant = value.value.participant;
//         if (null != participant) {
//           var enabled =
//               participant.renderer.srcObject!.getVideoTracks()[0].enabled;
//           if (value.value.cameraOpened != enabled) {
//             value.update((val) {
//               val?.cameraOpened = enabled;
//             });
//           }
//         }
//       });
//     });
//   }
//
//   toggleCamera() {
//     callCtrl.trackControl();
//   }
//
//   toggleMuteLocal() {
//     callCtrl.toggleMuteLocal();
//   }
//
//   toggleSpeaker() {
//     callCtrl.toggleSpeaker();
//   }
//
//   switchCamera() {
//     callCtrl.switchCamera();
//   }
//
//   refuse() {
//     callCtrl.mediaHandle(
//       MediaOperation.Refuse,
//       [],
//       isVoiceCall() ? StreamType.Voice : StreamType.Video,
//       SessionType.Group,
//     );
//   }
//
//   accept() {
//     callCtrl.mediaHandle(
//       MediaOperation.Accept,
//       [],
//       isVoiceCall() ? StreamType.Voice : StreamType.Video,
//       SessionType.Group,
//     );
//   }
//
//   hangup() {
//     Get.back();
//     // callCtrl.mediaHandle(
//     //   MediaOperation.HangUp,
//     //   [],
//     //   isVoiceCall() ? StreamType.Voice : StreamType.Video,
//     //   SessionType.Group,
//     // );
//   }
//
//   @override
//   void onClose() {
//     _checkVideoTracksTimer?.cancel();
//     callCtrl.close();
//     super.onClose();
//   }
// }
