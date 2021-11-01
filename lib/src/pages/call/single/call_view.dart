// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:get/get.dart';
// import 'package:openim_enterprise_chat/src/core/controller/call_controller.dart';
// import 'package:openim_enterprise_chat/src/res/styles.dart';
//
// import 'call_logic.dart';
// import 'view/be_invited_video_call.dart';
// import 'view/be_invited_voice_call.dart';
// import 'view/make_video_call.dart';
// import 'view/make_voice_call.dart';
// import 'view/video_calling.dart';
// import 'view/video_connecting.dart';
// import 'view/voice_calling.dart';
// import 'view/voice_connecting.dart';
//
// class CallPage extends StatelessWidget {
//   // CallPage({Key? key, required this.logic}) : super(key: key);
//
//   // final CallLogic logic;
//
//   // final logic = Get.find<CallLogic>();
//   // final logic = Get.put(CallLogic.init(uid: this.uid, name: name, icon: icon, state: state, type: type));
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Stack(
//           children: [
//             logic.smallView.value
//                 ? _buildSmallView()
//                 : Material(
//                     // color: Colors.transparent,
//                     color: PageStyle.c_03091C,
//                     child: Obx(() => Stack(
//                           children: [
//                             _buildBackgroundView(),
//                             logic.isVoiceCall()
//                                 ? Stack(
//                                     children: [
//                                       if (logic.state.value == CallState.CALL)
//                                         MakeVoiceCallView(),
//                                       if (logic.state.value ==
//                                           CallState.CALLING)
//                                         VoiceCallingView(),
//                                       if (logic.state.value == CallState.CALLED)
//                                         BeInvitedVoiceCallView(),
//                                       if (logic.state.value ==
//                                           CallState.CONNECTING)
//                                         VoiceConnectingView(),
//                                     ],
//                                   )
//                                 : Stack(
//                                     children: [
//                                       if (logic.state.value == CallState.CALL)
//                                         MakeVideoCallView(),
//                                       if (logic.state.value ==
//                                           CallState.CALLING)
//                                         VideoCallingView(),
//                                       if (logic.state.value == CallState.CALLED)
//                                         BeInvitedVideoCallView(),
//                                       if (logic.state.value ==
//                                           CallState.CONNECTING)
//                                         VideoConnectingView(),
//                                     ],
//                                   ),
//                             _buildLocalView(),
//                           ],
//                         )),
//                   ),
//           ],
//         ));
//   }
//
//   Widget _buildSmallView() => logic.smallView.value == true
//       ? Positioned(
//           top: 48.h,
//           right: 13.w,
//           child: GestureDetector(
//             onDoubleTap: () => logic.toggleWindowSize(),
//             child: Container(
//               width: 84.w,
//               height: 123.h,
//               decoration: BoxDecoration(
//                 color: PageStyle.c_03091C,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//           ),
//         )
//       : SizedBox();
//
//   Widget _buildLocalView() => logic.state.value == CallState.CALLING &&
//           logic.callCtrl.localVideoEnabled.value
//       ? Positioned(
//           left: logic.currentX.value,
//           top: logic.currentY.value,
//           child: GestureDetector(
//             onPanUpdate: (e) {
//               logic.updateXY(e.delta.dx, e.delta.dy);
//             },
//             child: Container(
//               width: 107.w,
//               height: 197.h,
//               child: RTCVideoView(
//                 logic.callCtrl.localStream!.renderer,
//                 objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//               ),
//             ),
//           ),
//         )
//       : SizedBox();
//
//   Widget _buildBackgroundView() => logic.state.value == CallState.CALLING
//       ? RTCVideoView(
//           logic.callCtrl.remoteStreams[0].renderer,
//           objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//         )
//       : SizedBox();
// }
