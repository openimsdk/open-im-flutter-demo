// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:openim_enterprise_chat/src/core/rtc/participant.dart';
// import 'package:openim_enterprise_chat/src/res/styles.dart';
//
// import '../call_logic.dart';
//
// class GroupStreamRendererView extends StatelessWidget {
//   GroupStreamRendererView({Key? key}) : super(key: key);
//   final logic = Get.find<GroupCallLogic>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(child: _rendererList());
//   }
//
//   Widget _rendererList() => Obx(() => GridView.builder(
//         // itemCount: 7,
//         itemCount: logic.seatMap.length + 1,
//         padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 17.h),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 4.h,
//           crossAxisSpacing: 4.w,
//           childAspectRatio: 1.0,
//         ),
//         itemBuilder: (_, int index) => Obx(
//             () => index == 0 ? _buildLocalView() : _buildRemoteView(index - 1)),
//         // itemBuilder: (_, int index) => _buildLocalView(),
//       ));
//
//   Widget _buildRemoteView(index) {
//     var seat = logic.seatMap.values.elementAt(index).value;
//     return _buildItemView(
//       url: seat.user?.icon ?? seat.peer?.info['icon'],
//       cameraOpened: seat.cameraOpened,
//       participant: seat.participant,
//     );
//   }
//
//   Widget _buildLocalView() => _buildItemView(
//         url: OpenIM.iMManager.uInfo.icon,
//         cameraOpened: logic.callCtrl.localVideoEnabled.value,
//         participant: logic.callCtrl.localStream,
//       );
//
//   Widget _buildItemView({
//     String? url,
//     bool cameraOpened = true,
//     Participant? participant,
//   }) =>
//       ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: Stack(
//           children: [
//             if (null != participant)
//               RTCVideoView(
//                 participant.renderer,
//                 objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//               ),
//             if (url != null &&
//                 (participant == null || logic.isVoiceCall() || !cameraOpened))
//               CachedNetworkImage(
//                 imageUrl: url,
//                 width: double.infinity,
//                 height: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             if (participant == null)
//               Container(
//                 color: PageStyle.c_000000_opacity60p,
//                 width: double.infinity,
//                 child: Center(
//                   child: Lottie.asset(
//                     'assets/anim/member_loading.json',
//                     width: 55.w,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       );
// }
