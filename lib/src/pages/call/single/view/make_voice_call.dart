// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:openim_enterprise_chat/src/res/images.dart';
// import 'package:openim_enterprise_chat/src/res/strings.dart';
// import 'package:openim_enterprise_chat/src/res/styles.dart';
// import 'package:openim_enterprise_chat/src/widgets/avatar_view.dart';
// import 'package:openim_enterprise_chat/src/widgets/call_view.dart';
//
// import '../call_logic.dart';
//
// class MakeVoiceCallView extends StatelessWidget {
//   MakeVoiceCallView({Key? key, required this.logic}) : super(key: key);
//
//   // final logic = Get.find<CallLogic>();
//   final CallLogic logic;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           top: 53.h,
//           left: 26.w,
//           child: GestureDetector(
//             onTap: () => logic.toggleWindowSize(),
//             behavior: HitTestBehavior.translucent,
//             child: Image.asset(
//               ImageRes.ic_callClose,
//               width: 27.w,
//               height: 26.h,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 152.h,
//           width: 375.w,
//           child: Container(
//             alignment: Alignment.center,
//             child: AvatarView(
//               size: 90.h,
//               url: logic.icon,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 252.h,
//           width: 375.w,
//           child: Text(
//             logic.name,
//             style: PageStyle.ts_FFFFFF_24sp,
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Positioned(
//           top: 314.h,
//           width: 375.w,
//           child: Text(
//             StrRes.waitingAcceptVoiceCall,
//             style: PageStyle.ts_666666_18sp,
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Positioned(
//           top: 648.h,
//           width: 375.w,
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 40.w,
//               ),
//               Obx(() => Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () => logic.toggleMuteLocal(),
//                         behavior: HitTestBehavior.translucent,
//                         child: Image.asset(
//                           logic.callCtrl.localVoiceEnabled.value
//                               ? ImageRes.ic_callMicOpen
//                               : ImageRes.ic_callMicClose,
//                           width: 64.w,
//                           height: 64.h,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 16.h,
//                       ),
//                       Text(
//                         logic.callCtrl.localVoiceEnabled.value
//                             ? StrRes.micOpen
//                             : StrRes.micClose,
//                         style: PageStyle.ts_999999_16sp,
//                       )
//                     ],
//                   )),
//               Spacer(),
//               Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () => logic.cancel(),
//                     behavior: HitTestBehavior.translucent,
//                     child: Image.asset(
//                       ImageRes.ic_callHangup,
//                       width: 64.w,
//                       height: 64.h,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 16.h,
//                   ),
//                   Text(
//                     StrRes.cancel,
//                     style: PageStyle.ts_999999_16sp,
//                   )
//                 ],
//               ),
//               Spacer(),
//               Obx(() => Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () => logic.toggleSpeaker(),
//                         behavior: HitTestBehavior.translucent,
//                         child: Image.asset(
//                           logic.callCtrl.speakerEnabled.value
//                               ? ImageRes.ic_callSpeakerOpen
//                               : ImageRes.ic_callSpeakerClose,
//                           width: 64.w,
//                           height: 64.h,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 16.h,
//                       ),
//                       Text(
//                         logic.callCtrl.speakerEnabled.value
//                             ? StrRes.speakerOpen
//                             : StrRes.speakerClose,
//                         style: PageStyle.ts_999999_16sp,
//                       )
//                     ],
//                   )),
//               SizedBox(
//                 width: 40.w,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
