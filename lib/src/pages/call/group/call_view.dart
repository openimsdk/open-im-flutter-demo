// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:openim_enterprise_chat/src/core/controller/call_controller.dart';
// import 'package:openim_enterprise_chat/src/pages/call/group/view/be_invited_call_view.dart';
// import 'package:openim_enterprise_chat/src/pages/call/group/view/stream_renderer_view.dart';
// import 'package:openim_enterprise_chat/src/res/images.dart';
// import 'package:openim_enterprise_chat/src/res/strings.dart';
// import 'package:openim_enterprise_chat/src/res/styles.dart';
//
// import 'call_logic.dart';
//
// class GroupCallPage extends StatelessWidget {
//   final logic = Get.find<GroupCallLogic>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: PageStyle.c_03091C,
//       child: Obx(() => Column(
//             children: [
//               if (CallState.CALLED == logic.state.value)
//                 BeInvitedGroupCallView(),
//               if (CallState.CALLED != logic.state.value)
//                 Expanded(
//                   child: Column(
//                     children: [
//                       _buildTitleBar(),
//                       GroupStreamRendererView(),
//                       _buildCallTimeView(),
//                       _buildButtonGroup(),
//                     ],
//                   ),
//                 )
//             ],
//           )),
//     );
//   }
//
//   Widget _buildCallTimeView() => Obx(() => Padding(
//         padding: EdgeInsets.only(top: 3.h, bottom: 17.h),
//         child: Text(
//           logic.callCtrl.callingTime.value,
//           style: PageStyle.ts_EDEDED_14sp,
//         ),
//       ));
//
//   Widget _buildTitleBar() => Container(
//         height: 45.h,
//         margin: EdgeInsets.only(top: 57.h),
//         padding: EdgeInsets.symmetric(horizontal: 12.w),
//         child: Row(
//           children: [
//             GestureDetector(
//               onTap: () => Get.back(),
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: Image.asset(
//                   ImageRes.ic_back,
//                   color: PageStyle.c_FFFFFF,
//                   width: 12.w,
//                   height: 21.h,
//                 ),
//               ),
//             ),
//             Spacer(),
//             Visibility(
//               visible: !logic.isVoiceCall(),
//               child: GestureDetector(
//                 onTap: () => logic.toggleCamera(),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10.w),
//                   child: Image.asset(
//                     logic.callCtrl.localVideoEnabled.value
//                         ? ImageRes.ic_openCallVideo
//                         : ImageRes.ic_closeCallVideo,
//                     color: PageStyle.c_FFFFFF,
//                     width: logic.callCtrl.localVideoEnabled.value ? 27.w : 33.w,
//                     height:
//                         logic.callCtrl.localVideoEnabled.value ? 15.h : 30.h,
//                   ),
//                 ),
//               ),
//             ),
//             /*Visibility(
//               child: GestureDetector(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10.w),
//                   child: Image.asset(
//                     ImageRes.ic_AddCallMember,
//                     color: PageStyle.c_FFFFFF,
//                     width: 21.w,
//                     height: 21.h,
//                   ),
//                 ),
//               ),
//             ),*/
//           ],
//         ),
//       );
//
//   Widget _buildButtonGroup() => Container(
//         margin: EdgeInsets.only(bottom: 38.h),
//         child: logic.isVoiceCall()
//             ? _buildVoiceButtonGroup()
//             : _buildVideoButtonGroup(),
//       );
//
//   Widget _buildVoiceButtonGroup() => Row(
//         children: [
//           SizedBox(
//             width: 40.w,
//           ),
//           _buildButton(
//             onTap: () => logic.toggleMuteLocal(),
//             icon: logic.callCtrl.localVoiceEnabled.value
//                 ? ImageRes.ic_callMicOpen
//                 : ImageRes.ic_callMicClose,
//             text: logic.callCtrl.localVoiceEnabled.value
//                 ? StrRes.micOpen
//                 : StrRes.micClose,
//           ),
//           Spacer(),
//           _buildButton(
//             onTap: () => logic.hangup(),
//             icon: ImageRes.ic_callHangup,
//             text: StrRes.hangup,
//           ),
//           Spacer(),
//           _buildButton(
//             onTap: () => logic.toggleSpeaker(),
//             icon: logic.callCtrl.speakerEnabled.value
//                 ? ImageRes.ic_callSpeakerOpen
//                 : ImageRes.ic_callSpeakerClose,
//             text: logic.callCtrl.speakerEnabled.value
//                 ? StrRes.speakerOpen
//                 : StrRes.speakerClose,
//           ),
//           SizedBox(
//             width: 40.w,
//           ),
//         ],
//       );
//
//   Widget _buildVideoButtonGroup() => Row(
//         children: [
//           SizedBox(
//             width: 40.w,
//           ),
//           _buildButton(
//             onTap: () => logic.toggleMuteLocal(),
//             icon: logic.callCtrl.localVoiceEnabled.value
//                 ? ImageRes.ic_callMicOpen
//                 : ImageRes.ic_callMicClose,
//             text: logic.callCtrl.localVoiceEnabled.value
//                 ? StrRes.micOpen
//                 : StrRes.micClose,
//           ),
//           Spacer(),
//           _buildButton(
//             onTap: () => logic.hangup(),
//             icon: ImageRes.ic_callHangup,
//             text: StrRes.hangup,
//           ),
//           Spacer(),
//           _buildButton(
//             onTap: () => logic.switchCamera(),
//             icon: ImageRes.ic_callSwitchCamera,
//             text: StrRes.switchCamera,
//           ),
//           SizedBox(
//             width: 40.w,
//           ),
//         ],
//       );
//
//   Widget _buildButton({
//     required String icon,
//     required String text,
//     required Function() onTap,
//   }) =>
//       Column(
//         children: [
//           GestureDetector(
//             onTap: onTap,
//             behavior: HitTestBehavior.translucent,
//             child: Image.asset(
//               icon,
//               width: 64.w,
//               height: 64.h,
//             ),
//           ),
//           SizedBox(
//             height: 16.h,
//           ),
//           Text(
//             text,
//             style: PageStyle.ts_999999_16sp,
//           )
//         ],
//       );
// }
