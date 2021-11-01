// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:openim_enterprise_chat/src/res/images.dart';
// import 'package:openim_enterprise_chat/src/res/strings.dart';
// import 'package:openim_enterprise_chat/src/res/styles.dart';
// import 'package:openim_enterprise_chat/src/widgets/call_view.dart';
//
// import '../call_logic.dart';
//
// class VideoConnectingView extends StatelessWidget {
//   VideoConnectingView({Key? key, required this.logic}) : super(key: key);
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
//           top: 54.h,
//           width: 375.w,
//           child: Text(
//             StrRes.callConnecting,
//             style: PageStyle.ts_FFFFFF_18sp,
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
//               Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () => logic.switchCamera(),
//                     behavior: HitTestBehavior.translucent,
//                     child: Image.asset(
//                       ImageRes.ic_callSwitchCamera,
//                       width: 64.w,
//                       height: 64.h,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 16.h,
//                   ),
//                   Text(
//                     StrRes.switchCamera,
//                     style: PageStyle.ts_FFFFFF_16sp,
//                   )
//                 ],
//               ),
//               Spacer(),
//               Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () => logic.hangup(),
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
//                     StrRes.hangup,
//                     style: PageStyle.ts_FFFFFF_16sp,
//                   )
//                 ],
//               ),
//               Spacer(),
//               Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () => logic.toVoice(),
//                     behavior: HitTestBehavior.translucent,
//                     child: Image.asset(
//                       ImageRes.ic_callConvert,
//                       width: 64.w,
//                       height: 64.h,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 16.h,
//                   ),
//                   Text(
//                     StrRes.convertVoice,
//                     style: PageStyle.ts_FFFFFF_16sp,
//                   )
//                 ],
//               ),
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
