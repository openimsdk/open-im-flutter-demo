// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_ion/src/_library/apps/biz/proto/biz.pbenum.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:get/get.dart';
// import 'package:openim_enterprise_chat/src/core/controller/call_controller.dart';
// import 'package:openim_enterprise_chat/src/models/call_records.dart';
// import 'package:openim_enterprise_chat/src/pages/call/single/view/be_invited_video_call.dart';
// import 'package:openim_enterprise_chat/src/pages/call/single/view/be_invited_voice_call.dart';
// import 'package:openim_enterprise_chat/src/pages/call/single/view/make_video_call.dart';
// import 'package:openim_enterprise_chat/src/pages/call/single/view/make_voice_call.dart';
// import 'package:openim_enterprise_chat/src/pages/call/single/view/video_calling.dart';
// import 'package:openim_enterprise_chat/src/pages/call/single/view/video_connecting.dart';
// import 'package:openim_enterprise_chat/src/pages/call/single/view/voice_calling.dart';
// import 'package:openim_enterprise_chat/src/pages/call/single/view/voice_connecting.dart';
// import 'package:openim_enterprise_chat/src/res/styles.dart';
// import 'package:openim_enterprise_chat/src/utils/data_persistence.dart';
//
// import 'avatar_view.dart';
//
// class IMCallView {
//   IMCallView._();
//
//   static OverlayEntry? _holder;
//
//   static void close() {
//     if (_holder != null) {
//       _holder?.remove();
//       _holder = null;
//     }
//   }
//
//   static void call({
//     required String uid,
//     required String name,
//     String? icon,
//     required CallState state,
//     required String type,
//   }) {
//     close();
//     _holder = OverlayEntry(
//         builder: (context) => _CallView(
//               uid: uid,
//               name: name,
//               icon: icon,
//               state: state,
//               type: type,
//             ));
//     Overlay.of(Get.overlayContext!)!.insert(_holder!);
//   }
// }
//
// class _CallView extends StatefulWidget {
//   const _CallView({
//     Key? key,
//     required this.uid,
//     required this.name,
//     this.icon,
//     required this.state,
//     required this.type,
//   }) : super(key: key);
//
//   final String uid;
//   final String name;
//   final String? icon;
//   final CallState state;
//   final String type;
//
//   @override
//   _CallViewState createState() => _CallViewState();
// }
//
// class _CallViewState extends State<_CallView> {
//   late CallLogic logic;
//
//   @override
//   void initState() {
//     logic = CallLogic.create(
//       uid: widget.uid,
//       name: widget.name,
//       icon: widget.icon,
//       $state: widget.state,
//       $type: widget.type,
//     );
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     logic.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Stack(
//           children: [
//             AnimatedScale(
//               scale: logic.smallView.value ? 0 : 1,
//               alignment: Alignment(0.9, -0.8),
//               duration: Duration(milliseconds: 200),
//               onEnd: () {},
//               child: Material(
//                 color: PageStyle.c_03091C,
//                 child: Obx(
//                   () => Stack(
//                     children: [
//                       _buildRemoteView(),
//                       logic.isVoiceCall()
//                           ? _buildVoiceView()
//                           : _buildVideoView(),
//                       if (!logic.isVoiceCall()) _buildLocalView(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             _buildSmallView(),
//           ],
//         ));
//   }
//
//   Widget _buildVoiceView() => Stack(
//         children: [
//           if (logic.state.value == CallState.CALL)
//             MakeVoiceCallView(logic: logic),
//           if (logic.state.value == CallState.CALLING)
//             VoiceCallingView(logic: logic),
//           if (logic.state.value == CallState.CALLED)
//             BeInvitedVoiceCallView(logic: logic),
//           if (logic.state.value == CallState.CONNECTING)
//             VoiceConnectingView(logic: logic),
//         ],
//       );
//
//   Widget _buildVideoView() => Stack(
//         children: [
//           if (logic.state.value == CallState.CALL)
//             MakeVideoCallView(logic: logic),
//           if (logic.state.value == CallState.CALLING)
//             VideoCallingView(logic: logic),
//           if (logic.state.value == CallState.CALLED)
//             BeInvitedVideoCallView(logic: logic),
//           if (logic.state.value == CallState.CONNECTING)
//             VideoConnectingView(logic: logic),
//         ],
//       );
//
//   Widget _buildSmallView() => Positioned(
//         top: 48.h,
//         right: 13.w,
//         child: AnimatedOpacity(
//           opacity: logic.smallView.value ? 1 : 0,
//           duration: Duration(milliseconds: 200),
//           child: GestureDetector(
//             onDoubleTap: () => logic.toggleWindowSize(),
//             child: Container(
//               width: 84.w,
//               height: 123.h,
//               decoration: BoxDecoration(
//                 color: PageStyle.c_03091C,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AvatarView(
//                       size: 48.h,
//                       url: logic.icon,
//                     ),
//                     SizedBox(
//                       height: 6.h,
//                     ),
//                     Text(
//                       logic.state.value == CallState.CALL
//                           ? '等待接听'
//                           : (logic.state.value == CallState.CALLING
//                               ? '通话中'
//                               : (logic.state.value == CallState.CONNECTING
//                                   ? '连接中'
//                                   : (logic.state.value == CallState.CALLED
//                                       ? '邀请你通话'
//                                       : ''))),
//                       style: PageStyle.ts_FFFFFF_12sp,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//
//   Widget _buildLocalView() => logic.state.value == CallState.CALLING
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
//   Widget _buildRemoteView() => logic.state.value == CallState.CALLING
//       ? RTCVideoView(
//           logic.callCtrl.remoteStreams[0].renderer,
//           objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//         )
//       : SizedBox();
// }
//
// class CallLogic {
//   final callCtrl = Get.find<CallController>();
//   var smallView = false.obs;
//   var type = "".obs;
//   var defaultType = "";
//   late String uid;
//   late String name;
//   String? icon;
//   var state = CallState.CALL.obs;
//   var currentX = 0.0.obs;
//   var currentY = 0.0.obs;
//
//   CallLogic.create({
//     required this.uid,
//     required this.name,
//     this.icon,
//     required CallState $state,
//     required String $type,
//   }) {
//     currentX.value = 255.w;
//     currentY.value = 48.h;
//     state.value = callCtrl.state = $state;
//     type.value = defaultType = $type;
//     callCtrl.streamType = streamType;
//     print('-----------CallLogic init---$state-----------------');
//     callCtrl.onStateChanged = (state_) {
//       print('-----------CallLogic listen---$state_-----------------');
//       state.value = state_;
//       switch (state_) {
//         case CallState.CANCEL:
//         case CallState.BE_CANCELED:
//         case CallState.HANGUP:
//         case CallState.BE_HANGUP:
//         case CallState.REJECT:
//         case CallState.BE_REJECTED:
//           _addCallRecords(state_, $state);
//           IMCallView.close();
//           break;
//         default:
//           break;
//       }
//     };
//
//     if (state.value == CallState.CALL) {
//       callCtrl.mediaHandle(MediaOperation.Dial, [uid], streamType, sessionType);
//     }
//   }
//
//   void _addCallRecords(CallState cur, CallState init) {
//     DataPersistence.addCallRecords(CallRecords(
//       uid: uid,
//       name: name,
//       icon: icon,
//       success: cur == CallState.HANGUP || cur == CallState.BE_HANGUP,
//       date: DateTime.now().millisecondsSinceEpoch,
//       type: isVoiceCall() ? 'voice' : 'video',
//       incomingCall: init == CallState.CALLED,
//       duration: callCtrl.callingDuration,
//     ));
//   }
//
//   void toggleWindowSize() {
//     smallView.value = !smallView.value;
//     print('---------------------smallView:${smallView.value}');
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
//     // callCtrl.trackControl();
//     // type.value = callCtrl.localVideoEnabled.value ? 'video' : 'voice';
//     // type.value = 'video';
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
//   void dispose() {
//     callCtrl.close();
//   }
// }
